const mongoose = require('mongoose');

const categoriesSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true
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

module.exports = mongoose.model('categories', categoriesSchema);
