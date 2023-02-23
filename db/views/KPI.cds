namespace tc.views;
using tc.tables.Classification as Classification from '../tables/Classification';
using tc.tables.Client as Client from '../tables/Client';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';
using tc.tables.Code as NumberingSchemeCode from '../tables/Code';
 
context KPI { // CDS View : Client specific level #Products per Classification
    view ProductsClassification 
    as select from  Product
    left outer join Classification
        on Classification.ProductGUID = Product.GUID
    {
        Classification.CodeID as Code,
        count(Classification.ProductGUID) as Products :Integer
        
    }
    where Classification.Status > 1 and Classification.CodeID is not null
    group by Classification.CodeID
    order by Products desc;
    
    VIEW ClientAggregation 
    as select from  Client
    inner join Product
    on Client.Client = Product.Client and Client.ValidFrom < current_utctimestamp() AND Client.ValidTill > current_utctimestamp()
    left outer join ClassificationsClients
        on ClassificationsClients.Client = Product.Client
    left outer join ClassifiedClients
        on ClassifiedClients.Client = Product.Client
    {
        Product.Client,
        ClassificationsClients.Classifications,
        ClassifiedClients.Classified,
        count( distinct Product.GUID) as Products :Integer
    }
    group by Product.Client, ClassificationsClients.Classifications, ClassifiedClients.Classified;
    
    view ClassificationsUser //Expert Validations
    as select from  Product 
    inner join Classification
        on Classification.ProductGUID = Product.GUID
    {
        Classification.ValidatedBy as Expert,
        count(Classification.ProductGUID) as Classifications :Integer
    }
    where Classification.Status = 3
    group by Classification.ValidatedBy;
    
    view ClassificationsScheme 
    as select from  Product
    inner join Classification
        on Classification.ProductGUID = Product.GUID
    {
        Classification.Scheme,
        count(Classification.ProductGUID) as Classifications :Integer
    }
    where Classification.Status  > 1
    group by Classification.Scheme;
    
    view ClassificationsClients as 
    select from  Product
    left outer join Classification
        on Product.GUID = Classification.ProductGUID
    {
        Product.Client,
        count(*) as Classifications :Integer
    }
    where Classification.Status  > 0
    group by Product.Client;
    
    view ClassificationsClients2 as 
    select from Client
    inner join Product
    on Product.Client = Client.Client
    inner join Classification
        on Product.GUID = Classification.ProductGUID
    {
        Product.Client,
        count(*) as Classifications : Integer
    }
    where Classification.Status  > 0 and Client.ValidFrom < current_utctimestamp() AND Client.ValidTill > current_utctimestamp()
    group by Product.Client;
   
    view ClassifiedClients as 
    select from  Classification 
    inner join Product
        on Product.GUID = Classification.ProductGUID
    {
        Product.Client,
        count(*) as Classified :Integer
    }
    where Classification.Status  = 3
    group by Product.Client;
    
    view Products
    as select from  Product 
    {
        count(Product.GUID) as TotalProducts :Integer
    };
    
    view Filters
    as select from  User 
    {
        cast( ' ' as String(32) )as Classifications,
        cast( ' ' as String(32) ) as Scheme,
        cast( ' ' as String(32) ) as Code,
        cast( ' ' as String(32) ) as Expert,
        current_date as Date :DateTime,
        cast( ' ' as String(32) ) as Month,
        2019 as Year :Integer
    }
    where User.User = current_user;
    
    view ToBeValidated
    as select from  Product
    inner join Classification
        on Classification.ProductGUID = Product.GUID
    {
        count(Classification.ProductGUID) as TotalClassifications :Integer
    }
    where Classification.Status >= 0 AND Classification.Status <3;
    
    view RejectsUser //Rejections by user
    as select from  Product 
    inner join Classification
        on Classification.ProductGUID = Product.GUID
    {
        Classification.ValidatedBy as User,
        count(Classification.ProductGUID) as Classifications :Integer
    }
    where Classification.Status = -2
    group by Classification.ValidatedBy;
    
    view TotalClassified
    as select from  Product
    inner join Classification
        on Classification.ProductGUID = Product.GUID
    {
        count(Classification.ProductGUID) as Total :Integer
    }
    where Classification.CodeID is NOT NULL and Classification.Status = 3;
};