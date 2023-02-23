namespace tc.tables;

entity ClientMultiScheme {
    Key Client          : String(32);
    Key SchemeOne       : String(32);
    Key SchemeTwo       : String(32);
        Digits          : Integer default 0;
};