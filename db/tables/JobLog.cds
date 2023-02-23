namespace tc.tables;

entity JobLog { 
    key GUID    : String(32);
    Job         : String(32);
    Client      : String(32);
    User        : String(64);
    Scheme      : String(32);
    CreatedOn   : Timestamp;
    ScheduledTo : Timestamp;
    Status      : Integer default 0;
    NrItems     : Integer default 0;
    NrIterations: Integer default 1;
};