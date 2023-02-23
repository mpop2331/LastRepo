namespace tc.tables;
 
entity Code {
    KEY ID              : String(32);
    KEY Scheme          : String(32);
        ValidFrom       : Timestamp; //validity_begin
        ValidTill       : Timestamp; //validity_end in the file
        Code            : String(32);
        ParentID        : String(32);
        Level           : String(8);
};
