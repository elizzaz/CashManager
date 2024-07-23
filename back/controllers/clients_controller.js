const ClientServices = require("../services/clients_service");

exports.create = async (req, res) => {
    try {
        let client = await ClientServices.createClient(req.body);
        if (client.error) return res.status(400).send({ message: client.error });

        return res.status(200).send({"response": "Client created successfully"});
    } catch (err) {
        return res.status(400).send({"response": "Client not created"});
    }
}

exports.getById = async (req, res) => {
    try {
        let client =  await ClientServices.getClient({_id: req.params.id});
        if (client.error) return res.status(404).send({ message: client.error });
        return res.status(200).send(client)
    } catch (e) {
        return res.status(400).send(e);
    }
}

exports.update = async (req, res) => {
    try {
        let client = await ClientServices.updateClient(req.params.id, req.body);
        if (client.error) return res.status(400).send({ message: client.error});

        return res.status(200).send(client);
    } catch (err) {
        return res.status(400).send({"response": "Client not update"});
    }
}

exports.delete = async (req, res) => {
    try {
        let client = await ClientServices.deleteClient(req.body.email);
        if (client.error) return res.status(400).send({ message: client.error});

        return res.status(200).send({"response": "Client delete"});
    } catch (err) {
        return res.status(400).send({"response": "Client not find"});
    }
}
