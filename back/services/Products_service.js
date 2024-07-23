const Product = require('../models/products_model');

exports.createProduct = async function (product) {
  try {
    return await Product.create(product);
  } catch (e) {
    console.log(e)
    return { error: e.code, message: e.message }
  }
}

exports.getProduct = async function (query) {
  try {
    return await Product.findOne(query).populate('category');
  } catch (e) {
    return { error: 'Error while getting product: ' + e.message }
  }
}

exports.getAllProducts = async function (query) {
  try {
    return await Product.find(query).populate('category');
  } catch (e) {
    return { error: 'Error while getting products: ' + e.message }
  }
}

exports.updateProduct = async function (query, body) {
  try {
    return await Product.findOneAndUpdate({_id: query}, body, {new: true});
  } catch (e) {
    // Product Errors
    return { error: 'Error while updating product: ' + e.message }
  }
}

exports.deleteProduct = async function (query) {
  try {
    return await Product.deleteOne(query);
  } catch (e) {
    // Product Errors
    return { error: 'Error while deleting product: ' + e.message }
  }
}
