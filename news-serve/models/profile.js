const mongoose = require('mongoose')
const bcrypt = require('bcrypt')

const Schema = mongoose.Schema

var profileSchema = new Schema({
    email : {
		type : String, require: true, maxLength: 40
	},
    image : {
        type : String, require: true, maxLength: 40
    },
    
	password : {
        type : String, require: true
    },
    liked : [],
    posts : [],
    following : []
})

profileSchema.methods.comparePassword = async function comparePassword(password, callback){
    var hash = await bcrypt.compare(password, this.password);
    if(hash){
        return true
    } else {
        return false
    }
  };

profileSchema.pre("save", function(next){
	if(!this.isModified("password")){
		return next();
	}
	this.password = bcrypt.hashSync(this.password, 10);
	next();
})

module.exports = mongoose.model('Profile', profileSchema)