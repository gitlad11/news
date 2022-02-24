const mongoose = require('mongoose')

const Schema = mongoose.Schema

var comentSchema = new Schema({
	text : {
		type : String, require : false
	},
	from : {
		type : String, require : true
	},
	to_post : { 
		type : String, require : true
	},
    date : { 
		type : Date
	},
    
})
module.exports = mongoose.model('Coment' , comentSchema)