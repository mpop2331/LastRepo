namespace tc.tables;

entity GTSProdInput {
    key PRID            : String(60);
    key CLIENT          : String(32);
        LSGROUP         : String(32);
        DESCRIPTION     : String(500);
        NUMSCHEME       : String(32);
        CODE            : String(32);
        LANGUAGE        : String(2);
        CLASSREQ        : hana.TINYINT;
};