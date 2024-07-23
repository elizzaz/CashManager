const decodeUser = require("../Middlewares/decode_user")
const user = require("../controllers/users_controller")
module.exports = (app) => {
    const router = require("express").Router();
    const bodyParser = require("body-parser");
    router.use(bodyParser.urlencoded({extended: true}));
    router.use(bodyParser.json());
    app.use('/api/users', router);


    router.post('/create', user.create);
    router.get('/me', decodeUser, user.getUserMe)
    router.get('/user/:id', (req, res) => user.getUser(req, res));
    router.get('/', (req, res) => user.getAllUser(req, res));
    router.post('/login', (req, res) => user.login(req, res));
    router.put('/update/:id', (req, res) => user.updateUser(req, res));
    router.delete('/delete/:id', (req, res) => user.deleteUser(req, res));
}
