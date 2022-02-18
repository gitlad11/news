const mongoose = require('mongoose')

const Schema = mongoose.Schema

var favoriteSchema = new Schema({
    post_id : {

    },
	email : {
        type : String, require : true
    },  
})
module.exports = mongoose.model('favorite' , favoriteSchema)