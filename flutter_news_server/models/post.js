const mongoose = require('mongoose')

const Schema = mongoose.Schema

var postSchema = new Schema({
    author : {
		type : String, require: true, maxLength: 80
	},
    title : {
		type : String, require: true, maxLength: 120
	},
    image : {
        type : String, require: true, maxLength: 999
    },
	text : {
        type : String, require: true, maxLength: 6999
    },
    coments : [],
    liked : [],
    date : {
        type : String, require: false, maxLength: 60
    }
})

module.exports = mongoose.model('Post', postSchema)