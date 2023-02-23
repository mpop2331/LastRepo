namespace tc.tables;

entity ConditionBusiness {
    key GUID                    : String(32);
        ID                      : String(60);
        Client                  : String(32);
        Field                   : String(32);
        BusinessCondition       : String(32);
        Value                   : String(100);
} 