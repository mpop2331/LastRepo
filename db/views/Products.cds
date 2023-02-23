namespace tc.views;
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';
using tc.tables.Attribute as Attribute from '../tables/Attribute';

context Products{

    //Products
    VIEW Products 
    AS SELECT FROM  Product
    {
        KEY Product.GUID                AS GUID,
            Product.ID                  AS ID,
            Product.Client              AS Client,
            Product.Description         AS Description,
            Product.Language            AS Language,
            Product.Status              AS Status,
            Product.UploadedOn          AS UploadedOn,
            Product.UploadedBy          AS UploadedBy,
            Product.FileName            AS FileName,
            Product.DropOnReset         AS DropOnReset,
            Product.ExpertClassificationReq          AS ExpertClassificationReq,
            UPPER(Product.ID)           AS CIID :String,
            UPPER(Product.Description)  AS CIDescription :String,
            UPPER(Product.UploadedBy)   AS CIUploadedBy :String,
            UPPER(Product.FileName)     AS CIFileName :String
    }
    WHERE (Product.Status = 1 OR Product.Status = 4);
    
    //Products
    VIEW Attributes 
    AS SELECT FROM Product
    JOIN Attribute
        ON Product.GUID = Attribute.ProductGUID
    {
        KEY Product.GUID            AS ProductGUID,
        KEY Attribute.Name          AS Name,
            Attribute.Value         AS Value,
            Attribute.Active        AS Active,
            Attribute.ML            AS ML
    }
    WHERE (Product.Status = 1 OR Product.Status = 4);
    
    //Upload (depreciated)
    VIEW UploadedProducts 
    AS SELECT FROM  Product 
    {
        KEY Product.GUID            AS ID,
            Product.ID              AS Product,
            Product.Description     AS Description,
            Product.Language        AS Language,
            Product.Client          AS Client,
            Product.Status          AS Status,
            Product.UploadedBy      AS UploadedBy,
            Product.UploadedOn      AS UploadedOn,
            Product.FileName        AS FileName,
            Product.ExpertClassificationReq      as ExpertClassificationReq
    }
    WHERE Product.Status = 0;
};