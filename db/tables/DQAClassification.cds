namespace tc.tables;

entity DQAClassification { 
    KEY GUID                    : String(32); 
        ProductGUID             : String(32); 
        Scheme                  : String(32);
        CodeID                  : String(32);
        Priority                : Integer;
        ConfidenceLevel         : hana.REAL;
        Type                    : String(10);
        DropOnReset             : hana.TINYINT;
        Status                  : Integer default 0;
        CreatedBy               : String(32);
        CreatedOn               : Timestamp;
        AssignedOn              : Timestamp;
        AssignedTo              : String(32);
        ClassifiedBy            : String(32);
        ClassifiedOn            : Timestamp;
        ValidatedBy             : String(32);
        ValidatedOn             : Timestamp;
        ValidFrom               : Timestamp;
        ValidTill               : Timestamp;
        ManualClassification    : Integer default 0;
 };