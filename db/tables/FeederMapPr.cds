namespace tc.tables;

entity FeederMapPr {
    key LSGROUP             : String(32);
    key EXTERNALID          : String(60);
        INTERNALGUID        : String(32);
};