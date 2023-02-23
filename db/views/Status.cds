namespace tc.views;
using tc.tables.Status as StatusT from '../tables/Status';

context Status{
    VIEW Status 
    AS SELECT FROM StatusT
    {
        KEY StatusT.ID          AS ID,
        KEY StatusT.Object      AS Object,
            StatusT.Name        AS Name
    };
}