show con_name;
alter session set container= orclpdb;
show con_name;
ALTER PLUGGABLE DATABASE orclpdb open;

CREATE USER dw_manager IDENTIFIED BY mng_pass;
GRANT CREATE SESSION dw_manager.TO dw_manager;
GRANT CREATE ANY TABLE TO dw_manager;
GRANT CREATE ANY INDEX TO dw_manager;
GRANT CREATE VIEW TO dw_manager;




GRANT CREATE TRIGGER TO dw_manager;
GRANT CREATE ANY SEQUENCE TO dw_manager;
GRANT SELECT ANY TABLE TO dw_manager;
GRANT INSERT ANY TABLE TO dw_manager;
GRANT DELETE ANY TABLE TO dw_manager;
GRANT UPDATE ANY TABLE TO dw_manager;
GRANT ALTER ANY TABLE TO dw_manager;
GRANT UNLIMITED TABLESPACE TO dw_manager;

--Pentru a vizualiza privilegiile adaugate putem folosi aceasta cerere asupra utlizatorului creat.
SELECT * 
FROM session_privs;

-- intro schema si datele furnizate pentru schema
--SCHEMA CU TABELE TREBUIE RULATE IN dw_manager
--script creare schema oltp.txt
--DATELE DIN TABELE TREBUIE INTRODUSE IN dw_manager
--script inserare date oltp.txt

-- urmatorul tip va fi de tip admin care va avea posibilitatea de UPDATE peste toate tabele din schema OLTP 
-- fara a avea posibilitatea de a sterge orice tip de inregistrare deoarece si inregistrarile neconforme pot reprezenta
-- un interes pentru manager.


CREATE USER dw_admin IDENTIFIED BY admin_pass;
GRANT CREATE SESSION dw_manager.TO dw_admin;

GRANT SELECT ANY TABLE TO dw_admin;
GRANT DELETE ANY TABLE TO dw_admin;
GRANT UPDATE ANY TABLE TO dw_admin;
GRANT ALTER ANY TABLE TO dw_admin;

--daca dorim sa oferim doar anumite privilegi mai restrictive asupra anumitor tabele putem folosi comanda urmatoare
--GRANT UPDATE ON dw_manager.dw_manager.rezervare TO dw_admin;
--sau daca dorim sa nu mai folosim anumite privilegii precum cel de mai putem folosi comanda
--REVOKE DELETE ON dw_manager.dw_manager.rezervare FROM dw_admin;

--pentru a accesa un tabel trebuie sa folosim dw_manager.nume_tabel deoarece altfel nu merge

-- iar ultimul tip de utilizator este cel cel de utilizator care are 
-- posibilitatea sa vizualizeze hotelurile si sa introduce date in rezervari.
-- acesta nu avea acces la baza de date.


--ca si SYS putem rula urmatoarea cerere pentru a vizualiza care sunt care sunt privilegiile oferite
SELECT substr(grantee,1,20) grantee, owner,substr(table_name,1,15) table_name, grantor, privilege
FROM DBA_TAB_PRIVS
WHERE grantee like 'DW_%';


