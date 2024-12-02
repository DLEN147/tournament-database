BEGIN
  FOR rec IN (SELECT username FROM all_users WHERE username = 'TMT') LOOP
    EXECUTE IMMEDIATE 'DROP USER TMT CASCADE';
  END LOOP;
END;
/

ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER TMT IDENTIFIED BY tmt;

GRANT CONNECT TO TMT;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE TRIGGER TO TMT;
GRANT UNLIMITED TABLESPACE TO TMT;
