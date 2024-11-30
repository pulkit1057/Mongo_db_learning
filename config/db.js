const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb+srv://pulkitgargjobs:petriodophyta@cluster0.4okbu.mongodb.net/newToDo').on('open',()=>{
    console.log('Db connected');
}).on('error',()=>{
    console.log('Connection error');
});

module.exports = connection;