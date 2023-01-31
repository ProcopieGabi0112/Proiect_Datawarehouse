CREATE INDEX id_rezervare_index_OLAP
ON  rezervare_camera_OLAP(id_rezervare);

CREATE BITMAP INDEX luna_an_efectuare_bjindex_OLAP
ON moment_efectuare_OLAP(moment_efectuare_OLAP.luna,moment_efectuare_OLAP.an)
FROM moment_efectuare_OLAP,rezervare_camera_OLAP
WHERE rezervare_camera_OLAP.id_moment_efectuare= moment_efectuare_OLAP.id_moment_efectuare;

CREATE BITMAP INDEX localitate_pozitie_bjindex_OLAP
ON   hotel_OLAP(hotel.localitate,hotel.pozitie)
FROM  hotel_OLAP, rezervare_camera_OLAP
WHERE rezervare_camera_OLAP.id_hotel = hotel_OLAP.id_hotel;

CREATE BITMAP INDEX nr_paturi_duble_nr_paturi_simple_bjindex_OLAP
ON    tip_camera_OLAP(tip_camera_OLAP.nr_paturi_duble,tip_camera_OLAP.nr_paturi_simple)
FROM  tip_camera_OLAP, rezervare_camera_OLAP
WHERE  tip_camera_OLAP.id_tip_camera= rezervare_camera_OLAP.id_tip_camera;