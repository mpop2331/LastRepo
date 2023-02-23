namespace tc.tables;

entity ActivityAttribute {
    key ActivityGUID        : String(32);
    key Name                : String(32);
        Value               : String(100);
};