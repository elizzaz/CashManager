const Client = require("../models/clients_model");

exports.createClient = async function (client) {
    try {
        return await Client.create(client);
    } catch (e) {
        // User Errors
        return { error: 'Error while creating client: ' + e.message }
    }
}

exports.getClient = async function(query) {
    try {
        return await Client.findOne(query)
    } catch (e) {
        return { error: 'Error while getting client: ' + e.message }
    }
}

exports.updateClient = async function (id, query) {
    try {
        return await Client.findOneAndUpdate({_id: id }, query, {new: true});
    } catch (e) {
        // User Errors
        return { error: 'Error while updating client: ' + e.message }
    }
}

exports.deleteClient = async function (client) {
    try {
        return await Client.findOneAndDelete({"email": client});
    } catch (e) {
        // User Errors
        return { error: 'Error while deleting client: ' + e.message }
    }
}
