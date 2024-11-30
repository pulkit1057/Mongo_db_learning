const UserModel = require('../model/user.model');
const UserService = require('../services/user.services')

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const successRes = await UserService.registerUser(email, password);

        return res.json({ status: true, success: 'User created successfully' })
    } catch (error) {
        return res.json({ status: false, message: 'Some problem occured' })
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const user = await UserService.checkuser(email)

        if (!user) {
            return res.status(500).json({ status: false, message: "User does not exists" })
        }

        const isMatch = await user.comparePassword(password);

        if (isMatch === false) {
            return res.status(500).json({ status: false, message: "password incorrect" })
        }

        const tokenData = { _id: user._id, email: user.email }

        const token = await UserService.generateToken(tokenData, "12345", '1h');

        return res.status(200).json({ status: true, token: token });
    } catch (error) {
        return res.status(500).json({ status: false, message: "password incorrect" })
    }
}