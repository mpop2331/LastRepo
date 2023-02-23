namespace tc.tables;

entity Period {
    Key Client: String(32);	
    Key Period : String(32);
    Count : Integer default 0;
    InactiveDays: Integer default 0;
}; 