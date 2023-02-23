const Persistency = require("../db_implementation/persistency");

async function deleteClass(request, conn,entities) {
	
	var oBody = request.body;
	var oPersistencyInstance = new Persistency(conn);
	//var schemes = oPersistencyInstance.clientInstance.getSchemes(currClient.Client);
	
    var Products = oBody.Products;

	await oPersistencyInstance.classificationInstance.deleteClassifications(Products);

    /*
	var aData = [];
	Products.forEach(function(oProduct) {
		aData.push({
			"ProductID": oProduct.ProductID,
			"Scheme": oProduct.Scheme,
			"GUID": oProduct.GUID
		});
	});
	schemes.forEach(function(Scheme) {
		var productsScheme = [];
		for (var i = 0; i < aData.length; i++) {
			if (aData[i].Scheme === Scheme) {
				productsScheme.push(aData[i].ProductID);
			}
		}
		if (productsScheme.length > 0) {
			MLLib.batchDelete(productsScheme, Scheme, currClient.Client);
			oPersistencyInstance.clientInstance.updateLastTrainingDate(currClient.Client, Scheme);
		}
	});
    */
}


module.exports = {deleteClass}