namespace tc.views;
using tc.tables.User as UserT from '../tables/User';
using tc.tables.ClientScheme as ClientSchemeT from '../tables/ClientScheme';
using tc.tables.Scheme as SchemeT from '../tables/Scheme';
using tc.tables.SchemeDescription as SchemeDesc from '../tables/SchemeDescription';
using tc.tables.Code as CCodeT from '../tables/Code';
using tc.tables.SchemeFile as SchemeFileT from '../tables/SchemeFile';
using tc.tables.CodeDescription as CCodeDescT from '../tables/CodeDescription';
using tc.tables.SchemeUser as SchemeUserT from '../tables/SchemeUser';

context Schemes { // CDS View : Client specific schemes
 
    //Scheme Management
    VIEW Schemes AS 
    SELECT FROM SchemeT
    LEFT OUTER JOIN SchemeDesc 
        ON SchemeT.Scheme = SchemeDesc.Scheme
    {
        KEY SchemeT.Scheme              AS Scheme,
            SchemeT.Version             AS Version,
            SchemeDesc.Description      AS Description,
            SchemeT.ValidForECCN        AS ValidForECCN,
            SchemeDesc.Language         AS Language
    };
    
    //Worklist, Validation, Reclassify
    VIEW CCodes AS 
    SELECT FROM CCodeT
    INNER JOIN ClientSchemeT
        ON ClientSchemeT.Scheme = CCodeT.Scheme
    LEFT OUTER JOIN CCodeDescT
        ON CCodeDescT.CodeID = CCodeT.ID
        AND CCodeDescT.Scheme = CCodeT.Scheme
    INNER JOIN SchemeT
        ON CCodeT.Scheme = SchemeT.Scheme
    {
        KEY CCodeT.ID               AS CCodeID,
        KEY CCodeT.Scheme           AS Scheme,
        KEY CCodeDescT.Language     AS Language,
            CCodeT.Code             AS CCode,
            CCodeT.ParentID         AS ParentID,
            CCodeT.Level            AS Level,
            CCodeDescT.Description  AS Description,
            CCodeT.ValidFrom        AS ValidFrom,
            CCodeT.ValidTill        AS ValidTill,
            UPPER(CCodeDescT.Description)  AS UDescription :String,
            (CASE CCodeT.Level WHEN SchemeT.BottomLevel then '1' else '0' END) AS BottomLevel :String,
            (CASE CCodeT.Level WHEN SchemeT.TopLevel then '1' else '0' END) AS TopLevel :String
    }
    WHERE CCodeT.ValidFrom < current_utctimestamp()
    AND CCodeT.ValidTill > CURRENT_UTCTIMESTAMP();
    
    //Worklist, Upload
    VIEW SchemeUser AS 
    SELECT FROM UserT
    INNER JOIN ClientSchemeT 
        ON ClientSchemeT.Client = UserT.Client
        AND UserT.User = $user
    INNER JOIN SchemeUserT
        ON SchemeUserT.Scheme = ClientSchemeT.Scheme
        AND SchemeUserT.Client = UserT.Client
        AND SchemeUserT.User = $user
    INNER JOIN SchemeT
        ON SchemeUserT.Scheme = SchemeT.Scheme
    {
        KEY SchemeUserT.Scheme              AS Scheme,
        KEY SchemeUserT.User                AS User
    }
    WHERE SchemeT.ValidForECCN = 0;
    
    VIEW SchemeUsers AS 
    SELECT FROM UserT
    INNER JOIN ClientSchemeT 
        ON ClientSchemeT.Client = UserT.Client
    INNER JOIN SchemeUserT
        ON SchemeUserT.Scheme = ClientSchemeT.Scheme
        AND SchemeUserT.Client = UserT.Client
    INNER JOIN UserT as CurrentUser
        ON CurrentUser.User = current_user
        AND CurrentUser.Client = UserT.Client
    {
        KEY SchemeUserT.Scheme              AS Scheme,
        KEY SchemeUserT.User                AS User
    }
    WHERE UserT.Status = 1;
    
    //Scheme Management
    VIEW SchemeFiles AS 
    SELECT FROM SchemeFileT
    {
        KEY SchemeFileT.Scheme              AS Scheme,
        KEY SchemeFileT.Version             AS Version,
        KEY SchemeFileT.Index               AS Index,
            SchemeFileT.MaxIndex            AS MaxIndex,
            SchemeFileT.FileName            AS FileName,
            SchemeFileT.UploadedBy          AS UploadedBy,
            SchemeFileT.UploadedOn          AS UploadedOn
    };
}