namespace tc.tables;

entity GTSAttrInput {
    key PRID        : String(60);
    key CLIENT      : String(32);
    key NAME        : String(50);
        VALUE       : String(100);
};