const mongoose = require('mongoose')

const Schema = mongoose.Schema

var followSchema = new Schema({
    on_email : {
        type : String, require : true
    },
	email : {
        type : String, require : true
    },  
})
module.exports = mongoose.model('follow' , followSchema)