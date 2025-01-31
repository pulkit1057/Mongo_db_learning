const UserModel = require('../model/user.model')
const jwt = require('jsonwebtoken')


class UserServices{
    static async registerUser(email,password){
        try{
            const createUser = new UserModel({email,password});
            return await createUser.save();
        }
        catch(err){
            // console.log('hello');
            return res.json({status: false,message:'user already exists'})
        }
    }

    static async checkuser(email){
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData,secretKey,jwt_expire){
        return jwt.sign(tokenData,secretKey,{expiresIn:jwt_expire})
    }
}

module.exports = UserServices