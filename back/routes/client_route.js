
module.exports = (app) => {
    const router = require("express").Router();

    const bodyParser = require("body-parser");
    router.use(bodyParser.urlencoded({extended: true}));
    router.use(bodyParser.json());

    const client = require("../controllers/clients_controller")
    app.use('/api/clients', router);

    router.get('/:id', client.getById);
    router.post('/', client.create);
    router.put('/:id', client.update);
    router.delete('/delete', client.delete);

}
