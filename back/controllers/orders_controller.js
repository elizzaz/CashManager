const OrderServices = require('../services/orders_services');
const ProductServices = require('../services/Products_service');
const e = require('express');
const requestOrders = async (req, res) => {
  try {
    const order = await OrderServices.createOrder({
      user: req.user,
      client: req.body.client,
      products: req.body.products,
      total_price: req.body.total_price,
      payment_means: req.body.payment_means,
      status: req.body.status,
    });
    if (order.error) return res.status(400).send({ message: order.error });

    return res.status(200).send(order);
  } catch (error) {
    res.status(500).send({ message: e });
  }
};

const consecOrCount = array => {
  let count = 0;
  let consecutiveCount = 0;
  array.reduce(
    (acc, cur) => {
      if (cur === 'refused') {
        count++;
        if (cur === acc.currentItem) {
          consecutiveCount++;
        }
      } else {
        acc.currentItem = cur;
        consecutiveCount = 1;
      }
      acc.currentItem = cur;
      return acc;
    },
    {
      currentItem: null,
    }
  );
  return { count, consecutiveCount };
};

exports.create = async (req, res) => {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - 1);
  const endDate = new Date();

  // Find all documents in the collection that match the criteria
  if (req.body.client) {
    const queryDate = {
      client: req.body.client,
      created_at: {
        $gte: startDate,
        $lte: endDate,
      },
    };
    console.log('req.body.status', req.body.status);

    const orders = await OrderServices.getAllOrders(queryDate);
    console.log('length', orders.length);
    console.log('orders', orders);
    const followedRefused = 2;
    var nbOfRefused = 5;

    let resultPerDay = [];

    if (orders.length < Math.min(followedRefused, nbOfRefused)) {
      return requestOrders(req, res);
    }
    for (let j = 0; j < orders.length; j++) {
      resultPerDay.push(orders[j].status);
    }

    const consecOrCountFinal = consecOrCount(resultPerDay);
    let consecutiveCount = consecOrCountFinal.consecutiveCount;
    let count = consecOrCountFinal.count;
    if (
      req.body.status == 'refused' &&
      (followedRefused == consecutiveCount || nbOfRefused == count)
    ) {
      return res.status(403).send({ error: 'too many attempt' });
    } else {
      requestOrders(req, res);
    }
  }
};

exports.findAll = async (req, res) => {
  try {
    const orders = await OrderServices.getAllOrders({});

    if (orders.error) return res.status(404).send({ message: orders.error });

    return res.status(200).send(orders);
  } catch (e) {
    return res.status(404).send({ error: e });
  }
};

exports.findOne = async (req, res) => {
  try {
    let order = await OrderServices.getOrder({ _id: req.params.id });
    if (order.error) return res.status(404).send({ message: order.error });
    return res.status(200).send(order);
  } catch (e) {
    res.status(500).send(e);
  }
};

exports.update = async (req, res) => {
  try {
    let order = await OrderServices.updateOrder(req.params.id, req.body);
    if (order.error) return res.status(400).send({ message: order.error });

    return res.status(200).send(order);
  } catch (e) {
    res.status(500).send(e);
  }
};

exports.delete = async (req, res) => {
  try {
    let order = await OrderServices.deleteOrder({ _id: req.params.id });
    if (order.error) return res.status(400).send({ message: order.error });
    return res.status(200).send('Order deleted');
  } catch (e) {
    res.status(500).send(e);
  }
};
