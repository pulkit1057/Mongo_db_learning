const db = require('../config/db');
const UserModel = require('./user.model')
const { Schema } = require('mongoose')


const todoSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName
    },
    title: {
        type: String,
        required: true
    },
    disc: {
        type: String,
        required: true
    }
})

const ToDoModel = db.model('todo',todoSchema)

module.exports = ToDoModel;