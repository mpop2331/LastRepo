namespace tc.tables;

entity Attribute {  
    key ProductGUID         : String(32);
    key Name                : String(100);
        Value               : String(5000);
        ML                  : hana.TINYINT;
        Active              : hana.TINYINT default 1;
};