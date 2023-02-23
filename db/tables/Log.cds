namespace tc.tables;

entity Log {
    KEY User                    : String(32);
    KEY Timestamp               : Timestamp;
        Client                  : String(32) not null;
        ObjectType              : String(32);
        Method                  : Integer;
        Action                  : String(32);
        MessageCode             : Integer;
        Body                    : LargeString;
        Error                   : String(1000);
} 