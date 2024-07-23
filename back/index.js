const express = require('express')
const app = express()
const port = 8080
//const cors = require("cors");
const JsonWebToken = require('jsonwebtoken');
const bodyParser = require("body-parser");
const Bcrypt = require('bcryptjs')

let indexRouter = require('./routes/route');
app.use('/', indexRouter);
require('./routes/user_route')(app);
require('./routes/client_route')(app);
require('./routes/categories_routes')(app);
require('./routes/products_routes')(app);
require('./routes/orders_routes')(app);

const mongoose = require('mongoose')
require('dotenv').config()

mongoose.
    connect(process.env.MONGO_URI, {UseNewUrlParser:true})
    .then(() => console.log('DB CONNECT'))
    .catch(err => console.error(err))

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Starting serveur at http://localhost:${port}`);
});
