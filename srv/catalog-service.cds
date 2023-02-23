using {tc.views.Country as CountryContext} from '../db/views/Country';
using {tc.views.Replacements as ReplacementsContext} from '../db/views/Replacements';
using {tc.views.Schemes as SchemesContext} from '../db/views/Schemes';
using {tc.views.Logs as LogsContext} from '../db/views/Logs';
using {tc.views.ExternalProducts as ExternalProductsContext} from '../db/views/ExternalProducts';
using {tc.views.Classifications as ClassificationsContext} from '../db/views/Classifications';
using {tc.views.Users as UsersContext} from '../db/views/Users';
using {tc.views.UserActivities as UserActivitiesContext} from '../db/views/UserActivities';
using {tc.views.Status as StatusContext} from '../db/views/Status';
using {tc.views.Language as LanguageContext} from '../db/views/Language';
using {tc.views.KPI as KPIContext} from '../db/views/KPI';
using {tc.views.DateClassifications as DateClassificationsContext} from '../db/views/DateClassifications';
using {tc.views.ManualClassifications as ManualClassificationsContext} from '../db/views/ManualClassifications';
using {tc.views.ClassificationsManual as ClassificationsManualContext} from '../db/views/ClassificationsManual';
using {tc.views.ClassificationsAnnomalies as ClassificationsAnnomaliesContext} from '../db/views/ClassificationsAnnomalies';
using {tc.views.Products as ProductContext} from '../db/views/Products';
using {tc.views.Notes as NotesContext} from '../db/views/Notes';
using {tc.views.Invoice as InvoiceContext} from '../db/views/Invoice';
using {tc.views.DQA as DQAContext} from '../db/views/DQA';
using {tc.views.BusinessRule as BusinessRuleContext} from '../db/views/BusinessRule';
using {tc.views.Attributes as AttributesContext} from '../db/views/Attributes';

service CatalogService @(path : '/catalog') @(restrict : [
  {
    grant : 'READ',
    to    : 'authenticated-user'
  },
  {
    grant : ['READ'],
    to    : 'Viewer'
  },
  {
    grant : ['*'],
    to    : 'Admin'
  }
]) {

  entity Products                  as projection on ProductContext.Products {
    *,
    Notes : Association to many Notes
              on GUID = Notes.ProductGUID
  };
  entity Classifications           as projection on ClassificationsContext.Classifications{
    *,
    Notes : Association to many Notes
              on ProductGUID = Notes.ProductGUID
  };
  entity Country                   as projection on CountryContext.Country
  entity Replacements              as projection on ReplacementsContext.Replacements
  entity ReplacementFiles          as projection on ReplacementsContext.ReplacementFiles
  entity Schemes                   as projection on SchemesContext.Schemes
  entity ClassReqJobLogs           as projection on LogsContext.ClassReqJobLogs
  entity UploadLogs                as projection on LogsContext.UploadLogs
  entity ExternalProducts          as projection on ExternalProductsContext.ExternalProducts
  entity CCodes                    as projection on SchemesContext.CCodes
  entity SchemeFiles               as projection on SchemesContext.SchemeFiles
  entity SchemeUser                as projection on SchemesContext.SchemeUser
  entity SchemeUsers               as projection on SchemesContext.SchemeUsers
  entity ClassRequest              as projection on ClassificationsContext.ClassRequest
  entity ClassRequestJOB           as projection on ClassificationsContext.ClassRequestJOB
  entity ClassComments             as projection on ClassificationsContext.ClassComments
  entity Roles                     as projection on UsersContext.Roles
  entity CurrentUser               as projection on UsersContext.CurrentUser
  entity CurrentUserActivities     as projection on UserActivitiesContext.CurrentUserActivities
  entity UserActivities            as projection on UserActivitiesContext.UserActivities
  entity Users                     as projection on UsersContext.Users
  entity Status                    as projection on StatusContext.Status
  entity Language                  as projection on LanguageContext.Language
  entity ClientAggregation         as projection on KPIContext.ClientAggregation
  entity ProductsClassification    as projection on KPIContext.ProductsClassification
  entity ClassificationsScheme     as projection on KPIContext.ClassificationsScheme
  entity ClassificationsUser       as projection on KPIContext.ClassificationsUser
  entity RejectsUser               as projection on KPIContext.RejectsUser
  entity Filters                   as projection on KPIContext.Filters
  entity TotalProducts             as projection on KPIContext.Products
  entity ToBeValidated             as projection on KPIContext.ToBeValidated
  entity ClassificationsDay        as projection on DateClassificationsContext.ClassificationsDay
  entity ClassificationsMonth      as projection on DateClassificationsContext.ClassificationsMonth
  entity ClassificationsYear       as projection on DateClassificationsContext.ClassificationsYear
  entity ManualClassifications     as projection on ManualClassificationsContext.ManualClassifications
  entity ClassificationsManual     as projection on ClassificationsManualContext.ClassificationsManual
  entity TotalClassifications      as projection on KPIContext.TotalClassified
  entity ClassificationsAnnomalies as projection on ClassificationsAnnomaliesContext.ClassificationsAnnomalies
  entity Attributes                as projection on ProductContext.Attributes
  entity Notes                     as projection on NotesContext.Notes
  entity InvoiceDetail             as projection on InvoiceContext.MonthName
  entity Invoice                   as projection on InvoiceContext.InvoiceMonth
  entity InvoicedCodes             as projection on ClassificationsContext.InvoicedCodes
  entity Dqa                       as projection on DQAContext.Dqa
  entity DqaRequests               as projection on DQAContext.DqaRequest
  entity ProductSet                as projection on ClassificationsContext.EccnClassified
  entity DQAClassifications        as projection on ClassificationsContext.DQAClassificationsCurrentUser
  entity ConditionBusiness         as projection on BusinessRuleContext.ConditionBusiness
  entity Rule                      as projection on BusinessRuleContext.Rule
  entity ViewAttributes            as projection on AttributesContext.ViewAttributes;
  entity ClientAttributes          as projection on AttributesContext.Attributes;

  function getCurrentUser() returns {
    Client : String;
  }

};
