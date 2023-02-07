DROP TABLE perioada_rezervare_OLAP;
CREATE TABLE dw_manager.perioada_rezervare_OLAP(
id_perioada NUMBER(8,0) GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
zi_din_luna_inceput NUMBER(2,0) CONSTRAINT zi_din_luna_inceput_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
luna_inceput CHAR(3) CONSTRAINT luna_inceput_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
an_inceput NUMBER(4,0)CONSTRAINT an_inceput_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_saptamana_inceput CHAR(3) CONSTRAINT zi_din_saptamana_inceput_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_an_inceput NUMBER(3,0) CONSTRAINT zi_din_an_inceput_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_luna_sfarsit NUMBER(2,0) CONSTRAINT zi_din_luna_sfarsit_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
luna_sfarsit CHAR(3) CONSTRAINT luna_sfarsit_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
an_sfarsit NUMBER(4,0) CONSTRAINT an_sfarsit_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_saptamana_sfarsit CHAR(3) CONSTRAINT zi_din_saptamana_sfarsit_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_an_sfarsit NUMBER(3,0) CONSTRAINT zi_din_an_sfarsit_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
durata_in_zile NUMBER(2,0) CONSTRAINT durata_in_zile_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
PRIMARY KEY(id_perioada)
);


DROP TABLE dw_manager.tip_camera_OLAP;
CREATE TABLE dw_manager.tip_camera_OLAP(
      id_tip_camera NUMBER(8)GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      nr_paturi_duble NUMBER(1) CONSTRAINT nr_paturi_duble_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      nr_paturi_simple NUMBER(1)CONSTRAINT nr_paturi_simple_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      are_terasa NUMBER(1)CONSTRAINT are_terasa_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      are_televizor NUMBER(1) CONSTRAINT are_telezivor_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      PRIMARY KEY (id_tip_camera)
);


DROP TABLE dw_manager.hotel_OLAP;
CREATE TABLE dw_manager.hotel_OLAP
( 
      id_hotel NUMBER(8),
      nume VARCHAR2(50) CONSTRAINT nume_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      nr_stele NUMBER(1) CONSTRAINT nr_stele_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      regiune VARCHAR2(50),
      judet VARCHAR2(20) CONSTRAINT judet_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      localitate VARCHAR(20) CONSTRAINT localitate_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      pozitie VARCHAR(20) CONSTRAINT pozitie_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      nr_camere NUMBER(3),
      are_mic_dejun_inclus NUMBER(1) CONSTRAINT are_mic_dejun_inclus_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
      PRIMARY KEY (id_hotel)
)
PARTITION LIST(nr_stele)
      (PARTITION o_stea VALUES (1),
       PARTITION doua_stele VALUES (2),
       PARTITION trei_stele VALUES  (3),
       PARTITION patru_stele VALUES (4),
       PARTITION cinci_stele VALUES (5));


DROP TABLE dw_manager.tip_client_OLAP;
CREATE TABLE dw_manager.tip_client_OLAP(
 id_tip_client NUMBER(8) GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
 varsta NUMBER(3) CONSTRAINT varsta_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
 gen VARCHAR(20),
 stare_civila VARCHAR(20),
 PRIMARY KEY (id_tip_client)
 );


DROP TABLE dw_manager.moment_efectuare_rezervare_OLAP;
CREATE TABLE dw_manager.moment_efectuare_rezervare_OLAP(
id_moment_efectuare NUMBER(8,0) GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
zi_din_luna NUMBER(2,0) CONSTRAINT zi_din_luna_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
luna CHAR(3) CONSTRAINT luna_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
an NUMBER(4,0) CONSTRAINT an_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_saptamana CHAR(3) CONSTRAINT zi_din_saptamana_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
zi_din_an NUMBER(3,0) CONSTRAINT zi_din_an_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
--ora_aprox NUMBER(2,0),
PRIMARY KEY (id_moment_efectuare)
);


DROP TABLE dw_manager.rezervare_camera_OLAP;
CREATE TABLE dw_manager.rezervare_camera_OLAP(
id_rezervare NUMBER(8,0) CONSTRAINT id_rezervare_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
id_hotel NUMBER(8,0) CONSTRAINT id_hotel_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
id_perioada NUMBER(8,0) CONSTRAINT id_perioada_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
id_moment_efectuare NUMBER(8,0) CONSTRAINT id_moment_efectuare_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
id_tip_client NUMBER(8,0) CONSTRAINT id_tip_client_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
id_tip_camera NUMBER(8,0) CONSTRAINT id_tip_camera_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE,
pret NUMBER CONSTRAINT pret_nn_OLAP NOT NULL RELY DISABLE NOVALIDATE
);

ALTER TABLE dw_manager.rezervare_camera_OLAP
ADD FOREIGN KEY(id_hotel) REFERENCES hotel_OLAP(id_hotel);

ALTER TABLE dw_manager.rezervare_camera_OLAP
ADD FOREIGN KEY(id_perioada) REFERENCES perioada_rezervare_OLAP(id_perioada);

ALTER TABLE dw_manager.rezervare_camera_OLAP
ADD FOREIGN KEY(id_moment_efectuare) REFERENCES moment_efectuare_rezervare_OLAP(id_moment_efectuare);

ALTER TABLE dw_manager.rezervare_camera_OLAP
ADD FOREIGN KEY(id_tip_camera) REFERENCES tip_camera_OLAP(id_tip_camera);

ALTER TABLE dw_manager.rezervare_camera_OLAP
ADD FOREIGN KEY(id_tip_client) REFERENCES tip_client_OLAP(id_tip_client);