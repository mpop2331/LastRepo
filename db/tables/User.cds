namespace tc.tables;

entity User {
    key User            : String(64);
        FirstName       : String(64);
        LastName        : String(64);
        Email           : String(64);
        Client          : String(32);
        Role            : Integer not null default 1;
        Language        : String(2); 
        Status          : hana.TINYINT;
        ModifiedBy      : String(32);
        ModifiedDate    : Timestamp; 
}
