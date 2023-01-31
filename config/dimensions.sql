CREATE DIMENSION perioada_rezervare_dim_OLAP
LEVEL zi_din_an_inceput IS perioada_rezervare_OLAP.zi_din_an_inceput
LEVEL zi_din_an_sfarsit IS perioada_rezervare_OLAP.zi_din_an_sfarsit
ATTRIBUTE zi_din_an_inceput DETERMINES ( perioada_rezervare_OLAP.zi_din_luna_inceput, perioada_rezervare_OLAP.luna_inceput, perioada_rezervare_OLAP.zi_din_saptamana_inceput)
ATTRIBUTE zi_din_an_sfarsit DETERMINES ( perioada_rezervare_OLAP.zi_din_luna_sfarsit, perioada_rezervare_OLAP.luna_sfarsit, perioada_rezervare_OLAP.zi_din_saptamana_sfarsit);


CREATE DIMENSION moment_efectuare_rezervare_dim_OLAP
LEVEL zi_din_an IS moment_efectuare_rezervare_OLAP.zi_din_an
ATTRIBUTE zi_din_an DETERMINES ( moment_efectuare_rezervare_OLAP.zi_din_luna, moment_efectuare_rezervare_OLAP.luna, moment_efectuare_rezervare_OLAP.zi_din_saptamana);


--Ierarhia de mai jos este problematica deoarece exista posibilitatea ca numele a doua localitati din judete diferite sa coincida
CREATE DIMENSION hotel_dim_OLAP
LEVEL regiune IS hotel_OLAP.regiune
LEVEL judet IS hotel_OLAP.judet
LEVEL localitate IS hotel_OLAP.localitate
HIERARCHY judet_localitate (
    localitate CHILD OF
    judet CHILD OF
    regiune
);


CREATE DIMENSION id_rezervare_dim_OLAP
LEVEL id_rezervare IS rezervare_camera_OLAP.id_rezervare
ATTRIBUTE id_rezervare DETERMINES (rezervare_camera_OLAP.id_perioada_rezervare, rezervare_camera_OLAP.id_moment_efectuare_rezervare, rezervare_camera_OLAP.id_hotel, rezervare_camera_OLAP.id_tip_client);