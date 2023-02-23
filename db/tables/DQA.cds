namespace tc.tables;

entity DQA {
    KEY RequestID               : String(100);
    KEY ProductID               : String(32);
        Submodel                : String(500);
        Description             : String(5000) not null;
        CCode                   : String(32) not null;
        Client                  : String(32) not null;
        Scheme                  : String(32) not null;
        NumberOfCodes           : Integer;
        ConsistencyRatio        : Integer;
        CodeInvalid             : hana.TINYINT;
        StrongInconsistency     : hana.TINYINT;
        ClusterID               : Integer;
        ClusterSilouette        : Double;
        AnomalyMajor            : hana.TINYINT;
        AnomalyMinor            : hana.TINYINT;
        AnomalyDegree           : Integer;
        DropOnReset             : hana.TINYINT;
 };