const ProductServices = require('../services/Products_service');

exports.create = async (req, res) => {
  try {
    const product = await ProductServices.createProduct({
      name: req.body.name,
      brand: req.body.brand,
      img_url: req.body.img_url,
      price: req.body.price,
      vat_percent: req.body.vat_percent,
      bar_code: req.body.bar_code,
      category: req.body.category
    })
    if (product.error === 11000) return res.status(422).send({error: product.error, message: product.message});
    if (product.error) return res.status(400).send({error: product.error, message: product.message});

    return res.status(200).send({message: `product ${req.body.name} is created`});
  } catch (e) {
    res.status(500).send({message: `Product not created`})
  }
}

exports.findOne = async (req, res) => {
  try {
    let product = await ProductServices.getProduct({_id: req.params.id})
    if (product.error) return res.status(404).send({message: product.error});
    return res.status(200).send(product);
  } catch (e) {
    res.status(500).send({message: 'Product not found'})
  }
};

exports.findAll = async (req, res) => {
  try {
    let products = await ProductServices.getAllProducts({})
    if (products.error) return res.status(404).send({message: products.error});

    return res.status(200).send(products);
  } catch (e) {
    res.status(500).send({message: 'Product not found'})
  }
};

exports.update = async (req, res) => {
  try {
    let product = await ProductServices.updateProduct(req.params.id, req.body)
    if (product.error) return res.status(400).send({ message: product.error })
    return res.status(200).send(product);
  } catch (e) {
    res.status(500).send({message: 'Product not updated'})
  }
};

exports.delete = async (req, res) => {
  try {
    let product = await ProductServices.deleteProduct({_id: req.params.id})
    if (product.error) return res.status(400).send({message: product.error})
    return res.status(200).send("Product deleted");
  } catch (e) {
    res.status(500).send({message: "Can't delete product"})
  }
};

exports.findByBarCode = async (req, res) => {
  try {
    let product = await ProductServices.getProduct({bar_code: req.params.bar_code})
    if (product.error) return res.status(404).send({message: product.error});
    return res.status(200).send(product);
  } catch (e) {
    res.status(500).send({message: 'Product not found'})
  }
};

exports.findByCategory = async (req, res) => {
  try {
    let products = await ProductServices.getAllProducts({category: req.params.category})
    if (products.error) return res.status(404).send({message: products.error});

    return res.status(200).send(products);
  } catch (e) {
    res.status(500).send({"message": "Product not found"})
  }
};
