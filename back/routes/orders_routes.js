const order = require('../controllers/orders_controller');
const bodyParser = require('body-parser')
const decodeUser = require("../Middlewares/decode_user")
module.exports = (app) => {
  const router = require("express").Router();

  const bodyParser = require("body-parser");
  router.use(bodyParser.urlencoded({extended: true}));
  router.use(bodyParser.json());
  app.use('/api/orders', router);

  router.post('/', decodeUser, order.create);
  router.get('/', order.findAll);
  router.get('/:id', order.findOne);
  router.put('/:id', order.update);
  router.delete('/:id', order.delete);

}
