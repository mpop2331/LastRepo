//const ClassificationImpl = require("dce.qas.implementation", "classification");


const ClassificationImpl = require("./classification");

module.exports = async function dispatch(req,conn) {
    
    var oResponse = {}
    const oData = req.data.input;
    const sMethod = oData.method;
    const sEntity = oData.entity;

    switch (sEntity) {
        case "Classification":
            switch (sMethod) {
                case "POST":
                    //ClassificationValidator.validatePost(request, response, conn);
                    ClassificationImpl.deleteClass(oData, conn);
                    break;
                case "PUT":
                    //ClassificationValidator.validatePut(request, response, conn);
                    ClassificationImpl.deleteClass(oData, conn);
                    break;
                case "DELETE":
                    console.log("__________________________");
                    console.log(oData);
                    console.log("__________________________");
                    await ClassificationImpl.deleteClass(oData, conn);
                    break;
                default:
                    throw new Exception("", $.net.http.METHOD_NOT_ALLOWED);
            }
            break;
        default:
            throw new Exception("Invalid URL path!", sEntity);
    }
    return oResponse;
}