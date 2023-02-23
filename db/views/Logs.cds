namespace tc.views;
using tc.tables.JobLog as JobLog from '../tables/JobLog';
using tc.tables.User as User from '../tables/User';
using tc.tables.Product as Product from '../tables/Product';
using tc.tables.UploadLog as UploadLog from '../tables/UploadLog';


context Logs{ 
    VIEW ClassReqJobLogs AS SELECT FROM JobLog  {
        key JobLog.GUID     as GUID,
        JobLog.Job          as Job,
        JobLog.Client       as Client,
        JobLog.User         as User,
        JobLog.CreatedOn    as CreatedOn,
        JobLog.ScheduledTo  as ScheduledTo,
        JobLog.Status       as Status,
        JobLog.NrItems      as NrItems,
        JobLog.Scheme       as Scheme
    };
    
    VIEW UploadLogs
    AS SELECT FROM UploadLog
    INNER JOIN Product 
        ON UploadLog.ProductGUID = Product.GUID
        {
        key UploadLog.GUID          as GUID,
        UploadLog.ProductGUID       as ProductGUID,
        UploadLog.Client            as Client,
        UploadLog.User              as User,
        UploadLog.Type              as Type,
        UploadLog.Name              as Name,
        UploadLog.OldValue          as OldValue,
        UploadLog.NewValue          as NewValue,
        Product.ID                  as ID,
        Product.UploadedOn          as UploadedOn,
        Product.UploadedBy          as UploadedBy,
        Product.FileName            as Filename
    };
};