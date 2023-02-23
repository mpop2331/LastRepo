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
using tc.tables.ClientMultiScheme as ClientMultiSchemeT from '../tables/ClientMultiScheme';

context ClassificationsAnnomalies{ // CDS View : Client specific level #Classifications with Annomalies per user
     
      
    view ClassificationsAnnomalies as 
    select from Product 
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
        and (ClassificationT.Status = -3 or ClassificationT.Status = 3)
    inner join ClientSchemeT
        on ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = ClassificationT.Scheme
    left outer join CCodeT
        on CCodeT.ID = ClassificationT.CodeID
        AND CCodeT.Scheme = ClassificationT.Scheme
    left outer join CCodeDescT
        on CCodeT.ID = CCodeDescT.CodeID
        AND CCodeT.Scheme = CCodeDescT.Scheme
    left outer join StatusT
        on StatusT.ID = ClassificationT.Status
    inner join ClassificationT as ClassificationAnom
        ON ClassificationAnom.ProductGUID = Product.GUID
        AND ClassificationT.Scheme > ClassificationAnom.Scheme
        and (ClassificationAnom.Status = -3 or ClassificationAnom.Status = 3)
    inner join ClientMultiSchemeT as cms
      on  
      cms.SchemeOne = ClassificationT.Scheme 
      AND
      cms.SchemeTwo = ClassificationAnom.Scheme
      left outer join CCodeT as ccdt
        on ccdt.ID = ClassificationAnom.CodeID
        AND ccdt.Scheme = ClassificationAnom.Scheme

    distinct
    {
        KEY ClassificationT.GUID                            as GUID,
            ClassificationAnom.GUID                         as GUID2,
            Product.GUID                                    as ProductGUID,
            ClassificationT.Scheme                          as Scheme1,
            ClassificationAnom.Scheme                       as Scheme2,
            SUBSTRING(CCodeT.Code, 1, cms.Digits)           as CodeBase1 :String,
            SUBSTRING(ccdt.Code, 1, cms.Digits)             as CodeBase2 :String,
            Product.ID                                      as ID,
            Product.Description                             as Description,
            Product.Language                                as Language,
            Product.Status                                  as Status,
            Product.ExpertClassificationReq                 as ExpertClassificationReq, 
            Product.ScoringDate                             as ScoringDate,
            CCodeT.Code                                     as Code,
            ccdt.Code                                       as Code2,
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
            UPPER(Product.ID)                               as CIProduct :String,
            UPPER(Product.Description)                      as CIDescription :String,
            UPPER(ClassificationT.AssignedTo)               as CIAssignedTo :String,
            UPPER(ClassificationT.ValidatedBy)              as CIValidatedBy :String,
            UPPER(ClassificationT.ClassifiedBy)             as CIClassifiedBy :String,
            (CASE ClassificationT.AssignedTo WHEN current_user then '1'else '0' END) as ToMe :String                                   
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification' 
    AND 
    SUBSTRING(CCodeT.Code, 1, cms.Digits) <> SUBSTRING(ccdt.Code, 1, cms.Digits) ;
};