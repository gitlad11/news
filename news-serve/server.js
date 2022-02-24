const express = require("express");
const mongoose = require("mongoose");
const fs = require("fs");
const path = require("path");
const moment = require('moment');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const cloudinary = require('cloudinary').v2
const config = require('./config')
const { CloudinaryStorage } = require('multer-storage-cloudinary')

const Profile = require('./models/profile')
const Favorite = require('./models/favorite')
const Coment = require('./models/coment')
const Post = require('./models/post')
const Follow = require('./models/follow')

var PORT = process.env.PORT || 3002
var HOST = process.env.HOST || 'http://localhost'
var MongoURI = 'mongodb+srv://admin:administration@cluster0.pcwin.mongodb.net/datab?retryWrites=true&w=majority'



var app = express();
var cors = require('cors');
app.use(cors({
    origin: ["http://localhost:8200", "http://127.0.0.1:8200"],
    credentials: true,
}));

////MIDDLEWARE, static folders used in build
app.use(express.json())
app.use(express.urlencoded({ extended : true }))
app.use(express.Router())
app.use(express.static(__dirname + '/avatars'))
//app.use(expres.static(__dirname + '/build'))
app.use(express.static(__dirname + '/public'))

//please don't use my cloud XD
cloudinary.config({
	cloud_name : config.CLN || process.env.CLOUD_NAME,
	api_key : config.CLK || process.env.CLOUD_KEY,
	api_secret : config.CLS || process.env.CLOUD_SECRET
})
const Storage = new CloudinaryStorage({
	cloudinary : cloudinary,
	params : {
		folder : 'samples'
	},
	filename : (req, file, callback) => {
		callback(null, file.fieldname + '-' + Date.now())
	}
})
////НЕ РАБОТАЕТ С FLUTTER,РАБОТАЕТ НА REACT
var imgFilter = (req, file , callback) =>{
	if(file.mimetype === "image/png" ||
	 	file.mimetype === "image/jpg" || 
	 	file.mimetype === "image/jpeg"){
		callback(null, true)
	} else {
		callback(null , false)
	}
}


var imgHandler = multer({ storage : Storage })

//////////ROUTER/////////////////////////
app.get('/', (req, res) => {
	res.send('Welcome to chat api!')
})

app.post('/registration', async (req, res) => {
  if(req.body){
    if(req.body.email){
      await Profile.findOne({ email : req.body.email }).then((profile) => {
        if(!profile || profile == null){
          var profile = new Profile({
            email : req.body.email,
            image : null,
            liked : [],
            following : [],
            password : req.body.password,
          })
          profile.save().then((profile) =>{
              return res.status(200).json({'success' : true,'message' : 'Профиль создан!', 'profile' : profile })
            }).catch(error => {
              return res.status(500).json({'success' : false , 'message' : error.message })
            })

        } else {
          return res.json({ 'success' : false , 'message' : "почта занята!" })
        }
      })
    }
  }
})


app.post('/login',  (req, res) =>{
  if(req.body){
		Profile.findOne({ email : req.body.email }).then((profile) =>{
			if(!profile){
        console.log("profile is not found")
				return res.status(404).json({ 'success' : false, 'error' : true, 'message' : 'профиль не найден!' })
			} else {
        console.log("profile is found")
				const token = jwt.sign({ id : profile.id }, "secret", { expiresIn : 1000000 })
				return res.send({ 'success' : true , 'error' : false, 'token' : token })
			}
		})
  }
})


app.post('/image', imgHandler.single('image'), (req, res) => {
  if(req.file){
    Profile.findOneAndUpdate({ email : req.body.user }, { image : req.file.path }).then((profile) => {
      if(profile){
       Profile.findOne({ email : req.body.user }).then((profile) => { 
         return res.send(profile)
        })
      }
    })
  }
  return res.send('image uploaded')
})


app.post('/authenticate', async ( req, res) =>{
  const token = req.body.token
  if(!token){ 
    return res.status(401).json({ message : 'you are not authenticated' })
    } else {
      const verified = jwt.verify(token , "secret")
        if(!verified){ return res.json({ 'success' :  false }) }
      const profile = await Profile.findById(verified.id)
        if(!profile){ return res.json({user : {}}) }
	
      return res.json({ 'success' : true, "profile" : profile })	
  }	
})

app.post('/create_post', imgHandler.single('image'), (req, res) => {
    
    if(req.file){
      var post = new Post({
        author : req.body.author,
        title : req.body.title,
        image : req.file.path,
        text : req.body.text,
        date : req.body.date,
      })
    } else {
      var post = new Post({
        author : req.body.author,
        title : req.body.title,
        image : null,
        text : req.body.text,
        date : req.body.date,
      })
    }
    post.save().then((post) =>{
      Profile.findOneAndUpdate({"email" : req.body.author }, { $push : { posts : { id : post.id }  } }).then((profile) => {
        return res.status(200).json({'success' : true })
      })
    }).catch(error => {
      console.log(error)
      return res.status(500).json({'success' : false , 'message' : error.message })
    })
})

app.post('/avatar', (req, res) => {
  if(req.body){
    Profile.findOne({ email : req.body.email }).then((profile) => { 
      return res.send(profile.image)
     })
  }
})


app.post('/post_like', (req, res) => {
  if(req.body){
    const favorite = new Favorite({
      post_id : req.body.id,
      email : req.body.email,
    })
    Favorite.findOne({ email : req.body.email, post_id : req.body.id }).then((fav) => {
        if(!fav){
          favorite.save().then((favorite) => {
            Post.findOneAndUpdate({ "_id" : req.body.id }, { $push : { liked : { email : req.body.email, image : req.body.image } }},
            (err, result) =>{
              Profile.findOneAndUpdate({ "email" : req.body.email }, { $push : { liked : { id : req.body.id } } }).then((profile) => {
                  console.log(profile)
                  if(err){ 
                    return res.status(200).send({"success" : false, "message" : "произошла ошибка!"})
                   }
                  else { 
                    return res.status(200).send({ "success" : true, "message" : "Добавлено!" })
                   }
              })
            })
          })
        } else {
          Favorite.findOneAndDelete({ post_id : req.body.id }).then((deleted) => {
            Post.findOneAndUpdate( {"_id": req.body.id,}, { $pull: {liked : { email :  req.body.email } }}).then((deleted) => {
              Profile.findOneAndUpdate( {"email": req.body.email }, { $pull: { liked : { id : req.body.id } }}).then((deleted) => {
                console.log(deleted)
                return res.status(200).send({ "success" : false, "message" : "Удаленно!" })
              })
            })
          })
        }
    })
  }
})

app.post('/favorite', (req, res) => {
  if(req.body.items){
    Post.find({'_id' : { $in : req.body.items }}).then((posts) => {
      console.log(posts)
     return res.json({ "success" : true, "favorite" : posts })
    })
  } else {
    return res.json({ 'success' : false, "favorite" : [] })
  }
})

app.post('/posts', (req, res) => {
  if(req.body.items){
    Post.find({ 'id' : req.body.items }).then((posts) => {
      console.log(posts)
      return res.json({ "success" : true, "favorite" : posts })
    })
  } else {
    return res.json({ 'success' : false, "favorite" : [] })
  }
})


app.post('/post_coment', (req, res) => {
  if(req.body){
    const coment = new Coment({
      from : req.body.email,
      to_post : req.body.to_post,
      text : req.body.text,
      date : req.body.date
    })
    coment.save().then((coment) => {
      Post.findOneAndUpdate({ "_id" : req.body.id }, { $push : { coments : { from : req.body.email, image : req.body.image, text : req.body.text, date : req.body.date } }},
      (err, result) =>{
        if(err){ 
          console.log(err)
          return res.status(200).send({"success" : false, "message" : "произошла ошибка!"})
         }
        else { 
          Post.findOne({ "_id" : req.body.id }).then((post) => {
            return res.status(200).send({ "success" : true, "coments" : post.coments }) 
          })
        }
      })
    })
  }
})

app.post('/following', (req, res) => {
  if(req.body){
    const follow = new Follow({
      on_email : req.body.on,
      email : req.body.from,
    })
    Follow.findOne({ on_email : req.body.on , email : req.body.from }).then((foll) => {

        if(!foll){
    
          follow.save().then((follow) => {
          Profile.findOneAndUpdate({ 'email' : req.body.on }, { $push : { following : { "email" : req.body.from } } }).then((profile) => {
         
            if(profile){
              return res.send({ "success" : true,"follow" : true, "message" : "Вы подписались!" })
            } else {
              return res.send({ "success" : false, "message" : "произошла ошибка!" })
            }
          })
        
        })
      } else {
      
          Follow.findOneAndDelete({ on_email : req.body.on, email : req.body.from }).then((follow) => {
            console.log(follow)
            Profile.findOneAndUpdate({ email : req.body.on }, { $pull : { following : { "email" : req.body.from } } }).then((profile) => {
              return res.send({ "success" : true, "follow" : false, "message" : "Вы отписались!" })
            })
          }).catch((error) => console.log(error))
        }
    })
  }
})


app.get('/posts', (req, res) => {
    const Posts = Post.find({}).then((posts) => {
      return res.status(200).json(posts)
    })
})

app.get('/profiles', (req, res) => {
    const profiles = Profile.find({}).then((profiles) => {
      return res.status(200).json(profiles)
    })
})


mongoose.connect(MongoURI,
  {useNewUrlParser: true, useUnifiedTopology : true}, (error) =>{
  mongoose.Promise = global.Promise
  mongoose.connection.on('error', error => {
    console.log(`error with mongodb :` + error)
  })
  console.log('connected to collection')
  })
app.listen(PORT, console.log(`server is running on ${PORT}`))