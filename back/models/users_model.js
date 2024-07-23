const mongoose = require('mongoose');

const usersSchema = mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, required: true },
  created_at: { type: Date, default: Date.now() },
  updated_at: { type: Date, default: Date.now() }
});

module.exports = mongoose.model('users', usersSchema);
