namespace tc.tables;

entity SchemeDescription {
    key Scheme          : String(32);
    key Language        : String(2);
        Description     : String(5000);
};
