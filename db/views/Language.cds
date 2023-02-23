namespace tc.views;
using tc.tables.Language as LanguageTable from '../tables/Language';

context Language{
    //Upload, reclassify
    VIEW Language AS 
    SELECT FROM LanguageTable
    {
        KEY ID      AS ID,
            Name    AS Name
    };
}