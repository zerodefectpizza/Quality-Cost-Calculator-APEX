-- Generiert von Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   am/um:        2025-08-24 08:08:31 MESZ
--   Site:      Oracle Database 21c
--   Typ:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE T_CoQQCCName 
    ( 
     ID                        NUMBER (10)  NOT NULL , 
     Tenant_ID                 NUMBER (10) , 
     Version                   NUMBER (10) , 
     LanguageCode_ID           NUMBER (10)  NOT NULL , 
     QualityCostCalculation_ID NUMBER (10)  NOT NULL , 
     Title                     VARCHAR2 (512) , 
     Description               VARCHAR2 (4000) , 
     Notes                     VARCHAR2 (4000) , 
     IsNotAutomatedTranslated  CHAR (1) , 
     IsActive                  CHAR (1) , 
     RowVersion                NUMBER (10) , 
     CreatedOn                 TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     CreatedBy_ID              NUMBER (10)  NOT NULL , 
     ChangedOn                 TIMESTAMP WITH LOCAL TIME ZONE , 
     ChangedBy_ID              NUMBER (10) , 
     DeletedOn                 TIMESTAMP WITH LOCAL TIME ZONE , 
     DeletedBy_ID              NUMBER (10) , 
     IsDeleted                 CHAR (1) 
    ) 
;
CREATE INDEX T_CoQQualityCostCalcName_IDX ON T_CoQQCCName 
    ( 
     ID ASC , 
     Tenant_ID ASC , 
     LanguageCode_ID ASC , 
     QualityCostCalculation_ID ASC 
    ) 
;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_PK PRIMARY KEY ( ID ) ;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_LangCode FOREIGN KEY 
    ( 
     LanguageCode_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_T_QCC_FK FOREIGN KEY 
    ( 
     QualityCostCalculation_ID
    ) 
    REFERENCES T_CoQQCC 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_T_Tenant_FK FOREIGN KEY 
    ( 
     Tenant_ID
    ) 
    REFERENCES T_Tenant 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_T_User_FK FOREIGN KEY 
    ( 
     CreatedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_T_User_FKv2 FOREIGN KEY 
    ( 
     ChangedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

ALTER TABLE T_CoQQCCName 
    ADD CONSTRAINT T_CoQQCCName_T_User_FKv3 FOREIGN KEY 
    ( 
     DeletedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

CREATE SEQUENCE T_CoQQCCName_ID_SEQ 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER T_CoQQCCName_ID_TRG 
BEFORE INSERT ON T_CoQQCCName 
FOR EACH ROW 
WHEN (NEW.ID IS NULL) 
BEGIN 
    :NEW.ID := T_CoQQCCName_ID_SEQ.NEXTVAL; 
END;
/

-- T_CoQQCCName DDL Trigger Script
-- Oracle APEX Developer Template

CREATE OR REPLACE TRIGGER TRG_T_CoQQCCName_BIU
    BEFORE INSERT OR UPDATE ON T_CoQQCCName
    FOR EACH ROW
DECLARE
    v_user_id NUMBER;
    v_current_time TIMESTAMP WITH LOCAL TIME ZONE;
BEGIN
    -- Get current timestamp
    v_current_time := SYSTIMESTAMP;
    
    -- Get the user ID based on the APP_USER or database user
    BEGIN
        SELECT ID 
        INTO v_user_id
        FROM T_USER
        WHERE LOWER(USERID) = LOWER(NVL(wwv_flow.g_user, USER));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Handle case where user is not found in T_USER table
            v_user_id := NULL;
        WHEN TOO_MANY_ROWS THEN
            -- Handle case where multiple users found (should not happen with proper constraints)
            SELECT MIN(ID) 
            INTO v_user_id 
            FROM T_USER 
            WHERE LOWER(USERID) = LOWER(NVL(wwv_flow.g_user, USER));
    END;

    -- Handle INSERT operations
    IF INSERTING THEN
        -- Set CreatedOn and CreatedBy_ID
        :NEW.CreatedOn := v_current_time;
        :NEW.CreatedBy_ID := v_user_id;
        
        -- Initialize RowVersion
        :NEW.RowVersion := 1;
        
        -- Set default values if not provided (using Y/N for boolean fields)
        IF :NEW.IsActive IS NULL THEN
            :NEW.IsActive := 'Y';
        END IF;
        
        IF :NEW.IsDeleted IS NULL THEN
            :NEW.IsDeleted := 'N';
        END IF;
        
        IF :NEW.IsNotAutomatedTranslated IS NULL THEN
            :NEW.IsNotAutomatedTranslated := 'N';
        END IF;
    END IF;

    -- Handle UPDATE operations
    IF UPDATING THEN
        -- Increment RowVersion
        :NEW.RowVersion := NVL(:OLD.RowVersion, 0) + 1;
        
        -- Set ChangedOn and ChangedBy_ID
        :NEW.ChangedOn := v_current_time;
        :NEW.ChangedBy_ID := v_user_id;
        
        -- Preserve original creation audit fields
        :NEW.CreatedOn := :OLD.CreatedOn;
        :NEW.CreatedBy_ID := :OLD.CreatedBy_ID;
    END IF;

    -- Validate required fields
    IF :NEW.CreatedBy_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'CreatedBy_ID cannot be null. User not found in T_USER table for user: ' || NVL(wwv_flow.g_user, USER));
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE_APPLICATION_ERROR(-20999, 'Error in TRG_T_CoQQCCName_BIU: ' || SQLERRM);
END TRG_T_CoQQCCName_BIU;
/

COMMIT
;



-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             1
-- CREATE INDEX                             1
-- ALTER TABLE                              7
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
