namespace tc.tables;

entity Price {
    KEY Default                 : Integer;
    KEY ValidFrom               : Timestamp;
    KEY ValidTill               : Timestamp; 
        Client                  : String(32); // default for key  
        Threshold               : Integer;
        Price                   : Decimal(5,3);
        InvoicedItem            : String(32);
}; 