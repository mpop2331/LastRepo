namespace tc.views;
using tc.tables.Country as CountryT from '../tables/Country';
using tc.tables.CountryScheme as CountrySchemeT from '../tables/CountryScheme';
using tc.tables.ClientScheme as ClientScheme from '../tables/ClientScheme';
using tc.tables.User as User from '../tables/User';

context Country{
    //Depreciated
    view Country 
    as select from CountryT
    inner join CountrySchemeT
        on CountrySchemeT.CountryID = CountryT.ID
    inner join ClientScheme
        on ClientScheme.Scheme = CountrySchemeT.SchemeGUID
    {
        key CountryT.ID as ID,
        CountryT.Name
    };
    //Depreciated
    view CountryScheme 
    as select from CountrySchemeT
    inner join ClientScheme
        on ClientScheme.Scheme = CountrySchemeT.SchemeGUID
    {
        key CountrySchemeT.CountryID as CountryID,
        key CountrySchemeT.SchemeGUID as SchemeGUID,
        CountrySchemeT.Import_Export as ImpExp
    };
}