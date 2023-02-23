namespace tc.tables;

entity Client {
    key Client                  : String(32);
    key ValidFrom               : Timestamp;
    key ValidTill               : Timestamp;
        Name                    : String(100);
        MemberFirm              : String(2) default 'BE';
        MemberFirmFactor        : Decimal(5,3) default 1;
        ClassificationFactor    : Decimal(5,3) default 1;
        SubscriptionFee         : Integer default 1000;
        SaaS                    : hana.TINYINT default 1;
        Demo_mode_active        : hana.TINYINT;
        Active                  : hana.TINYINT default 1;
        ValAutoClass            : hana.TINYINT default 1;
        StartDate               : Timestamp;
        EndDate                 : Timestamp;
        TotalItems              : Integer default 0; // total of autoclassified items
        MultiSchemeWorklist     : hana.TINYINT default 0;
        AttributeFirst          : hana.TINYINT default 0;
        SubmodelFlag            : hana.TINYINT;
        DefaultLanguage         : String(2) default 'EN'; 
        Threshold               : Integer default 100;
        BusinessRuleEnabled     : hana.TINYINT default 0;
        VariantsEnabled         : hana.TINYINT default 0;
        MainScheme              : String(32);
        EccnEnabled             : hana.TINYINT;
        ExcludedFromML          : String(100);
        RelevantAttributeName   : String(100);
        RelevantAttributeValue  : String(100);
        NumberOfDays            : Integer default 5;
}; 