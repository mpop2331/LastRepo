namespace tc.tables;

entity UserActivity {
    key GUID                  : String(32);
        User                  : String(64);
        ApplicationActivityID : Integer ;
        Status                : Integer ;
        CreatedOn             : Timestamp;
};