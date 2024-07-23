const categorie = require('../controllers/categories_controller');
module.exports = (app) => {
  const router = require("express").Router();

  const bodyParser = require("body-parser");
  router.use(bodyParser.urlencoded({extended: true}));
  router.use(bodyParser.json());
  app.use('/api/categories', router);

  router.post('/', categorie.create);
  router.get('/', categorie.findAll);
  router.get('/:id', categorie.findOne);
  router.put('/:id', categorie.update);
  router.delete('/:id', categorie.delete);

}
