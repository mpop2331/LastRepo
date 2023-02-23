namespace tc.tables;

entity ExternalProduct {
    key ID                      : String(40);
        Description             : String(60);
        Number                  : String(20);
        Language                : String(8);
        Source                  : String(40);
};