SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF
REM ********************************************************************
REM Create the UTILIZATOR table to hold users information for application
Prompt ******  Creating UTILIZATOR table ....

CREATE TABLE utilizator
    ( id_utilizator NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      nume_utilizator VARCHAR(30) CONSTRAINT nume_utilizator_nn NOT NULL, 
      hash_parola VARCHAR(25) CONSTRAINT hash_parola_utilizator_nn NOT NULL,
      nume_complet VARCHAR(30) CONSTRAINT nume_complet_utilizator_nn NOT NULL,
      telefon VARCHAR(15) CONSTRAINT telefon_utilizator_nn NOT NULL,
      email VARCHAR(50) CONSTRAINT email_utilizator_nn NOT NULL,
      data_nasterii DATE CONSTRAINT data_nasterii_utilizator_nn NOT NULL,
      gen VARCHAR(20) DEFAULT NULL,
      stare_civila VARCHAR(20) DEFAULT NULL);

CREATE UNIQUE INDEX id_utilizator_index
ON utilizator (id_utilizator);

ALTER TABLE utilizator
ADD ( CONSTRAINT id_nume_utilizator_pk PRIMARY KEY (id_utilizator)) ;

REM ********************************************************************
REM Create the REZERVARE table to hold information for reservation of users

Prompt ******  Creating REZERVARE table ....

CREATE TABLE rezervare
    ( id_rezervare NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      id_client NUMBER CONSTRAINT id_client_utilizator_nn NOT NULL,
      data_inceput DATE CONSTRAINT data_inceput_rezervare_nn NOT NULL,
      data_sfarsit DATE CONSTRAINT data_sfarsit_rezervare_nn NOT NULL,
      data_efectuarii DATE);

CREATE UNIQUE INDEX id_rezervare_index
ON rezervare (id_rezervare);

ALTER TABLE rezervare
ADD ( CONSTRAINT id_rezervare_pk PRIMARY KEY (id_rezervare)) ;

REM ********************************************************************
REM Create the ATRIBUIE table to hold information about rooms of users

Prompt ******  Creating ATRIBUIE table ....

CREATE TABLE atribuie
    ( id_rezervare NUMBER CONSTRAINT id_rezervare_atribuie_nn NOT NULL,
      id_camera NUMBER CONSTRAINT id_camera_atribuie_nn NOT NULL);

CREATE UNIQUE INDEX id_rezervare_camera_index
ON atribuie (id_rezervare,id_camera);

ALTER TABLE atribuie
ADD ( CONSTRAINT id_rezervare_camera__pk PRIMARY KEY (id_rezervare,id_camera));


REM ********************************************************************
REM Create the CAMERA table to hold informations about rooms  

Prompt ******  Creating CAMERA table ....

CREATE TABLE camera
    ( id_camera NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      id_hotel NUMBER CONSTRAINT id_hotel_camera_nn NOT NULL,
      nr_camera NUMBER,
      nr_etaj NUMBER,
      nr_paturi_duble NUMBER CONSTRAINT nr_paturi_duble_camera_nn NOT NULL,
      nr_paturi_simple NUMBER CONSTRAINT nr_paturi_simple_camera_nn NOT NULL,
      are_terasa NUMBER(1) CONSTRAINT are_terasa_camera_nn NOT NULL,
      are_televizor NUMBER(1) CONSTRAINT are_televizor_camera_nn NOT NULL,
      pret_per_noapte NUMBER CONSTRAINT pret_per_noapte_camera_nn NOT NULL);

CREATE UNIQUE INDEX id_camera_index
ON camera (id_camera);

ALTER TABLE camera
ADD ( CONSTRAINT id_camera_camera_pk PRIMARY KEY (id_camera)) ;

REM ********************************************************************
REM Create the HOTEL table to hold information of hotels 

Prompt ******  Creating HOTEL table ....

CREATE TABLE hotel
    ( id_hotel NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      nume VARCHAR2(50) CONSTRAINT nume_hotel_hotel_nn NOT NULL,
      nr_stele NUMBER CONSTRAINT nr_stele_nn NOT NULL,
      id_zona NUMBER CONSTRAINT id_zona_hotel_nn NOT NULL,
      are_mic_dejun_inclus NUMBER(1) CONSTRAINT are_mic_dejun_inclus_hotel_nn NOT NULL);

CREATE UNIQUE INDEX id_hotel_index
ON hotel (id_hotel);

ALTER TABLE hotel
ADD ( CONSTRAINT id_hotel_hotel_pk PRIMARY KEY (id_hotel)) ;

REM ********************************************************************
REM Create the ZONA table to hold informatation the zones where the hotels was build 

Prompt ******  Creating ZONA table ....

CREATE TABLE zona
    ( id_zona NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      regiune VARCHAR2(50),
      judet VARCHAR2(50) CONSTRAINT judet_zona_nn NOT NULL,
      localitate VARCHAR2(50) CONSTRAINT localitate_zona_nn NOT NULL,
      pozitie VARCHAR2(50) CONSTRAINT pozitie_zona_nn NOT NULL);

CREATE UNIQUE INDEX id_zona_zona_index
ON zona (id_zona);

ALTER TABLE zona
ADD ( CONSTRAINT id_zona_zona_pk PRIMARY KEY (id_zona)) ;




REM *********Introducerea de FK tabelului**** REZERVARE****************

Prompt ******  Creating FK Constraints on table REZERVARE ....

ALTER TABLE rezervare
add constraint fk_id_client_id_utilizator FOREIGN KEY(id_client) REFERENCES utilizator(id_utilizator);





REM *********Introducerea de FK tabelului**** CAMERA****************

Prompt ******  Creating FK Constraints on table CAMERA ....

ALTER TABLE camera
add constraint fk_camera_hotel FOREIGN KEY(id_hotel) REFERENCES hotel(id_hotel);





REM *********Introducerea de FK tabelului**** HOTEL****************

Prompt ******  Creating FK Constraints on table HOTEL ....

ALTER TABLE hotel
add constraint fk_hotel_zona FOREIGN KEY(id_zona) REFERENCES zona(id_zona);




REM *********Introducerea de FK tabelului**** REZERVARE_CAMERA****************
Prompt ******  Creating FK Constraints on table REZERVARE_CAMERA ....
ALTER TABLE rezervare_camera
ADD CONSTRAINT fk_rezervare_camera_rezervare FOREIGN KEY(id_rezervare) REFERENCES rezervare(id_rezervare);
ALTER TABLE rezervare_camera
ADD CONSTRAINT fk_rezervare_camera_camera FOREIGN KEY (id_camera) REFERENCES camera(id_camera);


COMMIT;


