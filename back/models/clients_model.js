const mongoose = require('mongoose');

const clientsSchema = mongoose.Schema({
  first_name: { type: String },
  last_name: { type: String },
  email: { type: String, unique: true },
  amount: { type: Number },
  created_at: { type: Date, default: Date.now() },
  updated_at: { type: Date, default: Date.now() }
});

module.exports = mongoose.model('clients', clientsSchema);