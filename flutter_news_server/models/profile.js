const mongoose = require('mongoose')

const Schema = mongoose.Schema

var profileSchema = new Schema({
    email : {
		type : String, require: true, maxLength: 40
	},
    image : {
        type : String, require: true, maxLength: 40
    },
    
	password : {
        type : String, require: true, maxLength: 80
    },
    liked : [],
    posts : [],
    following : []
})

module.exports = mongoose.model('Profile', profileSchema)