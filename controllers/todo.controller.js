const ToDoServices = require('../services/todo.services');

exports.createToDo = async (req,res,next) => {
    try {
        const {userId,title,disc} = req.body;
        let todo = await ToDoServices.createTodo(userId,title,disc);

        res.json({status:true,success:todo})
    } catch (error) {
        next(err);
    }
}

exports.getUserTodo = async (req,res,next) => {
    try {
        const {userId} = req.body;
        let todo = await ToDoServices.getTodoData(userId);

        res.json({status:true,success:todo})
    } catch (error) {
        next(err);
    }
}

exports.deleteTodo = async (req,res,next) => {
    try {
        const {id} = req.body;
        let deleted = await ToDoServices.deleteTodoData(id);

        res.json({status:true,success:deleted})
    } catch (error) {
        next(err);
    }
}