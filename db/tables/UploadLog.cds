namespace tc.tables;

entity UploadLog { 
    key GUID        : String(32);
    ProductGUID     : String(32);
    Client          : String(32);
    User            : String(64);
    Type            : Integer;
    Name            : String(32);
    OldValue        : String(500);
    NewValue        : String(500);
};