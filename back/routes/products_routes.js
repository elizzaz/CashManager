const product = require('../controllers/products_controller');
module.exports = (app) => {
  const router = require("express").Router();

  const bodyParser = require("body-parser");
  router.use(bodyParser.urlencoded({extended: true}));
  router.use(bodyParser.json());
  app.use('/api/products', router);

  router.post('/', product.create);
  router.get('/', product.findAll);
  router.get('/barcode/:bar_code', product.findByBarCode);
  router.get('/categories/:category', product.findByCategory);
  router.get('/:id', product.findOne);
  router.put('/:id', product.update);
  router.delete('/:id', product.delete);

}
