namespace tc.tables;

entity Rule {
    key GUID                    : String(32);
        ID                      : String(60);
        Client                  : String(32);
        ParentClassification    : String(32);
        Rule                    : String(300);
        Scheme                  : String(32);
        ClassificationCode      : String(64);

} 