namespace tc.tables;

entity Scheme {
    key Scheme          : String(32);
        Name            : String(100);
        Version         : Integer;
        TopLevel        : String(32); 
        BottomLevel     : String(32);
        CreatedBy       : String(32);
        CreatedOn       : Timestamp default CURRENT_TIMESTAMP;
        LastModifiedBy  : String(32);
        LastModifiedOn  : Timestamp default CURRENT_TIMESTAMP;
        ValidForECCN    : hana.TINYINT default 0;
};