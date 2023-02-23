namespace tc.tables;

entity ClientScheme {
    Key Client          : String(32);
    Key Scheme          : String(32);
        Api_key         : String(32);
        BufferSize      : Integer default 10;
        Threshold       : Integer default 90;
        NrIterations    : Integer default 5;
        LastTraining      : Timestamp;
        Busy            : hana.TINYINT default 0;
};