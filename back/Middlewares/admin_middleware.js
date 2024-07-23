const jwt = require('jsonwebtoken');

const User = require("../models/users_model");
const jwtConfig = require('../utils/config_jwt');

module.exports = (req, res, next) => {
  const token = req.headers['x-access-token'] || req.headers['authorization'];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'No token provided'
    });
  }

  jwt.verify(token, jwtConfig.secret, (err, decoded) => {
    if (err) {
      return res.status(401).json({
        success: false,
        message: 'Failed to authenticate token'
      });
    }

    User.findById(decoded._id, (userErr, user) => {
      if (userErr || !user) {
        return res.status(404).json({
          success: false,
          message: 'User not found'
        });
      }

      if (user.role !== "admin") {
        return res.status(401).json({
          success: false,
          message: 'Unauthorized: Admins only'
        });
      }

      req.user = user;
      next();
    });
  });
}
