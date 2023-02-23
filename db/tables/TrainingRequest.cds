namespace tc.tables;

entity TrainingRequest {
    key GUID        : String(32);
        Client      : String(32);
        Request     : LargeString;
        Priority    : Integer;
        Scheme      : String(32);
};