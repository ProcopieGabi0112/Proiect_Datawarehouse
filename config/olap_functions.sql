CREATE OR REPLACE FUNCTION calculeaza_varsta(data_nasterii DATE)
RETURN NUMBER IS
BEGIN
    RETURN FLOOR(MONTHS_BETWEEN(SYSDATE,data_nasterii)/12);
END calculeaza_varsta;




CREATE OR REPLACE FUNCTION gaseste_id_perioada_OLAP(p_zi_din_an_inceput perioada_rezervare_OLAP.zi_din_an_inceput%TYPE, p_an_inceput perioada_rezervare_OLAP.an_inceput%TYPE,
                                                       p_zi_din_an_sfarsit perioada_rezervare_OLAP.zi_din_an_sfarsit%TYPE, p_an_sfarsit perioada_rezervare_OLAP.an_sfarsit%TYPE)
    RETURN perioada_rezervare_OLAP.id_perioada%TYPE IS
    v_id_gasit perioada_rezervare_OLAP.id_perioada%TYPE;
BEGIN
    SELECT id_perioada
    INTO v_id_gasit
    FROM perioada_rezervare_OLAP
    WHERE zi_din_an_inceput=p_zi_din_an_inceput
    AND an_inceput=p_an_inceput
    AND zi_din_an_sfarsit=p_zi_din_an_sfarsit
    AND an_sfarsit= p_an_sfarsit;
    RETURN v_id_gasit;
END gaseste_id_perioada_OLAP;


CREATE OR REPLACE FUNCTION gaseste_id_moment_efectuare_OLAP(p_zi_din_an moment_efectuare_rezervare_OLAP.zi_din_an%TYPE, p_an moment_efectuare_rezervare_OLAP.an%TYPE)
    RETURN moment_efectuare_rezervare_OLAP.id_moment_efectuare%TYPE IS
    v_id_gasit moment_efectuare_rezervare_OLAP.id_moment_efectuare%TYPE;
BEGIN
    SELECT id_moment_efectuare 
    INTO v_id_gasit
    FROM moment_efectuare_rezervare_OLAP
    WHERE an=p_an
    AND zi_din_an=p_zi_din_an;
    RETURN v_id_gasit;
END gaseste_id_moment_efectuare_OLAP;


CREATE OR REPLACE FUNCTION gaseste_id_tip_camera_OLAP(p_nr_paturi_duble tip_camera_OLAP.nr_paturi_duble%TYPE, p_nr_paturi_simple tip_camera_OLAP.nr_paturi_duble%TYPE,
                                                      p_are_terasa tip_camera_OLAP.are_terasa%TYPE, p_are_televizor tip_camera_OLAP.are_televizor%TYPE)
    RETURN tip_camera_OLAP.id_tip_camera%TYPE IS
    v_id_gasit tip_camera_OLAP.id_tip_camera%TYPE;
BEGIN
    SELECT id_tip_camera
    INTO v_id_gasit
    FROM tip_camera_OLAP
    WHERE nr_paturi_duble=p_nr_paturi_duble
    AND nr_paturi_simple=p_nr_paturi_simple
    AND are_terasa=p_are_terasa
    AND are_televizor=p_are_televizor;
    RETURN v_id_gasit;
END gaseste_id_tip_camera_OLAP;


CREATE OR REPLACE FUNCTION gaseste_id_tip_client_OLAP (p_varsta tip_client_OLAP.varsta%TYPE, p_gen tip_client_OLAP.gen%TYPE,p_stare_civila tip_client_OLAP.stare_civila%TYPE)
    RETURN tip_client_OLAP.id_tip_client%TYPE IS
    v_id_gasit tip_client_OLAP.id_tip_client%TYPE;
BEGIN
    SELECT id_tip_client
    INTO v_id_gasit
    FROM tip_client_OLAP
    WHERE varsta=p_varsta
    AND gen=p_gen
    AND stare_civila=p_stare_civila;
    RETURN v_id_gasit;
END gaseste_id_tip_client_OLAP;