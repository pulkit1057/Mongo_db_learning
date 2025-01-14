const mongoose = require('mongoose')
const bcrypt = require('bcrypt')

const db = require('../config/db')

const {Schema} = mongoose

const userSchema = new Schema({
    email:{
        type:String,
        unique:true,
        lowecase:true,
        required:true
    },
    password:{
        type:String,
        required:true
    }
})


userSchema.pre('save',async function () {
    try {
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashPass = await bcrypt.hash(user.password,salt);

        user.password = hashPass;
    } catch (error) {
        throw error;
    }
})


userSchema.methods.comparePassword = async function(password){
    try {
        const isMatch = await bcrypt.compare(password,this.password);
        return isMatch;
    } catch (error) {
        // console.log('hello');
        throw error;
    }
}

const UserModel = db.model('user',userSchema);

module.exports = UserModel;