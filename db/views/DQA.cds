namespace tc.views;
using tc.tables.DQA as DqaT from '../tables/DQA';
using tc.tables.DQARequest as DqaRequestT from '../tables/DQARequest';

context DQA{

VIEW Dqa
    AS SELECT FROM DqaT
    {
        DqaT.RequestID,
        DqaT.Submodel,
        DqaT.ProductID, 
        DqaT.Description,
        DqaT.CCode,
        DqaT.Scheme,
        DqaT.NumberOfCodes,
        DqaT.ConsistencyRatio,
        DqaT.CodeInvalid,
        DqaT.StrongInconsistency,
        DqaT.ClusterID,
        DqaT.ClusterSilouette,
        DqaT.AnomalyMajor,
        DqaT.AnomalyMinor,
        DqaT.AnomalyDegree
    };

VIEW DqaRequest
    AS SELECT FROM DqaRequestT
    {
        DqaRequestT.GUID,
        DqaRequestT.Request,
        DqaRequestT.Description,
        DqaRequestT.Scheme,
        DqaRequestT.RelevantAttributes
    };
};