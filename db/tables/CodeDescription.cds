namespace tc.tables;

entity CodeDescription {
    KEY CodeID          : String(32);
    KEY Scheme          : String(32);
    KEY Language        : String(2);
        Description     : String(5000);
};
