const router = require('express').Router();
const todoController = require('../controllers/todo.controller')

router.post('/storeTodo',todoController.createToDo);
router.post('/getUserTodo',todoController.getUserTodo);
router.post('/deleteTodo',todoController.deleteTodo);

module.exports = router;