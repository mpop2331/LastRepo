class Classification {
    constructor(conn) {
        this.conn = conn;
        this.deleteClassifications = async function (aProducts) {
            const Classification = conn.entities["tc.tables.Classification"];
            for (const Product of aProducts) {
                await UPDATE(Classification)
                .set({Status: -1})
                .where({
                    GUID:Product.GUID,
                    Scheme:Product.Scheme
                })
            };
        };
    }

    
}

module.exports = Classification