namespace tc.views;
using tc.tables.User as UserT from '../tables/User';
using tc.tables.Rule as RuleT from '../tables/Rule';
using tc.tables.Attribute as Attribute from '../tables/Attribute';
using tc.tables.ConditionBusiness as ConditionBusinessT from '../tables/ConditionBusiness'; 

context BusinessRule {
    VIEW Rule 
    AS SELECT FROM RuleT
    {
        KEY RuleT.GUID as GUID,  
        RuleT.ID as ID,
        RuleT.ParentClassification as ParentClassification,
        RuleT.Rule as Rule,
        RuleT.Scheme as Scheme,
        RuleT.ClassificationCode as ClassificationCode,
        UPPER(RuleT.ID)          as CIID :String,
        UPPER(RuleT.ParentClassification) as CIParentClassification :String,
        UPPER(RuleT.Rule) as CIRule :String,
        UPPER(RuleT.Scheme) as CIScheme :String,
        UPPER(RuleT.ClassificationCode) as CIClassificationCode :String
    };

    VIEW AttributesRule 
    AS SELECT FROM RuleT
    JOIN Attribute
        ON RuleT.GUID = Attribute.ProductGUID
    {
        KEY RuleT.GUID              AS RuleGUID,
        KEY Attribute.Name          AS Name,
            Attribute.Value         AS Value,
            Attribute.Active        AS Active,
            Attribute.ML            AS ML
    };

    VIEW ConditionBusiness 
    AS SELECT FROM ConditionBusinessT
    {
        KEY ConditionBusinessT.GUID as GUID,  
        ConditionBusinessT.ID as ID,
        ConditionBusinessT.Field as Field,
        ConditionBusinessT.BusinessCondition as BusinessCondition,
        ConditionBusinessT.Value as Value,
        UPPER(ConditionBusinessT.ID) as CIID :String,
        UPPER(ConditionBusinessT.Field) as CIField :String, 
        UPPER(ConditionBusinessT.BusinessCondition) as CIBusinessCondition :String,
        UPPER(ConditionBusinessT.Value) as CIValue :String
    };
    
    VIEW AttributesCondition 
    AS SELECT FROM ConditionBusinessT
    JOIN Attribute
        ON ConditionBusinessT.GUID = Attribute.ProductGUID
    {
        KEY ConditionBusinessT.GUID              AS ConditionBusinessGUID,
        KEY Attribute.Name          AS Name,
            Attribute.Value         AS Value,
            Attribute.Active        AS Active,
            Attribute.ML            AS ML
    };

};