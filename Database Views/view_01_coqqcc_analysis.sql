-- ================================================================
-- V_CoQQCCAnalysis.sql - Main Analysis View
-- ================================================================
-- Description: Core Quality Cost Analysis View with CoGQ/CoPQ calculations
-- Dependencies: T_CoQQCC
-- Usage: Main data source for APEX applications and reports
-- ================================================================

CREATE OR REPLACE VIEW V_CoQQCCAnalysis AS
SELECT 
    qcc.ID,
    qcc.Tenant_ID,
    qcc.Version,
    qcc.SessionID,
    qcc.Title,
    qcc.Revenue,
    qcc.QualityPercentage,
    qcc.PreventionPercentage,
    qcc.AppraisalPercentage,
    qcc.InternalFailurePercentage,
    qcc.ExternalFailurePercentage,
    
    -- Use calculated fields if available, otherwise compute them
    COALESCE(qcc.CalculatedTotalQualityCost, 
             (qcc.Revenue * qcc.QualityPercentage / 100)) as TotalQualityCost,
    
    -- Cost of Good Quality (CoGQ) Components
    COALESCE(qcc.CalculatedPreventionCost,
             (qcc.Revenue * qcc.QualityPercentage / 100 * qcc.PreventionPercentage / 100)) as PreventionCost,
    COALESCE(qcc.CalculatedAppraisalCost,
             (qcc.Revenue * qcc.QualityPercentage / 100 * qcc.AppraisalPercentage / 100)) as AppraisalCost,
    COALESCE(qcc.CalculatedCoGQ,
             (qcc.Revenue * qcc.QualityPercentage / 100 * (qcc.PreventionPercentage + qcc.AppraisalPercentage) / 100)) as CoGQTotal,
    
    -- Cost of Poor Quality (CoPQ) Components
    COALESCE(qcc.CalculatedInternalFailCost,
             (qcc.Revenue * qcc.QualityPercentage / 100 * qcc.InternalFailurePercentage / 100)) as InternalFailureCost,
    COALESCE(qcc.CalculatedExternalFailCost,
             (qcc.Revenue * qcc.QualityPercentage / 100 * qcc.ExternalFailurePercentage / 100)) as ExternalFailureCost,
    COALESCE(qcc.CalculatedCoPQ,
             (qcc.Revenue * qcc.QualityPercentage / 100 * (qcc.InternalFailurePercentage + qcc.ExternalFailurePercentage) / 100)) as CoPQTotal,
    
    -- Quality Ratios (use stored values if available)
    COALESCE(qcc.CoGQRatio, (qcc.PreventionPercentage + qcc.AppraisalPercentage)) as CoGQPercentage,
    COALESCE(qcc.CoPQRatio, (qcc.InternalFailurePercentage + qcc.ExternalFailurePercentage)) as CoPQPercentage,
    
    -- Quality Efficiency Index
    COALESCE(qcc.QualityEfficiencyIndex,
             CASE WHEN (qcc.InternalFailurePercentage + qcc.ExternalFailurePercentage) > 0 THEN
                 ROUND((qcc.PreventionPercentage + qcc.AppraisalPercentage) / 
                       (qcc.InternalFailurePercentage + qcc.ExternalFailurePercentage), 4)
             ELSE NULL END) as QualityEfficiencyIndex,
    
    -- Opportunity Costs (if enabled)
    CASE WHEN qcc.OpportunityEnabled = '1' THEN
        COALESCE(qcc.CalculatedOpportunityCost,
                 (qcc.Revenue * NVL(qcc.LostSalesPercentage, 0) / 100) +
                 (qcc.Revenue * NVL(qcc.CustomerChurnPercentage, 0) / 100) +
                 (qcc.Revenue * NVL(qcc.MarketShareLossPercentage, 0) / 100) +
                 (qcc.Revenue * NVL(qcc.ProductivityLossPercentage, 0) / 100))
    ELSE 0 END as OpportunityCostTotal,
    
    -- Extended CoPQ (including opportunity costs)
    COALESCE(qcc.CalculatedCoPQ,
             (qcc.Revenue * qcc.QualityPercentage / 100 * (qcc.InternalFailurePercentage + qcc.ExternalFailurePercentage) / 100)) +
    CASE WHEN qcc.OpportunityEnabled = '1' THEN
        COALESCE(qcc.CalculatedOpportunityCost,
                 (qcc.Revenue * NVL(qcc.LostSalesPercentage, 0) / 100) +
                 (qcc.Revenue * NVL(qcc.CustomerChurnPercentage, 0) / 100) +
                 (qcc.Revenue * NVL(qcc.MarketShareLossPercentage, 0) / 100) +
                 (qcc.Revenue * NVL(qcc.ProductivityLossPercentage, 0) / 100))
    ELSE 0 END as ExtendedCoPQTotal,
    
    -- Additional fields from table
    qcc.CurrencyCode_ID,
    qcc.DisplayUnit_ID,
    qcc.OpportunityEnabled,
    qcc.AnalysisDate,
    qcc.BenchmarkCategory,
    qcc.QualityMaturityLevel,
    qcc.Notes,
    qcc.IsTemplate,
    qcc.IsPublic,
    qcc.IsActive,
    qcc.CreatedOn,
    qcc.CreatedBy_ID,
    qcc.ChangedOn,
    qcc.ChangedBy_ID
    
FROM T_CoQQCC qcc
WHERE qcc.IsDeleted = '0';

-- Grant permissions for APEX
GRANT SELECT ON V_CoQQCCAnalysis TO APEX_PUBLIC_USER;

-- Add comments for documentation
COMMENT ON VIEW V_CoQQCCAnalysis IS 'Main analysis view for Quality Cost Calculator providing all CoGQ and CoPQ calculations';
COMMENT ON COLUMN V_CoQQCCAnalysis.CoGQTotal IS 'Cost of Good Quality: Prevention + Appraisal costs';
COMMENT ON COLUMN V_CoQQCCAnalysis.CoPQTotal IS 'Cost of Poor Quality: Internal + External failure costs';
COMMENT ON COLUMN V_CoQQCCAnalysis.QualityEfficiencyIndex IS 'Ratio of CoGQ to CoPQ - higher is better';