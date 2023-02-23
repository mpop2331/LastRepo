namespace tc.tables;

entity Note {
    key GUID                    : String(32);
        ProductGUID             : String(32);
        Client                  : String(32);
        Scheme                  : String(32);
        Source                  : String(32);
        Comment                 : String(2000);
        User                    : String(64);
        Date                    : Timestamp;
        Status                  : Integer default 0;
} 