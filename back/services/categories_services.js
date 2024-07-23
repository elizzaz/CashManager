const Category = require("../models/categories_model");

exports.createCategory = async function (categorie) {
  try {
    return await Category.create(categorie);
  } catch (e) {
    // User Errors
    return { error: 'Error while creating category: ' + e.message }
  }
}

exports.getCategory = async function (query) {
  try {
    return await Category.findOne(query);
  } catch (e) {
    return { error: 'Error while getting category: ' + e.message }
  }
}

exports.getAllCategories = async function (query) {
  try {
    return await Category.find(query);
  } catch (e) {
    return { error: 'Error while getting categories: ' + e.message }
  }
}

exports.updateCategory = async function (query, body) {
  try {
    return await Category.findOneAndUpdate({_id: query}, body, {new: true});
  } catch (e) {
    // Categorie Errors
    return { error: 'Error while updating category: ' + e.message }
  }
}

exports.deleteCategory = async function (query) {
  try {
    return await Category.deleteOne(query);
  } catch (e) {
    // Categorie Errors
    return { error: 'Error while deleting category: ' + e.message }
  }
}
