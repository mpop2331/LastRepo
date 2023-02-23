namespace tc.views;
using tc.tables.Classification as Classification from '../tables/Classification';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';

context Invoice{
    //Depreciated
    view MonthName 
    as select from  Product 
    left outer join Classification
        on Classification.ProductGUID = Product.GUID
        {
            concat( monthname(Classification.ClassifiedOn),concat(' ',year(Classification.ClassifiedOn))) as Month :String,
            Classification.ClassifiedOn as Date,
            Product.ID as Product,
            Classification.CodeID,
            Classification.Scheme,
            UPPER(Product.ID)                               as CIProduct :String
        }
        where Classification.ClassifiedBy = 'AutoClassified';
    
    view InvoiceMonth 
    as select from  MonthName
        {
            MonthName.Month,
            count(MonthName.Month) as NumberProd :Integer,
            1000 as PriceProduct :Integer,
            count(MonthName.Month) * 1000 as Price :Integer
        }
        group by MonthName.Month;
    
};