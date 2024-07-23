const mongoose = require('mongoose');

const ordersSchema = mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "users",
    required: true
  },
  client: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "clients",
  },
  products: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "categories",
      required: true
    },
  ],
  status : {
    type: String,
    enum: ['waiting', 'passed', 'refused'],
    default: "waiting",
    required: true,
  },
  payment_means: {
    type: String,
    enum: ['money', 'card', 'nature'],
    required: true,
  },
  total_price : {
    type: Number,
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

module.exports = mongoose.model('orders', ordersSchema);
