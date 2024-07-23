const User = require("../models/users_model");

exports.createUser = async function (user) {
    try {
        return await User.create(user);
    } catch (e) {
        // User Errors
        return { error: 'Error while creating user: ' + e }
    }
}


exports.loginUser = async function (user) {
    try {
        return await User.login(user);
    } catch (e) {
        // User Errors
        throw Error('Error while creating user: ' + e)
    }
}

exports.updateUser = async function (user) {
    try {
        return await User.updateUser(user);
    } catch (e) {
        // User Errors
        return Error('Error while creating user: ' + e)
    }
}

exports.getUser = async function (user) {
    console.log(user._id)
    try {
        return await User.findOne(user);
    } catch (e) {
        // User Errors
        return { error: 'Error while getting user: ' + e.message }
    }
}

exports.deleteUser = async function (user) {
    try {
        return await User.deleteUser(user);
    } catch (e) {
        // User Errors
        throw Error('Error while creating user: ' + e)
    }
}

exports.getAllUser = async function (query) {
  try {
    return await User.find(query);
  } catch (e) {
    throw Error('Error while getting categories: ' + e)
  }
}
