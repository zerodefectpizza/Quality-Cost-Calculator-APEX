-- Generiert von Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   am/um:        2025-08-24 10:02:48 MESZ
--   Site:      Oracle Database 21c
--   Typ:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE T_CoQSession 
    ( 
     ID           NUMBER (10)  NOT NULL , 
     Tenant_ID    NUMBER (10) , 
     Version      NUMBER (10) , 
     SessionID    VARCHAR2 (128)  NOT NULL , 
     UserAgent    VARCHAR2 (512) , 
     IPAddress    VARCHAR2 (45) , 
     LanguageCode VARCHAR2 (5) , 
     CurrencyCode VARCHAR2 (5) , 
     DisplayUnit  VARCHAR2 (10) DEFAULT 'MILLION' , 
     LastActivity TIMESTAMP WITH LOCAL TIME ZONE , 
     ExpiresOn    TIMESTAMP WITH LOCAL TIME ZONE , 
     IsActive     CHAR (1) , 
     CreatedOn    TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     CreatedBy_ID NUMBER (10) , 
     ChangedOn    TIMESTAMP WITH LOCAL TIME ZONE , 
     ChangedBy_ID NUMBER (10) , 
     DeletedOn    TIMESTAMP WITH LOCAL TIME ZONE , 
     DeletedBy_ID NUMBER (10) , 
     IsDeleted    CHAR (1) 
    ) 
;
CREATE UNIQUE INDEX T_CoQSession_SessionID_IDX ON T_CoQSession 
    ( 
     SessionID ASC 
    ) 
;

ALTER TABLE T_CoQSession 
    ADD CONSTRAINT T_CoQSession_PK PRIMARY KEY ( ID ) ;

ALTER TABLE T_CoQSession 
    ADD CONSTRAINT T_CoQSession_T_Tenant_FK FOREIGN KEY 
    ( 
     Tenant_ID
    ) 
    REFERENCES T_Tenant 
    ( 
     ID
    ) 
;

CREATE SEQUENCE T_CoQSession_ID_SEQ 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER T_CoQSession_ID_TRG 
BEFORE INSERT ON T_CoQSession 
FOR EACH ROW 
WHEN (NEW.ID IS NULL) 
BEGIN 
    :NEW.ID := T_CoQSession_ID_SEQ.NEXTVAL; 
END;
/

-- T_CoQSession DDL Trigger Script
-- Oracle APEX Developer Template

CREATE OR REPLACE TRIGGER TRG_T_CoQSession_BIU
    BEFORE INSERT OR UPDATE ON T_CoQSession
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
        -- Set CreatedOn and CreatedBy_ID (Note: CreatedBy_ID is nullable in this table)
        :NEW.CreatedOn := v_current_time;
        :NEW.CreatedBy_ID := v_user_id;
        
        -- Set default values if not provided (using Y/N for boolean fields)
        IF :NEW.IsActive IS NULL THEN
            :NEW.IsActive := 'Y';
        END IF;
        
        IF :NEW.IsDeleted IS NULL THEN
            :NEW.IsDeleted := 'N';
        END IF;
        
        IF :NEW.LanguageCode IS NULL THEN
            :NEW.LanguageCode := 'EN';
        END IF;
        
        IF :NEW.CurrencyCode IS NULL THEN
            :NEW.CurrencyCode := 'EUR';
        END IF;
        
        IF :NEW.DisplayUnit IS NULL THEN
            :NEW.DisplayUnit := 'MILLION';
        END IF;
        
        -- Set LastActivity and ExpiresOn if not provided
        IF :NEW.LastActivity IS NULL THEN
            :NEW.LastActivity := v_current_time;
        END IF;
        
        IF :NEW.ExpiresOn IS NULL THEN
            -- Set expiration to 24 hours from now by default
            :NEW.ExpiresOn := v_current_time + INTERVAL '1' DAY;
        END IF;
    END IF;

    -- Handle UPDATE operations
    IF UPDATING THEN
        -- Set ChangedOn and ChangedBy_ID
        :NEW.ChangedOn := v_current_time;
        :NEW.ChangedBy_ID := v_user_id;
        
        -- Update LastActivity on any update
        :NEW.LastActivity := v_current_time;
        
        -- Preserve original creation audit fields
        :NEW.CreatedOn := :OLD.CreatedOn;
        :NEW.CreatedBy_ID := :OLD.CreatedBy_ID;
    END IF;

    -- Note: No validation for CreatedBy_ID since it's nullable for session records

EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE_APPLICATION_ERROR(-20999, 'Error in TRG_T_CoQSession_BIU: ' || SQLERRM);
END TRG_T_CoQSession_BIU;
/



-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             1
-- CREATE INDEX                             1
-- ALTER TABLE                              2
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
