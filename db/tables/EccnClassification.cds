namespace tc.tables;

entity EccnClassification {
    key ProductGUID             : String(32);
        ECCN                    : String(20);
        COO                     : String(3);
        InitCla                 : Timestamp;
        Status                  : hana.TINYINT;
        PotentialECCN           : String(20);
        ActualECCN              : String(2000);
        CanadaECCN              : String(2000);
        ExceptionECCN           : String(20);
        CreatedOn               : Timestamp;
        CreatedBy               : String(32);
        Client                  : String(32);
        ID                      : String(60);
        ClassifiedBy            : String(32);
        ClassifiedOn            : Timestamp;
        ValidatedBy             : String(32);
        ValidatedOn             : Timestamp;
};