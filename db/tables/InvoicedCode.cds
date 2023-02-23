namespace tc.tables;

entity InvoicedCode { 
    KEY ProductGUID             : String(32);
    Key Scheme                  : String(32);
    Key Code                    : String(32);
        Client                  : String(32);
        ID                      : String(60);
        Probability             : Integer;
        ClassifiedOn            : Timestamp;
        ClassifiedBy            : String(32);
        DropOnReset             : hana.TINYINT;
 };