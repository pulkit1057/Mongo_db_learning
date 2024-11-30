const router = require('express').Router()
const UserController = require('../controllers/user.controller')

router.post('/registeration',UserController.register)
router.post('/login',UserController.login)

module.exports = router