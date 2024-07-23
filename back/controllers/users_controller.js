const User = require("../models/users_model");
const UserServices = require("../services/users_service");
const jwtConfig = require('../utils/config_jwt');
const jwt = require('../utils/jwt');
const Bcrypt = require('bcryptjs');


/* CREATE USER */
exports.create = async (req, res) => {
    try {
        req.body.password = Bcrypt.hashSync(req.body.password, 10);

        const user = await UserServices.createUser({
            username: req.body.username,
            password: req.body.password,
            role: req.body.role,
            created_at: req.body.created_at,
            updated_at: req.body.updated_at
        })
        if(user.error) return res.status(400).send({message: user.error})
        return res.status(200).json(user);
    } catch (e) {
        return res.status(400).json(e);
    }
}

/* UPDATE USER */
exports.updateUser = async (req, res) => {
    req.body.password = Bcrypt.hashSync(req.body.password, 10);

    const user = await User.findByIdAndUpdate({_id: req.params.id }, {
        username: req.body.username,
        password: req.body.password,
        role: req.body.role,
        created_at: req.body.created_at,
        updated_at: req.body.updated_at
    });
    if (user) {
            return res.status(200).json('user update');
        }
        else{
            console.log(err)
            res.status(500).json({
            message:
              "Error retrieving Customer with id " + req.params._id,
          });
        }
    }

/* GET USER BY ID */
exports.getUser = async (req, res) => {
    User.findOne({_id: req.params.id }, function (err, data) {
        if (data){
            console.log("Result : ", data);
            res.json(data);
        }
        else {
        console.log(err)
        res.status(500).json({
            message:
              "Error retrieving Customer with id " + req.params._id,
          });
        }
    });
}

/* USER LOGIN */
exports.login = async (req, res) => {
    const user = await User.findOne({
        username: req.body.username
    });
    if (user) {
        const isMatched = await Bcrypt.compare(req.body.password, user.password);
        if (isMatched) {
            const token = jwt.createToken({ _id: user._id });
            return res.json({
                access_token: token,
                token_type: 'Bearer',
                expires_in: jwtConfig.ttl
            });
        }
        else{
            console.log('Invalid password');
        }
    }
    return res.status(400).json({ message: 'Invalid credentails.' });
}

/* UPDATE USER */
exports.deleteUser = async (req, res) => {
    User.deleteOne({_id: req.params.id }, function (err, data) {
    if (err) {
        console.log(err)
        res.status(500).json({
            message:
            "Error retrieving Customer with id " + req.params._id,
        });
        } else{
            return res.status(200).json({ message: 'User deleted' });
        }
    });
}

/* GET ALL USER */
exports.getAllUser = async (req, res) => {
  try {
    let user = await UserServices.getAllUser({})
    if (!user) return res.status(404).send({message: 'User not found'});
    return res.status(200).send(user);
  } catch (e) {
    res.status(500).send({message: 'No Users find'})
  }
};

/**
 * GET THE CONNECTED USER
 */
exports.getUserMe = async (req, res) => {
    try {
        let user = await UserServices.getUser({_id: req.user._id})
        if (user.error) return res.status(404).send({message: user.error})

        return res.status(200).send(user)
    } catch (e) {
        res.status(500).send({message: 'User not found'})
    }
}
