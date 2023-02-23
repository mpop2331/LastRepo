namespace tc.views;
using tc.tables.UserActivity as UserActivityT from '../tables/UserActivity';
using tc.tables.ActivityAttribute as ActivityAttributeT from '../tables/ActivityAttribute';
using tc.tables.ApplicationActivity as ApplicationActivityT from '../tables/ApplicationActivity';
using tc.tables.User as UserT from '../tables/User';
 
context UserActivities { // CDS View : User Activities

    VIEW UserActivities
        AS SELECT FROM UserActivityT
        INNER JOIN ActivityAttributeT
            ON ActivityAttributeT.ActivityGUID = UserActivityT.GUID
        INNER JOIN ApplicationActivityT
            ON ApplicationActivityT.ID = UserActivityT.ApplicationActivityID            
        INNER JOIN UserT        
            ON UserT.User = UserActivityT.User
    {
        KEY UserActivityT.User               as User,
            ApplicationActivityT.Application as Application,
            ApplicationActivityT.Activity    as Activity,            
            UserActivityT.Status             as Status,
            UserActivityT.CreatedOn          as CreatedOn,
            ActivityAttributeT.Name          as Name,
            ActivityAttributeT.Value         as Value
    }
    
    WHERE UserT.Status = 1;
    
    // CurrentUserActivities - List all Activities from Current User
    VIEW CurrentUserActivities
        AS SELECT FROM UserActivityT
        INNER JOIN ActivityAttributeT
            ON ActivityAttributeT.ActivityGUID = UserActivityT.GUID
        INNER JOIN ApplicationActivityT
            ON ApplicationActivityT.ID = UserActivityT.ApplicationActivityID                
        INNER JOIN UserT        
            ON UserT.User = UserActivityT.User
    {
        KEY UserActivityT.User               as User,
            ApplicationActivityT.Application as Application,
            ApplicationActivityT.Activity    as Activity,  
            UserActivityT.Status             as Status,
            UserActivityT.CreatedOn          as CreatedOn,
            ActivityAttributeT.Name          as Name,
            ActivityAttributeT.Value         as Value
    }
    
    WHERE UserActivityT.User = current_user   
      AND UserT.Status       = 1;

};