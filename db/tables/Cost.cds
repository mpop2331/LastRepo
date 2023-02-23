namespace tc.tables;

entity Cost{
    Key Client      : String(32);	
    Key Name        : String(32);
        Type        : String(32);
        Value       : Decimal(10,3);
        StartDate   : Timestamp;
        EndDate     : Timestamp;
}; 