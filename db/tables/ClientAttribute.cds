namespace tc.tables;

entity ClientAttribute {
    key Client              : String(32);
    key Name                : String(100);
        ViewAttribute       : Integer;
        ML                  : hana.TINYINT;
        SubModelParam       : hana.TINYINT; 
        AttributeIndex      : Integer;
};