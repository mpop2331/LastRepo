namespace tc.tables;

entity ApplicationActivity {
    key ID                  : Integer ;
        Application         : String(64);
        Activity            : String(64);
};