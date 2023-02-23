namespace tc.tables;

entity SchemeFile {
    KEY Scheme          : String(32);
    KEY Version         : Integer;
    KEY Index           : Integer;
        MaxIndex        : Integer;
        Type            : String(8);
        FileName        : String(100);
        UploadedOn      : Timestamp; 
        UploadedBy      : String(32);
};
