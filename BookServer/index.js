const express = require('express')
const app = express()
const { v4: uuidv4 } = require('uuid');
const { Sequelize, DataTypes } = require('sequelize');

//book: db name
//root: username
//https://sequelize.org/master/manual/getting-started.html#connecting-to-a-database
const sequelize = new Sequelize('book', 'root', '', {
    host: 'localhost',
    dialect: 'mysql'
  });
 
const Book = sequelize.define('Book', {
    id: {
        type: DataTypes.UUIDV4,
        primaryKey:true,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    description: {
        type: DataTypes.STRING,
        allowNull: true
    },
    createdAt:{
        type: DataTypes.DATE(6),
    },
    updatedAt:{ 
        type: DataTypes.DATE(6),
    }
},{
    timestamps:true
});


app.use(express.urlencoded({extended: true}));

app.get('/', (req, res) => {
    res.send("Hello");
});
app.post('/create_book',async(req,res)=>{
    try {
        console.log("CreateBook",req.body)
        const book = await Book.create({id:uuidv4(),name:req.body.name,description:req.body.description});
        res.send(book);
    } catch (error) {
        console.log("errorAdd",error);
        res.send(error)
    }
});

app.post('/update_book',async(req,res)=>{
    try {
        const book = await Book.findByPk(req.body.id);
        book.name = req.body.name;
        book.description = req.body.description;
        await book.save();
        res.send(book);
    } catch (error) {
        console.log('update-book-error',error);
        res.send(error);
    }
});

app.get('/get_book',async(req,res)=>{
    try {
        console.log("getBook",req.query);
        const book = await Book.findByPk(req.query.id);
        console.log(book);
        res.send(book);
    } catch (error) {
        console.error('Unable to connect to the database:', error);
        res.send(error);
    }
});
app.get('/get_books',async(req,res)=>{
    try {
        console.log("getBooks",req.query);
        const books = await Book.findAll();
        console.log(books);
        res.send(books);
    } catch (error) {
        console.error('Unable to connect to the database:', error);
        res.send(error);
    }
});

app.post('/update_book',async(req,res)=>{
    try {
        console.log("updateBook",req.body);
        const book = await Book.update({name:req.body.name},{where:{id:req.body.id}});
        res.send(book);
    } catch (error) {
        res.send(error)
    }
});
app.listen(8080)