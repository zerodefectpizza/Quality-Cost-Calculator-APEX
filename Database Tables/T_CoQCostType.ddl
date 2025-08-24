-- Generiert von Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   am/um:        2025-08-24 16:44:35 MESZ
--   Site:      Oracle Database 21c
--   Typ:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE T_CoQCostType 
    ( 
     ID                       NUMBER (10)  NOT NULL , 
     Tenant_ID                NUMBER (10) , 
     Version                  NUMBER (10) , 
     "MainCategoryCode_ID "   NUMBER (10)  NOT NULL , 
     CostCategoryTypeCode_ID  NUMBER (10)  NOT NULL , 
     SubCategory              VARCHAR2 (255) , 
     Parent_ID                NUMBER (10) , 
     DefaultPercentage        NUMBER (5,2) , 
     BenchmarkLow             NUMBER (5,2) , 
     BenchmarkHigh            NUMBER (5,2) , 
     CalculationMethodCode_ID NUMBER (10) , 
     FormularExpression       VARCHAR2 (1024) , 
     IndustryApplicable       VARCHAR2 (1024) , 
     QualityStandardCode_ID   NUMBER (10) , 
     IsMandatory              CHAR (1) , 
     IsSystemGenerated        CHAR (1) , 
     IsApprovalRequired       CHAR (1) , 
     MinimumThreshold         NUMBER (5,2) , 
     MaximumThreshold         NUMBER (5,2) , 
     ReportingGroup           VARCHAR2 (128) , 
     IsKPIRelevant            CHAR (1) , 
     IsBenchmarkRelevant      CHAR (1) , 
     ROIImpactCode_ID         NUMBER (10) , 
     IsTemplate               CHAR (1) , 
     IsPublic                 CHAR (1) , 
     SortingOrder             NUMBER (4) , 
     Description              VARCHAR2 (4000) , 
     IndustryCode_ID          NUMBER (10) , 
     IsActive                 CHAR (1) , 
     CreatedOn                TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     CreatedBy_ID             NUMBER (10)  NOT NULL , 
     ChangedOn                TIMESTAMP WITH LOCAL TIME ZONE , 
     ChangedBy_ID             NUMBER (10) , 
     DeletedOn                TIMESTAMP WITH LOCAL TIME ZONE , 
     DeletedBy_ID             NUMBER (10) , 
     IsDeleted                CHAR (1) 
    ) 
;
CREATE INDEX T_CoQCostType__IDX ON T_CoQCostType 
    ( 
     Tenant_ID ASC , 
     Version ASC , 
     "MainCategoryCode_ID " ASC , 
     CostCategoryTypeCode_ID ASC 
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCostType_PK PRIMARY KEY ( ID ) ;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_MainCatCode FOREIGN KEY 
    ( 
     "MainCategoryCode_ID "
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_QStandCode_FK FOREIGN KEY 
    ( 
     QualityStandardCode_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_ROIImpactCode FOREIGN KEY 
    ( 
     ROIImpactCode_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_CalcMethodCode FOREIGN KEY 
    ( 
     CalculationMethodCode_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_CoQCType_FK FOREIGN KEY 
    ( 
     Parent_ID
    ) 
    REFERENCES T_CoQCostType 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_CostCatCode FOREIGN KEY 
    ( 
     CostCategoryTypeCode_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_IndustryCode FOREIGN KEY 
    ( 
     IndustryCode_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_Tenant_FK FOREIGN KEY 
    ( 
     Tenant_ID
    ) 
    REFERENCES T_Tenant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_User_FK FOREIGN KEY 
    ( 
     CreatedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_User_FKv2 FOREIGN KEY 
    ( 
     ChangedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQCostType 
    ADD CONSTRAINT T_CoQCType_T_User_FKv3 FOREIGN KEY 
    ( 
     DeletedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

CREATE SEQUENCE T_CoQCostType_ID_SEQ 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER T_CoQCostType_ID_TRG 
BEFORE INSERT ON T_CoQCostType 
FOR EACH ROW 
WHEN (NEW.ID IS NULL) 
BEGIN 
    :NEW.ID := T_CoQCostType_ID_SEQ.NEXTVAL; 
END;
/

REATE OR REPLACE TRIGGER T_COQCOSTTYPE_BIU_TRG
BEFORE INSERT OR UPDATE ON T_COQCOSTTYPE
FOR EACH ROW
DECLARE
    v_user_id NUMBER;
BEGIN
    -- Get the user ID based on the APP_USER or database user
    SELECT ID INTO v_user_id
    FROM T_USER
    WHERE LOWER(USERID) = LOWER(NVL(wwv_flow.g_user, USER));

    -- Always store CODE as upper case
    :NEW.CODE := UPPER(:NEW.CODE);

    IF INSERTING THEN
        -- Set created timestamp and user
        :NEW.CREATEDON := CURRENT_TIMESTAMP;
        :NEW.CREATEDBY_ID := v_user_id;
        
        -- Initialize ISDELETED to 'N'
        :NEW.ISDELETED := 'N';
        
        -- Set default for ISACTIVE if not provided
        IF :NEW.ISACTIVE IS NULL THEN
            :NEW.ISACTIVE := 'Y';
        END IF;

        -- Set default for boolean fields if not provided
        IF :NEW.ISMANDATORY IS NULL THEN
            :NEW.ISMANDATORY := 'N';
        END IF;

        IF :NEW.ISSYSTEMGENERATED IS NULL THEN
            :NEW.ISSYSTEMGENERATED := 'N';
        END IF;

        IF :NEW.REQUIRESAPPROVAL IS NULL THEN
            :NEW.REQUIRESAPPROVAL := 'N';
        END IF;

        IF :NEW.KPIRELEVANT IS NULL THEN
            :NEW.KPIRELEVANT := 'Y';
        END IF;

        IF :NEW.BENCHMARKRELEVANT IS NULL THEN
            :NEW.BENCHMARKRELEVANT := 'Y';
        END IF;

        IF :NEW.ISTEMPLATE IS NULL THEN
            :NEW.ISTEMPLATE := 'N';
        END IF;

        IF :NEW.ISPUBLIC IS NULL THEN
            :NEW.ISPUBLIC := 'Y';
        END IF;

        -- Set Level_Number based on Parent
        IF :NEW.PARENT_ID IS NOT NULL THEN
            SELECT NVL(MAX(Level_Number), 0) + 1
            INTO :NEW.Level_Number
            FROM T_CoQCostType 
            WHERE ID = :NEW.PARENT_ID;
        ELSE
            :NEW.Level_Number := 1;
        END IF;

        -- Initialize ROWVERSION to 1
        :NEW.ROWVERSION := 1;
    ELSIF UPDATING THEN
        -- Increment ROWVERSION
        :NEW.ROWVERSION := NVL(:OLD.ROWVERSION, 0) + 1;
    END IF;

    IF INSERTING OR UPDATING THEN
        -- Set changed timestamp and user
        :NEW.CHANGEDON := CURRENT_TIMESTAMP;
        :NEW.CHANGEDBY_ID := v_user_id;
    END IF;

    -- Ensure required fields are not null
    IF :NEW.CODE IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'CODE cannot be null');
    END IF;

    IF :NEW.MAINCATEGORYCODE_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'MAINCATEGORYCODE_ID cannot be null');
    END IF;

    IF :NEW.COSTCATEGORYTYPECODE_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'COSTCATEGORYTYPECODE_ID cannot be null');
    END IF;

    -- Validate field lengths
    IF LENGTH(:NEW.CODE) > 64 THEN
        RAISE_APPLICATION_ERROR(-20004, 'CODE must not exceed 64 characters');
    END IF;

    IF :NEW.NAME IS NOT NULL AND LENGTH(:NEW.NAME) > 255 THEN
        RAISE_APPLICATION_ERROR(-20005, 'NAME must not exceed 255 characters');
    END IF;

    IF :NEW.DESCRIPTION IS NOT NULL AND LENGTH(:NEW.DESCRIPTION) > 4000 THEN
        RAISE_APPLICATION_ERROR(-20006, 'DESCRIPTION must not exceed 4000 characters');
    END IF;

    -- Validate percentage ranges
    IF :NEW.DEFAULTPERCENTAGE IS NOT NULL AND (:NEW.DEFAULTPERCENTAGE < 0 OR :NEW.DEFAULTPERCENTAGE > 100) THEN
        RAISE_APPLICATION_ERROR(-20007, 'DEFAULTPERCENTAGE must be between 0 and 100');
    END IF;

    -- Ensure all boolean fields are either 'Y' or 'N' if set
    FOR i IN 1..8 LOOP
        DECLARE
            v_field VARCHAR2(30);
            v_value CHAR(1);
        BEGIN
            CASE i
                WHEN 1 THEN v_field := 'ISMANDATORY'; v_value := :NEW.ISMANDATORY;
                WHEN 2 THEN v_field := 'ISSYSTEMGENERATED'; v_value := :NEW.ISSYSTEMGENERATED;
                WHEN 3 THEN v_field := 'REQUIRESAPPROVAL'; v_value := :NEW.REQUIRESAPPROVAL;
                WHEN 4 THEN v_field := 'KPIRELEVANT'; v_value := :NEW.KPIRELEVANT;
                WHEN 5 THEN v_field := 'BENCHMARKRELEVANT'; v_value := :NEW.BENCHMARKRELEVANT;
                WHEN 6 THEN v_field := 'ISTEMPLATE'; v_value := :NEW.ISTEMPLATE;
                WHEN 7 THEN v_field := 'ISPUBLIC'; v_value := :NEW.ISPUBLIC;
                WHEN 8 THEN v_field := 'ISACTIVE'; v_value := :NEW.ISACTIVE;
            END CASE;

            IF v_value IS NOT NULL AND v_value NOT IN ('Y', 'N') THEN
                RAISE_APPLICATION_ERROR(-20010 - i, v_field || ' must be either ''Y'' or ''N''');
            END IF;
        END;
    END LOOP;

    -- If ISDELETED is set to 'Y', set DELETEDON timestamp and user
    IF :NEW.ISDELETED = 'Y' AND (:OLD.ISDELETED IS NULL OR :OLD.ISDELETED = 'N') THEN
        :NEW.DELETEDON := CURRENT_TIMESTAMP;
        :NEW.DELETEDBY_ID := v_user_id;
    END IF;

    -- If ISDELETED is set back to 'N', clear DELETEDON timestamp and user
    IF :NEW.ISDELETED = 'N' AND :OLD.ISDELETED = 'Y' THEN
        :NEW.DELETEDON := NULL;
        :NEW.DELETEDBY_ID := NULL;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20020, 'User ' || NVL(wwv_flow.g_user, USER) || ' not found in T_USER');
    WHEN OTHERS THEN
        -- Log the error and re-raise
        DBMS_OUTPUT.PUT_LINE('Error in T_COQCOSTTYPE_BIU_TRG: ' || SQLERRM);
        RAISE;
END;
/



-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             1
-- CREATE INDEX                             1
-- ALTER TABLE                             12
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           1
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          1
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
