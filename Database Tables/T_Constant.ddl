-- Generiert von Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   am/um:        2025-08-24 08:16:55 MESZ
--   Site:      Oracle Database 21c
--   Typ:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE T_Constant 
    ( 
     ID                      NUMBER (10)  NOT NULL , 
     ConstantCategory_ID     NUMBER (10)  NOT NULL , 
     Code                    VARCHAR2 (128)  NOT NULL , 
     Value                   VARCHAR2 (64)  NOT NULL , 
     Name                    VARCHAR2 (128) , 
     Description             VARCHAR2 (1024) , 
     IsActive                NUMBER , 
     SortingOrder            NUMBER (8) , 
     DataExchangeSimpleType  VARCHAR2 (128) , 
     DataExchangeNameComplex VARCHAR2 (128) , 
     DataExchangeMapping     VARCHAR2 (128) , 
     LogoBlob                BLOB , 
     ReportingReference      VARCHAR2 (128) , 
     FormLayout              VARCHAR2 (1024) , 
     ExtendedAttribute       CLOB , 
     Parent_ID               NUMBER (10) , 
     IsOfficialExchangeCode  NUMBER , 
     Image_Blob              BLOB , 
     Image_Name              VARCHAR2 (128) , 
     Image_MimeType_ID       VARCHAR2 (64) , 
     Image_CharSet_ID        VARCHAR2 (32) , 
     Image_LastUpdated       TIMESTAMP WITH LOCAL TIME ZONE , 
     NLS_Language            VARCHAR2 (64) , 
     NLS_Territory           VARCHAR2 (64) , 
     CostRating              NUMBER (3) , 
     ReputationRating        NUMBER (3) , 
     RowVersionNumber        NUMBER (10) , 
     CreatedOn               TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     CreatedBy_ID            NUMBER (10)  NOT NULL , 
     ChangedOn               TIMESTAMP WITH LOCAL TIME ZONE , 
     ChangedBy_ID            NUMBER (10) , 
     DeletedOn               TIMESTAMP WITH LOCAL TIME ZONE , 
     DeletedBy_ID            NUMBER (10) , 
     IsDeleted               NUMBER 
    ) 
;
CREATE INDEX T_Constant__IDX ON T_Constant 
    ( 
     ID ASC , 
     Code ASC , 
     Name ASC 
    ) 
;

ALTER TABLE T_Constant 
    ADD CONSTRAINT T_Constant_PK PRIMARY KEY ( ID ) ;

ALTER TABLE T_Constant 
    ADD CONSTRAINT T_Constant_ConstantCat_FK FOREIGN KEY 
    ( 
     ConstantCategory_ID
    ) 
    REFERENCES T_ConstantCategory 
    ( 
     ID
    ) 
;

ALTER TABLE T_Constant 
    ADD CONSTRAINT T_Constant_T_Constant_FK FOREIGN KEY 
    ( 
     Parent_ID
    ) 
    REFERENCES T_Constant 
    ( 
     ID
    ) 
;

ALTER TABLE T_Constant 
    ADD CONSTRAINT T_Constant_T_Media_FKv1 FOREIGN KEY 
    ( 
     CreatedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

ALTER TABLE T_Constant 
    ADD CONSTRAINT T_Constant_T_User_FKv2v1 FOREIGN KEY 
    ( 
     ChangedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

ALTER TABLE T_Constant 
    ADD CONSTRAINT T_Constant_T_User_FKv3 FOREIGN KEY 
    ( 
     DeletedBy_ID
    ) 
    REFERENCES T_User 
    ( 
     ID
    ) 
;

CREATE OR REPLACE TRIGGER T_CONSTANT_BIU_TRG
BEFORE INSERT OR UPDATE ON T_CONSTANT
FOR EACH ROW
DECLARE
    v_user_id NUMBER;
    v_blob_changed BOOLEAN := FALSE;
BEGIN
    -- Get the user ID based on the APP_USER
    SELECT ID INTO v_user_id
    FROM T_USER
    WHERE LOWER(USERID) = LOWER(NVL(wwv_flow.g_user, USER));

    IF INSERTING THEN
        :NEW.CREATEDON := CURRENT_TIMESTAMP;
        :NEW.CREATEDBY_ID := v_user_id;
        :NEW.ROWVERSIONNUMBER := 1;
        :NEW.ISDELETED := 'N'; -- Assuming 'N' for not deleted
    ELSIF UPDATING THEN
        :NEW.ROWVERSIONNUMBER := NVL(:OLD.ROWVERSIONNUMBER, 1) + 1;
    END IF;

    IF INSERTING OR UPDATING THEN
        :NEW.CHANGEDON := CURRENT_TIMESTAMP;
        :NEW.CHANGEDBY_ID := v_user_id;
    END IF;

    -- Ensure required fields are not null
    IF :NEW.CONSTANTCATEGORY_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'CONSTANTCATEGORY_ID cannot be null');
    END IF;

    IF :NEW.CODE IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'CODE cannot be null');
    END IF;

    IF :NEW.VALUE IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'VALUE cannot be null');
    END IF;

    -- Ensure ISACTIVE is either 'Y' or 'N' if set
    IF :NEW.ISACTIVE IS NOT NULL AND :NEW.ISACTIVE NOT IN ('Y', 'N') THEN
        RAISE_APPLICATION_ERROR(-20004, 'ISACTIVE must be either ''Y'' or ''N''');
    END IF;

    -- Ensure ISOFFICIALEXCHANGECODE is either 'Y' or 'N' if set
    IF :NEW.ISOFFICIALEXCHANGECODE IS NOT NULL AND :NEW.ISOFFICIALEXCHANGECODE NOT IN ('Y', 'N') THEN
        RAISE_APPLICATION_ERROR(-20005, 'ISOFFICIALEXCHANGECODE must be either ''Y'' or ''N''');
    END IF;

    -- Check if IMAGE_BLOB has changed
    IF UPDATING THEN
        IF (:OLD.IMAGE_BLOB IS NULL AND :NEW.IMAGE_BLOB IS NOT NULL) OR
           (:OLD.IMAGE_BLOB IS NOT NULL AND :NEW.IMAGE_BLOB IS NULL) OR
           (DBMS_LOB.COMPARE(:OLD.IMAGE_BLOB, :NEW.IMAGE_BLOB) != 0) THEN
            v_blob_changed := TRUE;
        END IF;
    END IF;

    -- Set IMAGE_LASTUPDATED if image-related fields are updated
    IF UPDATING AND (v_blob_changed OR
                     :NEW.IMAGE_NAME != :OLD.IMAGE_NAME OR 
                     :NEW.IMAGE_MIMETYPE_ID != :OLD.IMAGE_MIMETYPE_ID OR 
                     :NEW.IMAGE_CHARSET_ID != :OLD.IMAGE_CHARSET_ID) THEN
        :NEW.IMAGE_LASTUPDATED := CURRENT_TIMESTAMP;
    END IF;

    -- Validate ratings are between 1 and 5 if set
    IF :NEW.COSTRATING IS NOT NULL AND (:NEW.COSTRATING < 1 OR :NEW.COSTRATING > 5) THEN
        RAISE_APPLICATION_ERROR(-20006, 'COSTRATING must be between 1 and 5');
    END IF;

    IF :NEW.REPUTATIONRATING IS NOT NULL AND (:NEW.REPUTATIONRATING < 1 OR :NEW.REPUTATIONRATING > 5) THEN
        RAISE_APPLICATION_ERROR(-20007, 'REPUTATIONRATING must be between 1 and 5');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20008, 'User ' || NVL(wwv_flow.g_user, USER) || ' not found in T_USER');
    WHEN OTHERS THEN
        -- Log the error and re-raise
        DBMS_OUTPUT.PUT_LINE('Error in T_CONSTANT_BIU_TRG: ' || SQLERRM);
        RAISE;
END;
/



-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             1
-- CREATE INDEX                             1
-- ALTER TABLE                              6
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
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
-- CREATE SEQUENCE                          0
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
