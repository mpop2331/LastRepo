namespace tc.tables;

entity Product {
    key GUID                            : String(32);
        ID                              : String(60);
        Client                          : String(32);
        Description                     : String(500);
        Language                        : String(2) default 'EN';
        Status                          : hana.TINYINT default 0;
        UploadedOn                      : Timestamp;
        UploadedBy                      : String(32);
        FileName                        : String(100);
        DropOnReset                     : hana.TINYINT;
        ClassRequest                    : String(50) default '';
        ExpertClassificationReq         : hana.TINYINT default '1';
        ScoringDate                     : Timestamp;
        Completion                      : Integer;
};