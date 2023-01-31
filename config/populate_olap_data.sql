INSERT INTO perioada_rezervare_OLAP(zi_din_luna_inceput, luna_inceput, an_inceput, zi_din_saptamana_inceput, zi_din_an_inceput, zi_din_luna_sfarsit, luna_sfarsit, an_sfarsit, zi_din_saptamana_sfarsit, zi_din_an_sfarsit, durata_in_zile)
SELECT DISTINCT TO_NUMBER(TO_CHAR(data_inceput,'DD')), TO_CHAR(data_inceput,'MON'), TO_NUMBER(TO_CHAR(data_inceput,'YYYY')),
TO_CHAR(data_inceput,'DY'),TO_NUMBER(TO_CHAR(data_inceput,'DDD')),
TO_NUMBER(TO_CHAR(data_sfarsit,'DD')), TO_CHAR(data_sfarsit,'MON'), TO_NUMBER(TO_CHAR(data_sfarsit,'YYYY')),
TO_CHAR(data_sfarsit,'DY'),TO_NUMBER(TO_CHAR(data_sfarsit,'DDD')),
data_sfarsit - data_inceput
FROM rezervare; COMMIT;


INSERT INTO moment_efectuare_rezervare_OLAP(zi_din_luna, luna, an, zi_din_saptamana, zi_din_an)
SELECT DISTINCT TO_NUMBER(TO_CHAR(data_efectuarii,'DD')), TO_CHAR(data_efectuarii,'MON'), 
TO_NUMBER(TO_CHAR(data_efectuarii,'YYYY')),TO_CHAR(data_efectuarii,'DY'),TO_NUMBER(TO_CHAR(data_efectuarii,'DDD'))--,
--TO_NUMBER(TO_CHAR(data_efectuarii,'HH')) + CASE WHEN TO_NUMBER(TO_CHAR(data_efectuarii,'MI')) > 29 THEN 1 ELSE 0 END AS ora_aprox
FROM rezervare; COMMIT;

INSERT INTO hotel_OLAP(id_hotel, nume, regiune, judet, localitate, pozitie, nr_stele, are_mic_dejun_inclus)
SELECT id_hotel, nume, regiune, judet, localitate, pozitie, nr_stele, are_mic_dejun_inclus
FROM hotel JOIN zona
USING(id_zona); COMMIT;


INSERT INTO tip_client_OLAP(varsta,gen,stare_civila)
SELECT DISTINCT FLOOR(MONTHS_BETWEEN(SYSDATE,data_nasterii)/12) AS varsta, gen, stare_civila
FROM utilizator; COMMIT;


INSERT INTO tip_camera_OLAP(nr_paturi_duble, nr_paturi_simple,are_terasa,are_televizor)
SELECT DISTINCT nr_paturi_duble, nr_paturi_simple,are_terasa,are_televizor
FROM camera; COMMIT;


INSERT INTO rezervare_camera_OLAP(id_rezervare,id_hotel,id_perioada,id_moment_efectuare,id_tip_camera,id_tip_client,pret)
SELECT DISTINCT id_rezervare,id_hotel,
                gaseste_id_perioada_OLAP(TO_NUMBER(TO_CHAR(data_inceput,'DDD')),TO_NUMBER(TO_CHAR(data_inceput,'YYYY')),
                                        TO_NUMBER(TO_CHAR(data_sfarsit,'DDD')),TO_NUMBER(TO_CHAR(data_sfarsit,'YYYY'))) AS id_perioada,
                gaseste_id_moment_efectuare_OLAP(TO_NUMBER(TO_CHAR(data_efectuarii,'DDD')),TO_NUMBER(TO_CHAR(data_efectuarii,'YYYY'))) AS id_moment_efectuare,
                gaseste_id_tip_camera_OLAP(camera.nr_paturi_duble,camera.nr_paturi_simple,camera.are_terasa,camera.are_televizor) AS id_tip_camera,
                gaseste_id_tip_client_OLAP(calculeaza_varsta(utilizator.data_nasterii),utilizator.gen,utilizator.stare_civila) AS id_tip_client,
                camera.pret_per_noapte * (rezervare.data_sfarsit - rezervare.data_inceput) AS pret
FROM utilizator JOIN rezervare
ON utilizator.id_utilizator=rezervare.id_client
JOIN rezervare_camera
USING(id_rezervare)
JOIN camera
USING(id_camera)
JOIN hotel
USING(id_hotel); COMMIT;