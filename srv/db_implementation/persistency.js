const Classification = require("../db_implementation/classificationPersistency");


class Persistency {
    constructor(conn,entities) {
        this.conn = conn;
        this.classificationInstance = new Classification(conn);
    }

}


module.exports = Persistency