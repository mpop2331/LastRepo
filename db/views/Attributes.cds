namespace tc.views;
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';
using tc.tables.Attribute as Attribute from '../tables/Attribute';
using tc.tables.ClientAttribute as ClientAttribute from '../tables/ClientAttribute';
using tc.tables.Classification as ClassificationT from '../tables/Classification';
using tc.tables.Code as CCodeT from '../tables/Code';
using tc.tables.Scheme as SchemeT from '../tables/Scheme';
using tc.tables.CodeDescription as CCodeDescT from '../tables/CodeDescription';
using tc.tables.ClientScheme as ClientSchemeT from '../tables/ClientScheme';
using tc.tables.SchemeUser as SchemeUserT from '../tables/SchemeUser';
using tc.tables.Status as StatusT from '../tables/Status';
using tc.tables.Note as NoteT from '../tables/Note';
using tc.views.Classifications.recentNote as recentNote from './Classifications';

context Attributes{  
 //Products
    VIEW Attributes 
    AS SELECT  FROM Product
    JOIN Attribute
        ON Product.GUID = Attribute.ProductGUID
    JOIN ClientAttribute on
        Attribute.Name = ClientAttribute.Name
        distinct
    {
        KEY Attribute.Name          AS Name,
        ClientAttribute.ViewAttribute,
        ClientAttribute.ML,
        ClientAttribute.SubModelParam,
        ClientAttribute.AttributeIndex
    }
    WHERE (Product.Status = 1 OR Product.Status = 4);
    
    VIEW ViewAttributes 
    AS SELECT  FROM Product
    JOIN Attribute
        ON Product.GUID = Attribute.ProductGUID 
    JOIN ClientAttribute on
        Attribute.Name = ClientAttribute.Name
        AND ClientAttribute.ViewAttribute is not null AND ClientAttribute.ViewAttribute != 10
        distinct
    {
        KEY Attribute.Name          AS Name,
        ClientAttribute.ViewAttribute,
        ClientAttribute.ML,
        ClientAttribute.SubModelParam
    }
    WHERE (Product.Status = 1 OR Product.Status = 4)
    ORDER By ClientAttribute.ViewAttribute ;
    
    
    
    view ClassificationsAttr as 
    select from User 
    inner join Product
        on Product.Client = User.Client
        AND User.User = current_user
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
        AND ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = ClassificationT.Scheme
        AND SchemeUserT.Client = User.Client
        AND SchemeUserT.User = current_user
    left outer join CCodeT
        on CCodeT.ID = ClassificationT.CodeID
        AND CCodeT.Scheme = ClassificationT.Scheme
    left outer join CCodeDescT
        on CCodeT.ID = CCodeDescT.CodeID
        AND CCodeT.Scheme = CCodeDescT.Scheme
    left outer join StatusT
        on StatusT.ID = ClassificationT.Status
    left outer join recentNote
        on Product.GUID = recentNote.ProductGUID
    left outer join NoteT
        on recentNote.ProductGUID = NoteT.ProductGUID
        AND recentNote.Date = NoteT.Date
        AND NoteT.Status = 1
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.ViewAttribute = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name  
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.ViewAttribute = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.ViewAttribute = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.ViewAttribute = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.ViewAttribute = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name
    left Join ClassificationT as C2
        on C2.ProductGUID = ClassificationT.ProductGUID and C2.Status = -2 and C2.ValidatedOn > ClassificationT.AssignedOn and C2.GUID <> ClassificationT.GUID  
        and ClassificationT.Status = 1 and ClassificationT.Scheme = C2.Scheme    
    {
        KEY ClassificationT.GUID                            as GUID,
            Product.GUID                                    as ProductGUID,
            ClassificationT.Scheme                          as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            Product.Language                                as Language,
            Product.Status                                  as Status,
            Product.ExpertClassificationReq                 as ExpertClassificationReq,
            NoteT.Comment                                   as Comment,
            CCodeT.Code                                     as Code,
            CCodeT.ValidTill                                as CodeValidTill,
            CCodeDescT.Description                          as CodeDescription,
            ClassificationT.Type                            as Type,
            ClassificationT.AssignedTo                      as AssignedTo,
            ClassificationT.AssignedOn                      as AssignedOn,
            ClassificationT.Status                          as ClassStatus,
            StatusT.Name                                    as StatusDescription,
            ClassificationT.ClassifiedBy                    as ClassifiedBy,
            ClassificationT.ClassifiedOn                    as ClassifiedOn,
            ClassificationT.ValidatedBy                     as ValidatedBy,
            ClassificationT.ValidatedOn                     as ValidatedOn,
            ClassificationT.ValidFrom                       as ValidFrom,
            ClassificationT.ValidTill                       as ValidTill,
            ClassificationT.CreatedOn                       as CreatedOn,
            ClassificationT.CreatedBy                       as CreatedBy,
            Attr1.Value                                     as Value1,
            Attr1.Name                                      as Attribute1,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(Product.Completion)                       as CICompletion :String,
            UPPER(ClassificationT.AssignedTo)               as CIAssignedTo :String,
            UPPER(ClassificationT.ValidatedBy)              as CIValidatedBy :String,
            UPPER(ClassificationT.ClassifiedBy)             as CIClassifiedBy :String,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            UPPER(Attr5.Value)                              as CIValue5 :String,
            (CASE ClassificationT.AssignedTo WHEN current_user then '1'else '0' END) as ToMe :String,
            C2.ValidatedOn as RejectedOn,
            C2.ValidatedBy as RejectedBy,
            C2.CodeID as RejectedCode
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification';
    
            view ClassificationsAttr2 as 
    select from User 
    inner join Product
        on Product.Client = User.Client
        AND User.User = current_user
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
        AND ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = ClassificationT.Scheme
        AND SchemeUserT.Client = User.Client
        AND SchemeUserT.User = current_user
    left outer join CCodeT
        on CCodeT.ID = ClassificationT.CodeID
        AND CCodeT.Scheme = ClassificationT.Scheme
    left outer join CCodeDescT
        on CCodeT.ID = CCodeDescT.CodeID
        AND CCodeT.Scheme = CCodeDescT.Scheme
    left outer join StatusT
        on StatusT.ID = ClassificationT.Status
    left outer join recentNote
        on Product.GUID = recentNote.ProductGUID
    left outer join NoteT
        on recentNote.ProductGUID = NoteT.ProductGUID
        AND recentNote.Date = NoteT.Date
        AND NoteT.Status = 1
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.ViewAttribute = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name  
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.ViewAttribute = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.ViewAttribute = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name 
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.ViewAttribute = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.ViewAttribute = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name
    left Join ClassificationT as C2
        on C2.ProductGUID = ClassificationT.ProductGUID and C2.Status = -2 and C2.ValidatedOn > ClassificationT.AssignedOn and C2.GUID <> ClassificationT.GUID  and ClassificationT.Status = 1 and ClassificationT.Scheme = C2.Scheme
    {
        KEY ClassificationT.GUID                            as GUID,
            Product.GUID                                    as ProductGUID,
            ClassificationT.Scheme                          as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            Product.Language                                as Language,
            Product.Status                                  as Status,
            Product.ExpertClassificationReq                 as ExpertClassificationReq,
            NoteT.Comment                                   as Comment,  
            CCodeT.Code                                     as Code,
            CCodeT.ValidTill                                as CodeValidTill,
            CCodeDescT.Description                          as CodeDescription,
            ClassificationT.Type                            as Type,
            ClassificationT.AssignedTo                      as AssignedTo,
            ClassificationT.AssignedOn                      as AssignedOn,
            ClassificationT.Status                          as ClassStatus,
            StatusT.Name                                    as StatusDescription,
            ClassificationT.ClassifiedBy                    as ClassifiedBy,
            ClassificationT.ClassifiedOn                    as ClassifiedOn,
            ClassificationT.ValidatedBy                     as ValidatedBy,
            ClassificationT.ValidatedOn                     as ValidatedOn,
            ClassificationT.ValidFrom                       as ValidFrom,
            ClassificationT.ValidTill                       as ValidTill,
            ClassificationT.CreatedOn                       as CreatedOn,
            ClassificationT.CreatedBy                       as CreatedBy,
            Attr1.Value                                     as Value1,
            Attr1.Name                                      as Attribute1,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(ClassificationT.AssignedTo)               as CIAssignedTo :String,
            UPPER(Product.Completion)                       as CICompletion :String,
            UPPER(ClassificationT.ValidatedBy)              as CIValidatedBy :String,
            UPPER(ClassificationT.ClassifiedBy)             as CIClassifiedBy :String,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            UPPER(Attr5.Value)                              as CIValue5 :String,
            (CASE ClassificationT.AssignedTo WHEN current_user then '1'else '0' END) as ToMe :String,
            C2.ValidatedOn as RejectedOn,
            C2.ValidatedBy as RejectedBy,
            C2.CodeID as RejectedCode
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification';
    
    VIEW ClassRequestAttr 
    AS SELECT FROM Product
    inner join User
        on User.Client = Product.Client
        and User.User = current_user
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
    inner join SchemeT
        on SchemeT.Scheme = ClientSchemeT.Scheme
    left join ClassificationT
        on ClassificationT.ProductGUID = Product.GUID
        AND ClassificationT.Scheme = ClientSchemeT.Scheme
        AND ClassificationT.Status != -1
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.ViewAttribute = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name  
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.ViewAttribute = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.ViewAttribute = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.ViewAttribute = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.ViewAttribute = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name    
       
    {
        KEY Product.GUID                                    as ProductGUID,
        KEY ClientSchemeT.Scheme                            as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            Product.UploadedBy                              as UploadedBy,
            Product.UploadedOn                              as UploadedOn,
            Product.FileName                                as FileName,
            Product.ExpertClassificationReq                 as ExpertClassificationReq,
            Attr1.Value                                     as Value1,
            Attr1.Name                                      as Attribute1,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(Product.UploadedBy)                       as CIUploadedBy :String,
            UPPER(Product.Completion)                       as CICompletion :String,
            UPPER(Product.FileName)                         as CIFileName :String,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            UPPER(Attr5.Value)                              as CIValue5 :String
    }
    where (ClassificationT.ProductGUID IS NULL AND ClassificationT.Scheme IS NULL) 
        AND Product.Status = 1
        AND Product.ClassRequest = ''
    order by Product.ID; 
    
}