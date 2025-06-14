WITH reviewer_data AS (
    SELECT 
        prr.PSC_JOB_ID,
        MAX(CASE WHEN prr.REVIEWER_TYPE_ID = 1 THEN u.FULL_NAME END) AS POWER_GEN_ENGR,
        MAX(CASE WHEN prr.REVIEWER_TYPE_ID = 2 THEN u.FULL_NAME END) AS ASSIGNMENT_ENGR,
        MAX(CASE WHEN prr.REVIEWER_TYPE_ID = 3 THEN u.FULL_NAME END) AS POWER_ENGR,
        MAX(CASE WHEN prr.REVIEWER_TYPE_ID = 4 THEN u.FULL_NAME END) AS INFRA_ENGR,
        MAX(CASE WHEN prr.REVIEWER_TYPE_ID = 5 THEN u.FULL_NAME END) AS HVAC_ENGR,
        MAX(CASE WHEN prr.REVIEWER_TYPE_ID = 6 THEN u.FULL_NAME END) AS SS_REVIEWER
    FROM PSC_VETTING.PSC_REQUESTS_REVIEWERS prr
    INNER JOIN PC_COMMON.USER_INFO_V2 u ON prr.REVIEWER_ID = u.SAMACCOUNTNAME
    WHERE prr.REVIEWER_TYPE_ID IN (1, 2, 3, 4, 5, 6)
    GROUP BY prr.PSC_JOB_ID
)
SELECT 
    REQ.PSC_JOB_ID,
    REQ.REQUEST_TYPE_NAME,
    REQ.STATUS_NAME,
    REQ.STATUS_NAME AS STATUS_DESCRIPTION,
    TO_CHAR(REQ.CREATED_TIME, 'MM/DD/YYYY') AS CREATEDATE,
    REQ.UPLOAD_FILE_ID,
    U1.FULL_NAME AS REQUESTOR,
    U2.FULL_NAME AS PS_PLANNER,
    U3.FULL_NAME AS PS_MANAGER,
    U4.FULL_NAME AS CREATEDBY,
    U5.FULL_NAME AS CLOSEDBY,
    REQ.PROJECT_IDENTIFIER,
    REQ.VETTING_REQUEST_REQ,
    TO_CHAR(REQ.CLOSE_TIME, 'MM/DD/YYYY') AS CLOSEDDATE,
    REQ.POWER_WORK_COST AS POWER_WORK_COST,
    REQ.SPACE_WORK_COST AS SPACE_WORK_COST,
    U6.FULL_NAME AS FEC_MANAGER,
    REQ.HVAC_WORK_COST AS HVAC_WORK_COST,
    REQ.SITE_CODE,
    REQ.PROJECT_DESCRIPTION,
    REQ.POWER_PLANT_SUMMARY,
    REQ.PSC_WORK_REQUIRED,
    REQ.NEW_EQUIP_SUMMARY_DET,
    REQ.FINAL_CALC_SUMMARY,
    REQ.POWER_PLANT_CONCLUSION,
    DET.SCOPE_OF_WORK,
    REQ.MANAGER_NOTES,
    REQ.NEW_EQUIP_SUMMARY,
    TO_CHAR(REQ.PROP_POWER_READY_DATE, 'MM/DD/YYYY') AS PROP_POWER_READY_DATE,
    TO_CHAR(REQ.PROP_SPACE_READY_DATE, 'MM/DD/YYYY') AS PROP_SPACE_READY_DATE,
    TO_CHAR(REQ.PROP_HVAC_READY_DATE, 'MM/DD/YYYY') AS PROP_HVAC_READY_DATE,
    DET.PSC_COSTS_SUMMARY,
    DET.TOTAL_DC_EQUIP_48V_AMPS,
    DET.TOTAL_DC_EQUIP_FLOAT_AMPS,
    DET.ASSIGNED_PWR_PLANT,
    DET.PWR_PLANT_FLOAT_V,
    DET.PWR_PLANT_EVPC,
    DET.TOTAL_AC_EQUIP_WATTS,
    TO_CHAR(REQ.IMPLEMENTED_DATE, 'MM/DD/YYYY') AS IMPLEMENTED_DATE,
    DET.TOTAL_EQUIP_HEAT,
    DET.COST_MODELS_USED,
    REQ.SITECODE_VZB_6_CHAR,
    TO_CHAR(DET.TARGET_RESPONSE_DATE, 'MM/DD/YYYY') AS TARGETRESPONSEDATE,
    TO_CHAR(DET.POWER_NEED_DATE, 'MM/DD/YYYY') AS POWER_NEED_DATE,
    TO_CHAR(DET.SPACE_NEED_DATE, 'MM/DD/YYYY') AS SPACE_NEED_DATE,
    DET.SEP_PSC_PROJ_QTY,
    REQ.IMPACT_ANALYSIS,
    TO_CHAR(REQ.REQUESTED_DATE, 'MM/DD/YYYY') AS REQUESTED_DATE,
    REQ.COMPANY_NAME,
    REQ.PRIORITY_BAND_ID AS PRIORITY_BAND_NAME,
    DET.PWR_REQS_DESCRIPTION,
    DET.FINAL_FUNDING_APPROVAL,
    DET.FUNDING_APPROVAL_NOTES,
    DET.PHYS_REQS_DESCRIPTION,
    DET.SPACE_CURRENTLY_AVAILABLE,
    DET.COOLING_CAPACITY_AVAILABLE,
    DET.POWER_DISTRIBUTION_AVAILABLE,
    DET.FINAL_CONCLUSION_NOTES,
    RD.POWER_GEN_ENGR,
    RD.ASSIGNMENT_ENGR,
    RD.POWER_ENGR,
    RD.INFRA_ENGR,
    RD.HVAC_ENGR,
    RD.SS_REVIEWER,
    REQ.PSC_CCR_ID
FROM PSC_VETTING.PSC_REQUESTS_V4 REQ
INNER JOIN PSC_VETTING.PSC_REQUESTS_DETAILS DET 
    ON DET.PSC_JOB_ID = REQ.PSC_JOB_ID
LEFT JOIN PC_COMMON.USER_INFO_V2 U1 
    ON REQ.REQUESTOR_ID = U1.SAMACCOUNTNAME
LEFT JOIN PC_COMMON.USER_INFO_V2 U2 
    ON REQ.PS_PLANNER_ID = U2.SAMACCOUNTNAME
LEFT JOIN PC_COMMON.USER_INFO_V2 U3 
    ON REQ.PS_MANAGER_ID = U3.SAMACCOUNTNAME
LEFT JOIN PC_COMMON.USER_INFO_V2 U4 
    ON REQ.CREATED_BY = U4.SAMACCOUNTNAME
LEFT JOIN PC_COMMON.USER_INFO_V2 U5 
    ON REQ.CLOSED_BY = U5.SAMACCOUNTNAME
LEFT JOIN PC_COMMON.USER_INFO_V2 U6 
    ON REQ.FEC_MANAGER = U6.SAMACCOUNTNAME
LEFT JOIN reviewer_data RD 
    ON REQ.PSC_JOB_ID = RD.PSC_JOB_ID
WHERE REQ.IS_ACTIVE_JOB = 'Y'
    AND REQ.SENSITIVE_LOCATION NOT IN ('0', 'U', 'X', '2')
    AND RD.INFRA_ENGR LIKE '%APPIYA%'
ORDER BY REQ.PSC_JOB_ID DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;