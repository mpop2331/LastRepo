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
using tc.tables.Replacement as ReplacementT from '../tables/Replacement';
using tc.tables.ReplacementFile as ReplacementFileT from '../tables/ReplacementFile';

context Replacements{ // CDS View : Client specific replacements
    VIEW recentNote as select from NoteT 
    { 
        max(NoteT.Date) as Date,
        NoteT.ProductGUID
    } Group by NoteT.ProductGUID;
    
    view Replacements as 
    select from Product
    inner join ClassificationT 
        ON ClassificationT.ProductGUID = Product.GUID
    inner join ClientSchemeT on
      ClientSchemeT.Scheme = ClassificationT.Scheme
    inner join SchemeUserT
        on SchemeUserT.Scheme = ClassificationT.Scheme
    left outer join CCodeT
        on CCodeT.ID = ClassificationT.CodeID 
        AND CCodeT.Scheme = ClassificationT.Scheme
    inner join ReplacementT
        on ReplacementT.CodeOld = CCodeT.Code
        AND ReplacementT.Scheme = ClassificationT.Scheme
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
    {
        KEY ClassificationT.GUID                            as GUID,
        KEY ReplacementT.GUID                               as ReplacementGUID,
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
            ClassificationT.ManualClassification            as ManClass,
            StatusT.Name                                    as StatusDescription,
            ReplacementT.CodeOld                            as CodeOld,
            ReplacementT.CodeNew                            as CodeNew,
            ReplacementT.ValidTillOld                       as ValidTillOld,
            ReplacementT.ValidTillNew                       as ValidTillNew,
            ReplacementT.ValidFromOld                       as ValidFromOld,
            ReplacementT.ValidFromNew                       as ValidFromNew,
            ReplacementT.Filename                           as XMLFile,
            ReplacementT.UploadDate                         as XMLUpload,
            ReplacementT.Replacements                       as Replacements,
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
            (CASE ClassificationT.AssignedTo WHEN current_user then '1'else '0' END) as ToMe : String                                 
    }
    WHERE Product.Status = 1 AND StatusT.Object = 'Classification' 
    AND (ClassificationT.Status = 3 OR ClassificationT.Status = 2) AND ClassificationT.ManualClassification = 0
    AND ReplacementT.CodeOld != ReplacementT.CodeNew;
    
    //Scheme Management
    VIEW ReplacementFiles AS 
    SELECT FROM ReplacementFileT
    {
        KEY ReplacementFileT.Scheme              AS Scheme,
        KEY ReplacementFileT.Version             AS Version,
        KEY ReplacementFileT.Index               AS Index,
            ReplacementFileT.MaxIndex            AS MaxIndex,
            ReplacementFileT.FileName            AS FileName,
            ReplacementFileT.UploadedBy          AS UploadedBy,
            ReplacementFileT.UploadedOn          AS UploadedOn
    };

};