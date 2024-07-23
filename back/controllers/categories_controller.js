const CategoryServices = require("../services/categories_services");


exports.create = async (req, res) => {
  try {
    const category = await CategoryServices.createCategory({
      name: req.body.name
    })
    if (category.error) return res.status(400).send({message: category.error});

    return res.status(200).send({message: `Category ${req.body.name} is created`});

  } catch (e) {
    res.status(500).send({message: `Category not created`})
  }

}

exports.findOne = async (req, res) => {
  try {
    let category = await CategoryServices.getCategory({_id: req.params.id})
    if (category.error) return res.status(404).send({message: category.error});
    return res.status(200).send(category);
  } catch (e) {
    res.status(500).send({message: 'Category not found'})
  }
};

exports.findAll = async (req, res) => {
  try {
    let categories = await CategoryServices.getAllCategories({})
    if (categories.error) return res.status(404).send({message: categories.error});
    return res.status(200).send(categories);
  } catch (e) {
    res.status(500).send({message: 'Category not found'})
  }
};

exports.update = async (req, res) => {
  try {
    let category = await CategoryServices.updateCategory(req.params.id, req.body)
    if (category.error) return res.status(400).send({message: category.error});
    return res.status(200).send(category);
  } catch (e) {
    res.status(500).send({message: 'Category not updated'})
  }
};

exports.delete = async (req, res) => {
  try {
    let category = await CategoryServices.deleteCategory({_id: req.params.id})
    if (category.error) return res.status(400).send({message: category.error});
    return res.status(200).send("Category deleted");
  } catch (e) {
    res.status(500).send({message: "Can't delete category"})
  }
};
