namespace tc.tables;

entity DQARequest { 
    KEY GUID                    : String(32);
        Request                 : String(100); 
        Description             : LargeString;
        Client                  : String(32) not null;
        Scheme                  : String(32) not null;
        RelevantAttributes      : String(1000);
        DropOnReset             : hana.TINYINT;
        NrItems                 : Integer;
 };