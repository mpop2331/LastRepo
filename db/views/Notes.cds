namespace tc.views;
using tc.tables.Note as Note from '../tables/Note';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.User as User from '../tables/User';

context Notes{
    view Notes 
    as select from  Note
    inner join Product
        on Product.GUID = Note.ProductGUID
    {
        key Note.GUID as GUID,
            Note.ProductGUID as ProductGUID,
            Note.Scheme as Scheme,
            Note.Source as Source,
            Note.Comment as Comment,
            Note.User as User,
            Note.Date as Date
    }
    where Note.Status = 1;
};