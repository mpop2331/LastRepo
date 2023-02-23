namespace tc.tables;

entity Replacement { 
    KEY GUID                    : String(32);
        Scheme                  : String(32);
        CodeOld                 : String(32);
        CodeNew                 : String(32);
        IDOld                   : String(32);
        IDNew                   : String(32);
        Action                  : String(32);
        Replacements            : String(32);
        Filename                : String(32);
        ValidFromOld            : Timestamp;
        ValidTillOld            : Timestamp;
        ValidFromNew            : Timestamp;
        ValidTillNew            : Timestamp; 
        UploadDate              : Timestamp;
 };