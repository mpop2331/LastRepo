namespace tc.tables;

entity CountryScheme {
    key CountryID       : String(2);
    key SchemeGUID      : String(32);
        Import_Export   : Integer;
};