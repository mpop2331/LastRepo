namespace tc.tables;

entity SchemeUser {
    Key Scheme          : String(32);
    Key Client          : String(32);
    Key User            : String(32);
};