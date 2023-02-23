namespace tc.tables;

entity JobQueue {
    key GUID        : String(32);
        Client      : String(32);
        Scheme      : String(32);
        Request     : LargeString;
        Priority    : Integer;
        Job         : String(50);
};