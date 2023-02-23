namespace tc.views;
using tc.tables.User as UserT from '../tables/User';
using tc.tables.Role as RoleT from '../tables/Role';
using tc.tables.ClientUser as ClientUserT from '../tables/ClientUser';

context Users { // CDS View : Client specific level #Classifications per day
    
    //Only for DeloitteAdmin, Client access management
    VIEW Users
    AS SELECT FROM UserT
    LEFT JOIN RoleT
        ON UserT.Role = RoleT.GUID
    {
        KEY UserT.User                  as User,
            UserT.Language              as Language,
            UserT.FirstName             as FirstName,
            UserT.LastName              as LastName,
            UserT.Email                 as Email,
            RoleT.GUID                  as RoleGUID,
            RoleT.RoleName              as RoleName,
            UPPER(UserT.User)           as UUser :String,
            UPPER(UserT.FirstName)      as UFirstName :String,
            UPPER(UserT.LastName)       as ULastName :String,
            UPPER(UserT.Email)          as UEmail :String
    }
    WHERE UserT.Status = 1;
        
    VIEW Roles 
    AS SELECT FROM RoleT
    INNER JOIN UserT AS CurrentUser
        ON CurrentUser.User = CURRENT_USER
    {
        KEY RoleT.GUID       as RoleGUID,
            RoleT.RoleName   as RoleName
    }
    WHERE RoleT.GUID <= CurrentUser.Role;
    
    // CurrentUser - Available from User role
    VIEW CurrentUser 
    AS SELECT FROM UserT
    LEFT JOIN RoleT
        ON UserT.Role = RoleT.GUID
    {   
        KEY UserT.User                  as User,
            UserT.Language              as Language,
            UserT.FirstName             as FirstName,
            UserT.LastName              as LastName,
            UserT.Email                 as Email,
            RoleT.GUID                  as RoleGUID,
            RoleT.RoleName              as RoleName,
            UPPER(UserT.User)           as UUser :String,
            UPPER(UserT.FirstName)      as UFirstName :String,
            UPPER(UserT.LastName)       as ULastName :String,
            UPPER(UserT.Email)          as UEmail :String
    }
    WHERE UserT.Status = 1
      AND UserT.User   = current_user;

    
};