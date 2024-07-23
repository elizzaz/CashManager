const Order = require('../models/orders_model');

exports.createOrder = async (order) => {
  try {
    return await Order.create(order)
  } catch (e) {
    return { error: 'Error while creating order: '+ e };
  }
}

exports.getAllOrders = async function (query) {
  try {
    return await Order.find(query)
      .populate('user', 'username')
      .populate('client', 'first_name last_name')
      .populate('products', 'name price bar_code', 'products')
      
  } catch (e) {
    return { error: 'Error while getting orders: '+ e };
  }
}

exports.getOrder = async function (query) {
  try {
    return await Order.findOne(query)
      .populate('user', 'username')
      .populate('client', 'first_name last_name')
      .populate('products', 'name price bar_code', 'products')
  } catch (e) {
    return { error: 'Error while getting order: '+ e };
  }
}

exports.updateOrder = async function (query, body) {
  try {
    return await Order.findOneAndUpdate({_id: query}, body, {new: true});
  } catch (e) {
    // Product Errors
    return { error: 'Error while updating order: '+ e };
  }
}

exports.deleteOrder = async function (query) {
  try {
    return await Order.deleteOne(query);
  } catch (e) {
    // Product Errors
    return { error: 'Error while deleting order: '+ e };
  }
}
