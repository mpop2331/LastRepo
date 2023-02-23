namespace tc.views;
using tc.tables.ExternalProduct as ExternalProduct from '../tables/ExternalProduct';

context ExternalProducts{
    //Products
    VIEW ExternalProducts 
    AS SELECT FROM  ExternalProduct
    {
        KEY ExternalProduct.ID                  AS ID,
            ExternalProduct.Description         AS Description,
            ExternalProduct.Number              AS Number,
            ExternalProduct.Language            AS Language,
            ExternalProduct.Source              AS Source
    };
};