const mongoose = require('mongoose');

const productsSchema = mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  vat_percent: {
    type: Number,
    required: true
  },
  bar_code: {
    type: String,
    required: true,
    unique: true
  },
  category: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "categories",
    required: true
  },
  img_url: {
    type: String,
  },
  brand: {
    type: String
  },
  created_at: {
    type: Date,
    default: Date.now()
  },
  updated_at: {
    type: Date,
    default: Date.now()
  }
});

module.exports = mongoose.model('products', productsSchema);
