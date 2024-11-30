const ToDoModel = require('../model/todo.model')

class ToDoServices{

    static async createTodo(userId,title,disc){
        const createTodo = new ToDoModel({userId,title,disc});
        return await createTodo.save();
    }

    static async getTodoData(userId){
        const todoData = await ToDoModel.find({userId});
        return todoData;
    }

    static async deleteTodoData(id){
        const deleted = await ToDoModel.findOneAndDelete({_id:id});
        return deleted;
    }
}

module.exports = ToDoServices