namespace tc.views;

using tc.tables.Classification as ClassificationT from '../tables/Classification';
using tc.tables.User as User from '../tables/User';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.Code as CCodeT from '../tables/Code';
using tc.tables.Scheme as SchemeT from '../tables/Scheme';
using tc.tables.CodeDescription as CCodeDescT from '../tables/CodeDescription';
using tc.tables.ClientScheme as ClientSchemeT from '../tables/ClientScheme';
using tc.tables.SchemeUser as SchemeUserT from '../tables/SchemeUser';
using tc.tables.Status as StatusT from '../tables/Status';
using tc.tables.Note as NoteT from '../tables/Note';
using tc.tables.Attribute as Attribute from '../tables/Attribute';
using tc.tables.ClientAttribute as ClientAttribute from '../tables/ClientAttribute';
using tc.tables.InvoicedCode as InvoicedCode from '../tables/InvoicedCode';
using tc.tables.DQAClassification as DQAClassificationT from '../tables/DQAClassification';
using tc.tables.EccnClassification as EccnClassification from '../tables/EccnClassification';
using tc.tables.ECCNMapping as ECCNMapping from '../tables/ECCNMapping';

context Classifications{ // CDS View : Client specific level #Classifications per user
    VIEW recentNote as select from NoteT
    { 
        max(NoteT.Date) as Date,
        NoteT.ProductGUID
    } Group by NoteT.ProductGUID;
    
    view Classifications as 
    select from Product 
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
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
        AND (NoteT.Scheme = ClassificationT.Scheme OR NoteT.Scheme is null)
        AND NoteT.Status = 1
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
            Product.ScoringDate                             as ScoringDate,
            Product.Completion                              as Completion,
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
            ClassificationT.ValidForML                      as ValidForML,
            Product.UploadedOn                              as UploadedOn,
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(Product.Completion)                       as CICompletion :String,
            UPPER(ClassificationT.AssignedTo)               as CIAssignedTo :String,
            UPPER(ClassificationT.ValidatedBy)              as CIValidatedBy :String,
            UPPER(ClassificationT.ClassifiedBy)             as CIClassifiedBy :String,
            (CASE ClassificationT.AssignedTo WHEN $user then '1'else '0' END) as ToMe :String,
            C2.ValidatedOn as RejectedOn,
            C2.ValidatedBy as RejectedBy,
            C2.CodeID as RejectedCode                                    
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification';
    
    VIEW ClassRequest 
    AS SELECT FROM Product
    inner join ClassificationT
        on ClassificationT.ProductGUID = Product.GUID
        AND ClassificationT.Status != -1
    inner join ClientSchemeT
        on ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeT
        on SchemeT.Scheme = ClientSchemeT.Scheme
    {
        KEY Product.GUID                                    as ProductGUID,
        KEY ClientSchemeT.Scheme                            as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            Product.ExpertClassificationReq                 as ExpertClassificationReq,
            Product.UploadedBy                              as UploadedBy,
            Product.UploadedOn                              as UploadedOn,
            Product.FileName                                as FileName,
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(Product.UploadedBy)                       as CIUploadedBy :String,
            UPPER(Product.FileName)                         as CIFileName :String
    }
    where ClassificationT.ProductGUID IS NULL 
        AND ClassificationT.Scheme IS NULL
        AND Product.Status = 1
        AND Product.ClassRequest = ''
    order by Product.ID; 
    
    VIEW ClassRequestJOB 
    AS SELECT FROM Product
    inner join ClassificationT
        on ClassificationT.ProductGUID = Product.GUID
        AND ClassificationT.Status != -1
    inner join ClientSchemeT
        on ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeT
        on SchemeT.Scheme = ClientSchemeT.Scheme
    {
        KEY Product.GUID                                    as ProductGUID,
        KEY ClientSchemeT.Scheme                            as Scheme,
            Product.Client                                  as Client,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            Product.UploadedBy                              as UploadedBy,
            Product.UploadedOn                              as UploadedOn,
            Product.FileName                                as FileName,
            Product.ExpertClassificationReq                 as ExpertClassificationReq,
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(Product.UploadedBy)                       as CIUploadedBy :String,
            UPPER(Product.FileName)                         as CIFileName :String
    }
    where ClassificationT.ProductGUID IS NULL 
        AND ClassificationT.Scheme IS NULL
        AND Product.Status = 1
        AND Product.ClassRequest = ''
    order by Product.ID; 
    
    VIEW ClassComments 
    AS select from Product as Prod 
    inner join ClassificationT as Class 
        ON Class.ProductGUID = Prod.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Scheme = Class.Scheme
    left outer join CCodeT
        on CCodeT.ID = Class.CodeID
        AND CCodeT.Scheme = Class.Scheme
    left outer join CCodeDescT
        on CCodeT.ID = CCodeDescT.CodeID
        AND CCodeT.Scheme = CCodeDescT.Scheme
    left outer join StatusT
        on StatusT.ID = Class.Status
    left outer join NoteT as Note
        on Note.ProductGUID = Prod.GUID 
        AND (Note.Scheme = Class.Scheme OR Note.Scheme is null)
        AND Note.Status = 1
    {
    KEY Prod.GUID                                    as ProductGUID,
        Prod.ID, 
        Prod.Description,
        Prod.ExpertClassificationReq,
        Class.Scheme,
        CCodeT.Code as Code,
        Class.ClassifiedBy as ClassifiedBy,
        Class.ClassifiedOn as ClassifiedOn,
        Class.Status  as ClassStatus,
        StatusT.Name  as Status,
        Note.Comment, 
        Note.Scheme as ![CommentScheme],
        Note.User as CommentBy, 
        Note.Date as CommentOn,
        Prod.UploadedOn as UploadedOn,
        UPPER(Prod.ID)                               as CIProduct :String,
        UPPER(Prod.Description)                      as CIDescription :String,
        UPPER(Class.ClassifiedBy)             as CIClassifiedBy :String
    }
    WHERE StatusT.Object = 'Classification'
    order by Prod.ID;
    
    VIEW InvoicedCodes
    AS SELECT FROM InvoicedCode 
    distinct
    {
        InvoicedCode.ProductGUID,
        InvoicedCode.Scheme,
        InvoicedCode.Code,
        InvoicedCode.ID,
        InvoicedCode.Probability,
        InvoicedCode.ClassifiedOn,
        InvoicedCode.ClassifiedBy,
        UPPER(InvoicedCode.ID) as CIProduct :String
    };
    
    view DQAClassifications as 
    select from User 
    inner join Product
        on Product.Client = User.Client
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
        AND ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = ClassificationT.Scheme
        AND SchemeUserT.Client = User.Client
        AND SchemeUserT.User = User.User
    left outer join CCodeT
        on CCodeT.ID = ClassificationT.CodeID
        AND CCodeT.Scheme = ClassificationT.Scheme
    left outer join CCodeDescT
        on CCodeT.ID = CCodeDescT.CodeID
        AND CCodeT.Scheme = CCodeDescT.Scheme
    left outer join StatusT
        on StatusT.ID = ClassificationT.Status
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.AttributeIndex = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.AttributeIndex = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.AttributeIndex = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name  
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.AttributeIndex = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.AttributeIndex = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name  
    left JOIN ClientAttribute as ClientAttribute6 on
        ClientAttribute6.AttributeIndex = 6
        AND ClientAttribute6.Client = User.Client      
    left JOIN Attribute as Attr6
        ON Product.GUID = Attr6.ProductGUID and Attr6.Name = ClientAttribute6.Name  
    left JOIN ClientAttribute as ClientAttribute7 on
        ClientAttribute7.AttributeIndex = 7
        AND ClientAttribute7.Client = User.Client      
    left JOIN Attribute as Attr7
        ON Product.GUID = Attr7.ProductGUID and Attr7.Name = ClientAttribute7.Name  
    left JOIN ClientAttribute as ClientAttribute8 on
        ClientAttribute8.AttributeIndex = 8
        AND ClientAttribute8.Client = User.Client      
    left JOIN Attribute as Attr8
        ON Product.GUID = Attr8.ProductGUID and Attr8.Name = ClientAttribute8.Name  
    left JOIN ClientAttribute as ClientAttribute9 on
        ClientAttribute9.AttributeIndex = 9
        AND ClientAttribute9.Client = User.Client      
    left JOIN Attribute as Attr9
        ON Product.GUID = Attr9.ProductGUID and Attr9.Name = ClientAttribute9.Name  
    left JOIN ClientAttribute as ClientAttribute10 on
        ClientAttribute10.AttributeIndex = 10
        AND ClientAttribute10.Client = User.Client      
    left JOIN Attribute as Attr10
        ON Product.GUID = Attr10.ProductGUID and Attr10.Name = ClientAttribute10.Name  
    {
        KEY ClassificationT.GUID                            as GUID,
            Product.GUID                                    as ProductGUID,
            ClassificationT.Scheme                          as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            CCodeT.Code                                     as Code,
            User.Client                                     as Client,
            'TC'                                            as Source,
            Attr1.Name                                      as Attribute1,
            Attr1.Value                                     as Value1,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Attr5.Value)                              as CIValue5,
            Attr6.Name                                      as Attribute6,
            Attr6.Value                                     as Value6,
            UPPER(Attr6.Value)                              as CIValue6 :String,
            Attr7.Name                                      as Attribute7,
            Attr7.Value                                     as Value7,
            UPPER(Attr7.Value)                              as CIValue7 :String,
            Attr8.Name                                      as Attribute8,
            Attr8.Value                                     as Value8,
            UPPER(Attr8.Value)                              as CIValue8 :String,
            Attr9.Name                                      as Attribute9,
            Attr9.Value                                     as Value9,
            UPPER(Attr9.Value)                              as CIValue9 :String,
            Attr10.Name                                      as Attribute10,
            Attr10.Value                                     as Value10,
            UPPER(Attr10.Value)                              as CIValue10 :String
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification' and (ClassificationT.Status = -3 or ClassificationT.Status = 3) 
    UNION
    select from User 
    inner join Product
        on Product.Client = User.Client
    inner join DQAClassificationT 
        ON DQAClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
        AND ClientSchemeT.Scheme = DQAClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = DQAClassificationT.Scheme
        AND SchemeUserT.Client = User.Client
        AND SchemeUserT.User = User.User
    left outer join StatusT
        on StatusT.ID = DQAClassificationT.Status
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.AttributeIndex = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.AttributeIndex = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.AttributeIndex = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name  
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.AttributeIndex = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.AttributeIndex = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name  
    left JOIN ClientAttribute as ClientAttribute6 on
        ClientAttribute6.AttributeIndex = 6
        AND ClientAttribute6.Client = User.Client      
    left JOIN Attribute as Attr6
        ON Product.GUID = Attr6.ProductGUID and Attr6.Name = ClientAttribute6.Name  
    left JOIN ClientAttribute as ClientAttribute7 on
        ClientAttribute7.AttributeIndex = 7
        AND ClientAttribute7.Client = User.Client      
    left JOIN Attribute as Attr7
        ON Product.GUID = Attr7.ProductGUID and Attr7.Name = ClientAttribute7.Name  
    left JOIN ClientAttribute as ClientAttribute8 on
        ClientAttribute8.AttributeIndex = 8
        AND ClientAttribute8.Client = User.Client      
    left JOIN Attribute as Attr8
        ON Product.GUID = Attr8.ProductGUID and Attr8.Name = ClientAttribute8.Name  
    left JOIN ClientAttribute as ClientAttribute9 on
        ClientAttribute9.AttributeIndex = 9
        AND ClientAttribute9.Client = User.Client      
    left JOIN Attribute as Attr9
        ON Product.GUID = Attr9.ProductGUID and Attr9.Name = ClientAttribute9.Name  
    left JOIN ClientAttribute as ClientAttribute10 on
        ClientAttribute10.AttributeIndex = 10
        AND ClientAttribute10.Client = User.Client      
    left JOIN Attribute as Attr10
        ON Product.GUID = Attr10.ProductGUID and Attr10.Name = ClientAttribute10.Name  
    {
            DQAClassificationT.GUID                         as GUID,
            Product.GUID                                    as ProductGUID,
            DQAClassificationT.Scheme                       as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            DQAClassificationT.CodeID                       as Code,
            User.Client                                     as Client,
            concat('DQA - ',Product.FileName)               as Source :String,
            Attr1.Name                                      as Attribute1,
            Attr1.Value                                     as Value1,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Attr5.Value)                              as CIValue5 :String,
            Attr6.Name                                      as Attribute6,
            Attr6.Value                                     as Value6,
            UPPER(Attr6.Value)                              as CIValue6 :String,
            Attr7.Name                                      as Attribute7,
            Attr7.Value                                     as Value7,
            UPPER(Attr7.Value)                              as CIValue7 :String,
            Attr8.Name                                      as Attribute8,
            Attr8.Value                                     as Value8,
            UPPER(Attr8.Value)                              as CIValue8 :String,
            Attr9.Name                                      as Attribute9,
            Attr9.Value                                     as Value9,
            UPPER(Attr9.Value)                              as CIValue9 :String,
            Attr10.Name                                      as Attribute10,
            Attr10.Value                                     as Value10,
            UPPER(Attr10.Value)                              as CIValue10 :String
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification' and (DQAClassificationT.Status = -3 or DQAClassificationT.Status = 3);
    
    view DQAClassificationsCurrentUser as 
    select from User 
    inner join Product
        on Product.Client = User.Client
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
        AND ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = ClassificationT.Scheme
        AND SchemeUserT.Client = User.Client
        AND SchemeUserT.User = User.User
    left outer join CCodeT
        on CCodeT.ID = ClassificationT.CodeID
        AND CCodeT.Scheme = ClassificationT.Scheme
    left outer join CCodeDescT
        on CCodeT.ID = CCodeDescT.CodeID
        AND CCodeT.Scheme = CCodeDescT.Scheme
    left outer join StatusT
        on StatusT.ID = ClassificationT.Status
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.AttributeIndex = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.AttributeIndex = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.AttributeIndex = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name  
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.AttributeIndex = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.AttributeIndex = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name  
    left JOIN ClientAttribute as ClientAttribute6 on
        ClientAttribute6.AttributeIndex = 6
        AND ClientAttribute6.Client = User.Client      
    left JOIN Attribute as Attr6
        ON Product.GUID = Attr6.ProductGUID and Attr6.Name = ClientAttribute6.Name  
    left JOIN ClientAttribute as ClientAttribute7 on
        ClientAttribute7.AttributeIndex = 7
        AND ClientAttribute7.Client = User.Client      
    left JOIN Attribute as Attr7
        ON Product.GUID = Attr7.ProductGUID and Attr7.Name = ClientAttribute7.Name  
    left JOIN ClientAttribute as ClientAttribute8 on
        ClientAttribute8.AttributeIndex = 8
        AND ClientAttribute8.Client = User.Client      
    left JOIN Attribute as Attr8
        ON Product.GUID = Attr8.ProductGUID and Attr8.Name = ClientAttribute8.Name  
    left JOIN ClientAttribute as ClientAttribute9 on
        ClientAttribute9.AttributeIndex = 9
        AND ClientAttribute9.Client = User.Client      
    left JOIN Attribute as Attr9
        ON Product.GUID = Attr9.ProductGUID and Attr9.Name = ClientAttribute9.Name  
    left JOIN ClientAttribute as ClientAttribute10 on
        ClientAttribute10.AttributeIndex = 10
        AND ClientAttribute10.Client = User.Client      
    left JOIN Attribute as Attr10
        ON Product.GUID = Attr10.ProductGUID and Attr10.Name = ClientAttribute10.Name  
    {
        KEY ClassificationT.GUID                            as GUID,
            Product.GUID                                    as ProductGUID,
            ClassificationT.Scheme                          as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            CCodeT.Code                                     as Code,
            'TC'                                            as Source :String,
            Attr1.Name                                      as Attribute1,
            Attr1.Value                                     as Value1,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Attr5.Value)                              as CIValue5 :String,
            Attr6.Name                                      as Attribute6,
            Attr6.Value                                     as Value6,
            UPPER(Attr6.Value)                              as CIValue6 :String,
            Attr7.Name                                      as Attribute7,
            Attr7.Value                                     as Value7,
            UPPER(Attr7.Value)                              as CIValue7 :String,
            Attr8.Name                                      as Attribute8,
            Attr8.Value                                     as Value8,
            UPPER(Attr8.Value)                              as CIValue8 :String,
            Attr9.Name                                      as Attribute9,
            Attr9.Value                                     as Value9,
            UPPER(Attr9.Value)                              as CIValue9 :String,
            Attr10.Name                                      as Attribute10,
            Attr10.Value                                     as Value10,
            UPPER(Attr10.Value)                              as CIValue10 :String
    }
    WHERE User.User = $user and Product.Status = 1 AND StatusT.Object = 'Classification' and (ClassificationT.Status = -3 or ClassificationT.Status = 3) 
    UNION
    select from User 
    inner join Product
        on Product.Client = User.Client
    inner join DQAClassificationT 
        ON DQAClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT
        on ClientSchemeT.Client = User.Client
        AND ClientSchemeT.Scheme = DQAClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = DQAClassificationT.Scheme
        AND SchemeUserT.Client = User.Client
        AND SchemeUserT.User = User.User
    left outer join StatusT
        on StatusT.ID = DQAClassificationT.Status
    left JOIN ClientAttribute as ClientAttribute1 on
        ClientAttribute1.AttributeIndex = 1
        AND ClientAttribute1.Client = User.Client      
    left JOIN Attribute as Attr1
        ON Product.GUID = Attr1.ProductGUID and Attr1.Name = ClientAttribute1.Name
    left JOIN ClientAttribute as ClientAttribute2 on
        ClientAttribute2.AttributeIndex = 2
        AND ClientAttribute2.Client = User.Client      
    left JOIN Attribute as Attr2
        ON Product.GUID = Attr2.ProductGUID and Attr2.Name = ClientAttribute2.Name
    left JOIN ClientAttribute as ClientAttribute3 on
        ClientAttribute3.AttributeIndex = 3
        AND ClientAttribute3.Client = User.Client      
    left JOIN Attribute as Attr3
        ON Product.GUID = Attr3.ProductGUID and Attr3.Name = ClientAttribute3.Name  
    left JOIN ClientAttribute as ClientAttribute4 on
        ClientAttribute4.AttributeIndex = 4
        AND ClientAttribute4.Client = User.Client      
    left JOIN Attribute as Attr4
        ON Product.GUID = Attr4.ProductGUID and Attr4.Name = ClientAttribute4.Name
    left JOIN ClientAttribute as ClientAttribute5 on
        ClientAttribute5.AttributeIndex = 5
        AND ClientAttribute5.Client = User.Client      
    left JOIN Attribute as Attr5
        ON Product.GUID = Attr5.ProductGUID and Attr5.Name = ClientAttribute5.Name  
    left JOIN ClientAttribute as ClientAttribute6 on
        ClientAttribute6.AttributeIndex = 6
        AND ClientAttribute6.Client = User.Client      
    left JOIN Attribute as Attr6
        ON Product.GUID = Attr6.ProductGUID and Attr6.Name = ClientAttribute6.Name  
    left JOIN ClientAttribute as ClientAttribute7 on
        ClientAttribute7.AttributeIndex = 7
        AND ClientAttribute7.Client = User.Client      
    left JOIN Attribute as Attr7
        ON Product.GUID = Attr7.ProductGUID and Attr7.Name = ClientAttribute7.Name  
    left JOIN ClientAttribute as ClientAttribute8 on
        ClientAttribute8.AttributeIndex = 8
        AND ClientAttribute8.Client = User.Client      
    left JOIN Attribute as Attr8
        ON Product.GUID = Attr8.ProductGUID and Attr8.Name = ClientAttribute8.Name  
    left JOIN ClientAttribute as ClientAttribute9 on
        ClientAttribute9.AttributeIndex = 9
        AND ClientAttribute9.Client = User.Client      
    left JOIN Attribute as Attr9
        ON Product.GUID = Attr9.ProductGUID and Attr9.Name = ClientAttribute9.Name  
    left JOIN ClientAttribute as ClientAttribute10 on
        ClientAttribute10.AttributeIndex = 10
        AND ClientAttribute10.Client = User.Client      
    left JOIN Attribute as Attr10
        ON Product.GUID = Attr10.ProductGUID and Attr10.Name = ClientAttribute10.Name  
    {
            DQAClassificationT.GUID                         as GUID,
            Product.GUID                                    as ProductGUID,
            DQAClassificationT.Scheme                       as Scheme,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            DQAClassificationT.CodeID                       as Code,
            concat('DQA - ',Product.FileName)               as Source :String,
            Attr1.Name                                      as Attribute1,
            Attr1.Value                                     as Value1,
            UPPER(Attr1.Value)                              as CIValue1 :String,
            Attr2.Name                                      as Attribute2,
            Attr2.Value                                     as Value2,
            UPPER(Attr2.Value)                              as CIValue2 :String,
            Attr3.Name                                      as Attribute3,
            Attr3.Value                                     as Value3,
            UPPER(Attr3.Value)                              as CIValue3 :String,
            Attr4.Name                                      as Attribute4,
            Attr4.Value                                     as Value4,
            UPPER(Attr4.Value)                              as CIValue4 :String,
            Attr5.Name                                      as Attribute5,
            Attr5.Value                                     as Value5,
            UPPER(Attr5.Value)                              as CIValue5 :String,
            Attr6.Name                                      as Attribute6,
            Attr6.Value                                     as Value6,
            UPPER(Attr6.Value)                              as CIValue6 :String,
            Attr7.Name                                      as Attribute7,
            Attr7.Value                                     as Value7,
            UPPER(Attr7.Value)                              as CIValue7 :String,
            Attr8.Name                                      as Attribute8,
            Attr8.Value                                     as Value8,
            UPPER(Attr8.Value)                              as CIValue8 :String,
            Attr9.Name                                      as Attribute9,
            Attr9.Value                                     as Value9,
            UPPER(Attr9.Value)                              as CIValue9 :String,
            Attr10.Name                                      as Attribute10,
            Attr10.Value                                     as Value10,
            UPPER(Attr10.Value)                              as CIValue10 :String
    }
    WHERE User.User = $user and Product.Status = 1 AND StatusT.Object = 'Classification' and (DQAClassificationT.Status = -3 or DQAClassificationT.Status = 3);
    
    view EccnClassified as
    select from EccnClassification
    inner join Product
        on EccnClassification.ProductGUID = Product.GUID
        and EccnClassification.Client = Product.Client
    left join ClassificationT
        on ClassificationT.ProductGUID = Product.GUID
        and ClassificationT.Status = 3
    left join CCodeT
        on CCodeT.ID = ClassificationT.CodeID
    left join StatusT
        on StatusT.ID = EccnClassification.Status
        and StatusT.Object = 'ECCN'
    left join ECCNMapping
        on EccnClassification.ECCN = ECCNMapping.US
    distinct
    {
        key Product.GUID                                    as ProductGUID,
            EccnClassification.ID                           as ID,
            Product.Client                                  as Client,
            Product.Description                             as Description,
            Product.UploadedOn,
            EccnClassification.ECCN,
            EccnClassification.COO,
            EccnClassification.InitCla,
            EccnClassification.Status,
            EccnClassification.PotentialECCN,
            EccnClassification.ActualECCN,
            EccnClassification.ExceptionECCN,
            EccnClassification.CanadaECCN,
            EccnClassification.CreatedOn,
            EccnClassification.CreatedBy,
            EccnClassification.ClassifiedBy,
            EccnClassification.ClassifiedOn,
            EccnClassification.ValidatedBy,
            EccnClassification.ValidatedOn,
            CCodeT.Code                                     as HS,
            StatusT.Name                                    as ClassificationStatus,
            Product.ExpertClassificationReq                 as ExpertClassificationReq,
            ClassificationT.Scheme                          as Scheme,
            StatusT.Object,
            StatusT.ID                                      as StatusID,
            ECCNMapping.CA
    };
    
};