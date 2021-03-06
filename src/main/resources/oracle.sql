CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN_SYNC (
  ID INTEGER,
  TOKEN_ID VARCHAR (255),
  ACCESS_TOKEN VARCHAR2 (255),
  REFRESH_TOKEN VARCHAR2 (255),
  CONSUMER_KEY_ID INTEGER,
  AUTHZ_USER VARCHAR2 (100),
  TENANT_ID INTEGER,
  USER_DOMAIN VARCHAR2 (50),
  USER_TYPE VARCHAR (25),
  GRANT_TYPE VARCHAR (50),
  TIME_CREATED TIMESTAMP,
  REFRESH_TOKEN_TIME_CREATED TIMESTAMP,
  VALIDITY_PERIOD NUMBER(19),
  REFRESH_TOKEN_VALIDITY_PERIOD NUMBER(19),
  TOKEN_SCOPE_HASH VARCHAR2 (32),
  TOKEN_STATE VARCHAR2 (25) DEFAULT 'ACTIVE',
  TOKEN_STATE_ID VARCHAR (128) DEFAULT 'NONE',
  SUBJECT_IDENTIFIER VARCHAR(255),
  PRIMARY KEY (ID))
;
/


CREATE TABLE IDN_OAUTH2_TOKEN_SCOPE_SYNC (
    ID INTEGER,
    TOKEN_ID VARCHAR2 (255),
    TOKEN_SCOPE VARCHAR2 (60),
    TENANT_ID INTEGER DEFAULT -1,
    PRIMARY KEY (ID));
/

CREATE TABLE IDN_OAUTH2_AUTH_CODE_SYNC (
  ID INTEGER,
  CODE_ID VARCHAR (255),
  AUTHORIZATION_CODE VARCHAR2 (512),
  CONSUMER_KEY_ID INTEGER,
  CALLBACK_URL VARCHAR2 (1024),
  SCOPE VARCHAR2(2048),
  AUTHZ_USER VARCHAR2 (100),
  TENANT_ID INTEGER,
  USER_DOMAIN VARCHAR2 (50),
  TIME_CREATED TIMESTAMP,
  VALIDITY_PERIOD NUMBER(19),
  STATE VARCHAR (25) DEFAULT 'ACTIVE',
  TOKEN_ID VARCHAR(255),
  SUBJECT_IDENTIFIER VARCHAR(255),
  PKCE_CODE_CHALLENGE VARCHAR (255),
  PKCE_CODE_CHALLENGE_METHOD VARCHAR(128),
  PRIMARY KEY (ID));
/

CREATE SEQUENCE token_seq START WITH 1;
/

CREATE SEQUENCE token_scope_seq START WITH 1;
/
CREATE SEQUENCE auth_code_seq START WITH 1;
/

CREATE OR REPLACE TRIGGER token_sync_trig
    BEFORE INSERT ON IDN_OAUTH2_ACCESS_TOKEN_SYNC
        FOR EACH ROW
    BEGIN
      SELECT token_seq.NEXTVAL
      INTO   :new.id
      FROM   dual;
END;
/

CREATE OR REPLACE TRIGGER token_scope_sync_trig
    BEFORE INSERT ON IDN_OAUTH2_TOKEN_SCOPE_SYNC
        FOR EACH ROW
    BEGIN
      SELECT token_scope_seq.NEXTVAL
      INTO   :new.id
      FROM   dual;
END;
/

CREATE OR REPLACE TRIGGER auth_code_sync_trig
    BEFORE INSERT ON IDN_OAUTH2_AUTH_CODE_SYNC
        FOR EACH ROW
    BEGIN
      SELECT auth_code_seq.NEXTVAL
      INTO   :new.id
      FROM   dual;
END;
/

create or replace trigger table_token_insert after update OR insert on IDN_OAUTH2_ACCESS_TOKEN for each row
begin
  insert into IDN_OAUTH2_ACCESS_TOKEN_SYNC
    (TOKEN_ID,ACCESS_TOKEN,REFRESH_TOKEN,CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,GRANT_TYPE,TIME_CREATED,
    REFRESH_TOKEN_TIME_CREATED,VALIDITY_PERIOD,REFRESH_TOKEN_VALIDITY_PERIOD,TOKEN_SCOPE_HASH,TOKEN_STATE,TOKEN_STATE_ID,SUBJECT_IDENTIFIER)
  values
    (:new.TOKEN_ID,:new.ACCESS_TOKEN,:new.REFRESH_TOKEN,:new.CONSUMER_KEY_ID,:new.AUTHZ_USER,:new.TENANT_ID,:new.USER_DOMAIN,:new.USER_TYPE,:new.GRANT_TYPE,:new.TIME_CREATED,
    :new.REFRESH_TOKEN_TIME_CREATED,:new.VALIDITY_PERIOD,:new.REFRESH_TOKEN_VALIDITY_PERIOD,:new.TOKEN_SCOPE_HASH,:new.TOKEN_STATE,:new.TOKEN_STATE_ID,:new.SUBJECT_IDENTIFIER);
end;
/

create or replace trigger table_token_scope_insert after update OR insert on IDN_OAUTH2_ACCESS_TOKEN_SCOPE for each row
begin
  insert into IDN_OAUTH2_TOKEN_SCOPE_SYNC
    (TOKEN_ID,TOKEN_SCOPE,TENANT_ID)
  values
    (:new.TOKEN_ID,:new.TOKEN_SCOPE,:new.TENANT_ID);
end;
/

create or replace trigger table_auth_code_insert after update OR insert on IDN_OAUTH2_AUTHORIZATION_CODE for each row
begin
  insert into IDN_OAUTH2_AUTH_CODE_SYNC
    (CODE_ID,AUTHORIZATION_CODE,CONSUMER_KEY_ID,CALLBACK_URL,SCOPE,AUTHZ_USER,TENANT_ID,USER_DOMAIN,TIME_CREATED,VALIDITY_PERIOD,STATE,
    TOKEN_ID,SUBJECT_IDENTIFIER,PKCE_CODE_CHALLENGE,PKCE_CODE_CHALLENGE_METHOD)
  values
    (:new.CODE_ID,:new.AUTHORIZATION_CODE,:new.CONSUMER_KEY_ID,:new.CALLBACK_URL,:new.SCOPE,:new.AUTHZ_USER,:new.TENANT_ID,:new.USER_DOMAIN,
    :new.TIME_CREATED,:new.VALIDITY_PERIOD,:new.STATE,:new.TOKEN_ID,:new.SUBJECT_IDENTIFIER,:new.PKCE_CODE_CHALLENGE,:new.PKCE_CODE_CHALLENGE_METHOD);
end;
/
