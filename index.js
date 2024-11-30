const app = require('./app')
const db = require('./config/db')
const UserModel = require('./model/user.model')
const ToDoModel = require('./model/todo.model')

const port = 5000

app.get('/',(req,res)=>{
    res.send('Hello World')
})

app.listen(port,()=>{
    console.log('Server listening to port 5000')
})