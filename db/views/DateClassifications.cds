namespace tc.views;
using tc.tables.Classification as Classification from '../tables/Classification';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';

context DateClassifications { // CDS View : Client specific level #Classifications per month

   view DateName 
    as select from  Product
    left outer join Classification
        on Classification.ProductGUID = Product.GUID
        {
            cast(Classification.ClassifiedOn as Date) as Date
        }
        where Classification.ClassifiedOn is not null and Classification.Status = 2;
        
    view ClassificationsDay
    as select from DateName
        {
            DateName.Date,
            count(DateName.Date) as Classifications :Integer
        }
        group by  DateName.Date; 
        
    view MonthName 
    as select from  Product 
    left outer join Classification
        on Classification.ProductGUID = Product.GUID
        {
            cast(monthname(Classification.ClassifiedOn) as String(20)) as Month,
            concat(' ',year(Classification.ClassifiedOn)) as Year :String
        }
        where Classification.ClassifiedOn is not null and Classification.Status = 2;
        
    view ClassificationsMonth 
    as select from MonthName
        {
            concat(MonthName.Month,MonthName.Year) as Month :String,
            count(MonthName.Month) as Classifications :Integer
        }
        group by MonthName.Month, MonthName.Year;
        
    view YearName 
    as select from  Product 
    left outer join Classification
        on Classification.ProductGUID = Product.GUID
        {
            year(Classification.ClassifiedOn) as Year :Integer
        }
        where Classification.ClassifiedOn is not null and Classification.Status > 1;
        
    view ClassificationsYear
    as select from YearName
        {
            YearName.Year,
            count(YearName.Year) as Classifications :Integer
        }
        group by  YearName.Year;    
};