namespace tc.views;
using tc.tables.Classification as Classification from '../tables/Classification';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';


context ManualClassifications{
    view Classifications
    as select from  Product
    inner join Classification
        on Classification.ProductGUID = Product.GUID
    {
        count(Classification.ProductGUID) as Total :Integer
    }
    where Classification.CodeID is NOT NULL and Classification.Status > 1;
    
    view NameClassifications as 
    select from Classification
    inner join Product
        on Product.GUID = Classification.ProductGUID
    distinct {
        (case
            when Classification.ClassifiedBy = 'AutoClassified'then 
                'Machine Classified'
            else    
                'Expert Classified'
            end) as ClassificationBy :String,
        Classification.GUID
    } 
    where Classification.Status > 1;
    
    view ManualClassifications2
    as select from  Classification 
    inner join NameClassifications
       on NameClassifications.GUID = Classification.GUID 
        {
         (case
           when Classification.ClassifiedBy = 'AutoClassified'then
            'Machine Classified'
        else    
            'Expert Classified'
            end) as ClassificationBy :String,
        (case
           when Classification.ClassifiedBy = 'AutoClassified'then
            count(Classification.GUID)
        else    
            count(Classification.GUID)
            end) as Classifications :Integer
        }
        where Classification.CodeID is NOT NULL and Classification.Status > 1
        group by NameClassifications.ClassificationBy,Classification.ClassifiedBy;
    

    view ManualClassifications
    as  select  from  ManualClassifications2 cross join Classifications as Classifications 
    {
        ManualClassifications2.ClassificationBy,
        (case
           when ManualClassifications2.ClassificationBy = 'Machine Classified'then
            (sum(ManualClassifications2.Classifications) / Classifications.Total) * 100
        else    
            (sum(ManualClassifications2.Classifications) / Classifications.Total) * 100
            end) as Classifications :Double
        }
        group by ManualClassifications2.ClassificationBy, Classifications.Total ; 
    };