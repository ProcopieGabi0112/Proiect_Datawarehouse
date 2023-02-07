alter session set "_ORACLE_SCRIPT"=true;

show con_name;
alter session set container= orclpdb1;
show con_name;

-- ALTER PLUGGABLE DATABASE orclpdb1 open; ALREADY OPEN?
-- alter system disable restricted session; 
alter system set local_listener = '(ADDRESS=(PROTOCOL=TCP)(HOST=0.0.0.0)(PORT=1521))' scope = both;
CREATE USER marius IDENTIFIED BY db_pass;
GRANT ALL PRIVILEGES TO marius;
CREATE USER dw_manager IDENTIFIED BY mng_pass;
GRANT CREATE SESSION dw_manager;
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

SELECT * 
FROM session_privs;


SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

CREATE TABLE dw_manager.utilizator
    ( id_utilizator NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      nume_utilizator VARCHAR(30) CONSTRAINT nume_utilizator_nn NOT NULL, 
      hash_parola VARCHAR(25) CONSTRAINT hash_parola_utilizator_nn NOT NULL,
      nume_complet VARCHAR(30) CONSTRAINT nume_complet_utilizator_nn NOT NULL,
      telefON dw_manager.VARCHAR(15) CONSTRAINT telefon_utilizator_nn NOT NULL,
      email VARCHAR(50) CONSTRAINT email_utilizator_nn NOT NULL,
      data_nasterii DATE CONSTRAINT data_nasterii_utilizator_nn NOT NULL,
      gen VARCHAR(20) DEFAULT NULL,
      stare_civila VARCHAR(20) DEFAULT NULL);

  CREATE TABLE dw_manager.zona
    ( id_zona NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      judet VARCHAR2(50) CONSTRAINT judet_zona_nn NOT NULL,
      localitate VARCHAR2(50) CONSTRAINT localitate_zona_nn NOT NULL,
      pozitie VARCHAR2(50) CONSTRAINT pozitie_zona_nn NOT NULL);

CREATE UNIQUE INDEX id_zona_zona_index
ON dw_manager.zona (id_zona);

ALTER TABLE zona
ADD ( CONSTRAINT id_zona_zona_pk PRIMARY KEY (id_zona)) ;    

CREATE UNIQUE INDEX id_utilizator_index
ON dw_manager.utilizator (id_utilizator);

ALTER TABLE dw_manager.utilizator
ADD ( CONSTRAINT id_nume_utilizator_pk PRIMARY KEY (id_utilizator)) ;

CREATE TABLE dw_manager.rezervare
    ( id_rezervare NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      id_client NUMBER CONSTRAINT id_client_utilizator_nn NOT NULL,
      data_inceput DATE CONSTRAINT data_inceput_rezervare_nn NOT NULL,
      data_sfarsit DATE CONSTRAINT data_sfarsit_rezervare_nn NOT NULL);

CREATE UNIQUE INDEX rezervare_index
ON dw_manager. rezervare (id_rezervare);

ALTER TABLE dw_manager.rezervare
ADD ( CONSTRAINT id_rezervare_pk PRIMARY KEY (id_rezervare)) ;

CREATE TABLE dw_manager.atribuie
    ( id_rezervare NUMBER CONSTRAINT id_rezervare_atribuie_nn NOT NULL,
      id_camera NUMBER CONSTRAINT id_camera_atribuie_nn NOT NULL);

CREATE UNIQUE INDEX id_rezervare_camera_index
ON dw_manager.dw_manager.atribuie (id_rezervare,id_camera);

ALTER TABLE dw_manager.atribuie
ADD ( CONSTRAINT id_rezervare_camera__pk PRIMARY KEY (id_rezervare,id_camera));

CREATE TABLE dw_manager.camera
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
ON dw_manager.dw_manager.zona(id_camera);

ALTER TABLE dw_manager.zona
ADD ( CONSTRAINT id_camera_camera_pk PRIMARY KEY (id_camera)) ;

CREATE TABLE dw_manager.hotel
    ( id_hotel NUMBER GENERATED ALWAYS as IDENTITY(START WITH 1 INCREMENT BY 1),
      nume VARCHAR2(50) CONSTRAINT nume_hotel_hotel_nn NOT NULL,
      nr_stele NUMBER CONSTRAINT nr_stele_nn NOT NULL,
      id_zona NUMBER CONSTRAINT id_zona_hotel_nn NOT NULL,
      are_mic_dejun_inclus NUMBER(1) CONSTRAINT are_mic_dejun_inclus_hotel_nn NOT NULL);

CREATE UNIQUE INDEX id_hotel_index
ON dw_manager.hotel (id_hotel);

ALTER TABLE hotel
ADD ( CONSTRAINT id_hotel_hotel_pk PRIMARY KEY (id_hotel)) ;


CREATE UNIQUE INDEX id_zona_zona_index
ON dw_manager.dw_manager.zona (id_zona);

ALTER TABLE  dw_manager.zona
ADD ( CONSTRAINT id_zona_pk PRIMARY KEY (id_zona)) ;

ALTER TABLE  dw_manager.rezervare
add constraint fk_id_client_id_utilizator FOREIGN KEY(id_client) REFERENCES utilizator(id_utilizator);

ALTER TABLE dw_manager.zona
add constraint fk_camera_hotel FOREIGN KEY(id_hotel) REFERENCES dw_manager.hotel(id_hotel);

ALTER TABLE dw_manager.hotel
add constraint fk_hotel_zona FOREIGN KEY(id_zona) REFERENCES  dw_manager.zona(id_zona);

ALTER TABLE dw_manager.atribuie
ADD CONSTRAINT fk_atribuie_rezervare FOREIGN KEY(id_rezervare) REFERENCES dw_manager.rezervare(id_rezervare);
ALTER TABLE dw_manager.atribuie
ADD CONSTRAINT fk_atribuie_camera FOREIGN KEY (id_camera) REFERENCES dw_manager.camera(id_camera);


alter session dw_manager.set container= orclpdb1;

INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Mures', 'Targu Mures', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Bran ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Bran ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Bucharest', 'Bucharest', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Prahova', 'Sinaia ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Bucharest', 'Bucharest ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Sibiu ', 'Sibiu ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Iasi', 'Iasi ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Constanta ', 'Constanta ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Sibiu', 'Sibiu ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Cluj', 'Cluj-Napoca ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Poiana Brasov ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Brasov ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Brasov', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov ', 'Moieciu ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Bihor', 'Oradea ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Suceava', 'Gura Humorului ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Buzau ', 'Buzau ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Constanta ', 'Constanta ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Cluj', 'Cluj-Napoca ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Mures', 'Sighisoara ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Ilfov', 'Otopeni ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Mures', 'Sighisoara ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Suceava', 'Suceava ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Maramures', 'Breb ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Prahova', 'Ploiesti ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Poiana Brasov ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Maramures', 'Viseu de Sus ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Suceava', 'Suceava ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Valcea', 'Ramnicu Valcea ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Brasov', 'Magura ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Maramures', 'Breb ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Constanta', 'Vama Veche', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Ilfov', 'Otopeni ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Sibiu', 'Paltinis ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Prahova', 'Ploiesti ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Maramures', 'Vadu Izei ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Bihor', 'Oradea ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Arges', 'Curtea de Arges ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Satu Mare ', 'Satu Mare ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Arad ', 'Arad ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Iasi', 'Iasi ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Bacau ', 'Bacau ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Arad', 'Arad', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Neamt', 'Piatra Neamt ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Timis', 'Timisoara ', 'centrala');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Maramures', 'Vadu Izei ', 'periferica');
INSERT INTO dw_manager.zona (JUDET, LOCALITATE, POZITIE) VALUES ('Bihor', 'Baile Felix ', 'centrala');

---Inserarea datelor in tabelul hotel(dependent de zona)---

INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Privo',4,1,0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Conacul Bratescu', 4, 2, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Transylvanian Inn', 3, 3, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('The MansiON dw_manager.Boutique hotel', 4, 4, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Ioana hotel', 5, 5, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Epoque hotel Relais Chateaux', 5, 6, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Rosen Villa Sibiu', 1, 7, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel International Iasi', 4, 8, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('IAKI Conference Spa hotel', 4, 9, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Republique hotel', 4, 7, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('HamptON dw_manager.by HiltON dw_manager.Cluj-Napoca', 3, 11, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Grand hotel Continental', 5, 5, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Ana hotels Sport Poiana Brasov', 4, 12, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Casa Wagner', 3, 14, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Kismet Dao Hostel', 1, 13, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Transylvania Hostel', 1, 20, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Orhideea Residence Spa', 4, 4, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Rozelor boutique hotel', 4, 13, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('ibis Styles Bucharest City Center', 3, 4, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Kronwell Brasov hotel', 4, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Akasha Wellness Retreat', 3, 15, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('HiltON dw_manager.Garden Inn Bucharest Old Town', 4, 4, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Centrum House Hostel Bar', 1, 13, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('The Spot Cosy Hostel', 1, 20, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Belfort hotel', 3, 13, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Ramada by Wyndham Oradea', 4, 16, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Christina', 4, 6, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Corona', 1, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('JW Marriott Bucharest Grand hotel', 5, 4, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('La Roata', 3, 17, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Caro hotel', 4, 4, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Hadar Chalet', 1, 18, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Cherica', 4, 19, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Golden Tulip Ana Tower Sibiu', 4, 7, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Capitolina City Chic hotel', 3, 11, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Lia', 1, 23, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Lol et Lola hotel', 3, 11, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Guesthouse La Despani', 2, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Bella Muzica', 3, 13, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('HiltON dw_manager.Garden Inn Bucharest Airport', 4, 34, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Rembrandt hotel', 3, 6, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Central Park', 4, 21, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Savri', 1, 23, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Radsor', 4, 48, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Cismigiu', 4, 4, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Splendid Conference Spa hotel', 4, 9, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Taschler Haus', 3, 23, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Mandachi hotel Spa', 4, 24, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Fronius Residence', 5, 21, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Armatti hotel', 3, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Concorde Old Bucharest hotel', 4, 6, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Vila Katharina', 4, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('The Village hotel', 1, 25, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Platinia hotel', 5, 11, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Central', 4, 26, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Vienna House Easy Airport Bucharest', 4, 22, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Mercure Bucharest City Center', 4, 6, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Sonnenhof', 4, 29, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Teleferic Grand hotel', 4, 12, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('K+K hotel Elisabeta', 4, 6, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Pensiune Restaurant La Cassa', 1, 28, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Hostel Boemia', 1, 13, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Golden Tulip Ana Dome', 4, 20, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Christina Plus', 4, 6, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Simfonia Boutique hotel', 4, 30, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('JugendStube Hostel Brasov', 3, 13, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('UpperHouse', 1, 14, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Luxemburg', 3, 7, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Pensiunea Ana', 1, 3, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Hille Guesthouse', 1, 31, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Babou Maramures', 1, 32, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Elvira', 3, 33, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Amethyst House', 3, 22, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Hohe Rinne Paltinis hotel Spa', 4, 35, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Paradis', 4, 20, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Pensiunea Teodora Teleptean', 1, 37, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Ivana Apart hotel', 3, 38, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Pensiunea Ioana', 3, 39, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Satu Mare City hotel', 4, 40, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Pensiunea Christiana', 1, 44, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Arnia', 3, 8, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Parliament hotel', 4, 4, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Levoslav House', 4, 7, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Little Texas', 4, 42, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Escalade Poiana Brasov', 4, 12, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Toparceanu Vila', 3, 27, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Pleiada Boutique hotel', 5, 8, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Marshal Garden hotel', 5, 4, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Vacanza Brasov', 3, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Helen hotel Bacau', 4, 43, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Continental Forum Arad', 4, 41, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Select Iasi', 4, 42, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Coroana Brasovului', 3, 13, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Central Plaza hotel', 4, 14, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('PensiON dw_manager.Bellagio', 4, 11, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Opera Plaza hotel', 5, 20, 0);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Del Corso hotel', 3, 46, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Casa Muntean', 1, 47, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('hotel Beyfin', 4, 20, 1);
INSERT INTO dw_manager.hotel (NUME, NR_STELE, ID_zona, ARE_MIC_DEJUN_INCLUS) VALUES ('Lotus Therm Spa Luxury Resort', 5, 48, 1);

---Inserarea datelor in tabelul camera(dependent de hotel)---

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (76, 312, 3, 0, 3, 1, 0, 450);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (78, 107, 1, 0, 1, 1, 0, 100);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (44, 405, 4, 0, 2, 1, 0, 180);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (13, 323, 3, 1, 3, 1, 0, 410);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (52, 100, 1, 0, 3, 1, 1, 520);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (3, 206, 2, 1, 1, 1, 0, 290);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (26, 527, 5, 0, 2, 0, 0, 160);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (32, 220, 2, 0, 3, 1, 1, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (11, 303, 3, 1, 1, 0, 1, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (75, 116, 1, 2, 3, 1, 0, 590);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (23, 417, 4, 0, 3, 1, 0, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (36, 221, 2, 1, 1, 1, 1, 210);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (20, 324, 3, 2, 2, 1, 0, 460);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (44, 216, 2, 0, 2, 0, 1, 180);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (12, 128, 1, 1, 3, 0, 1, 500);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (8, 419, 4, 0, 2, 0, 0, 190);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (34, 322, 3, 0, 3, 0, 0, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (40, 516, 5, 1, 2, 0, 0, 330);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (41, 416, 4, 1, 3, 1, 1, 470);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (89, 319, 3, 1, 2, 1, 1, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (100, 203, 2, 0, 3, 1, 0, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (74, 308, 3, 0, 1, 0, 0, 90);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (45, 309, 3, 0, 3, 1, 0, 260);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (23, 128, 1, 2, 2, 0, 0, 500);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (79, 521, 5, 1, 1, 0, 0, 260);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (77, 204, 2, 1, 3, 1, 1, 510);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (94, 200, 2, 1, 1, 1, 1, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (11, 300, 3, 2, 3, 0, 1, 550);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (2, 216, 2, 1, 3, 0, 0, 430);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (60, 523, 5, 0, 1, 1, 1, 100);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (90, 214, 2, 0, 3, 1, 0, 450);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (50, 505, 5, 0, 3, 0, 0, 320);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (54, 324, 3, 0, 1, 0, 1, 110);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (12, 521, 5, 0, 3, 0, 0, 320);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (49, 208, 2, 2, 1, 1, 1, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (99, 401, 4, 2, 2, 1, 1, 820);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (74, 229, 2, 2, 2, 1, 0, 430);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (67, 503, 5, 0, 3, 1, 1, 400);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (34, 428, 4, 1, 2, 0, 1, 340);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (93, 121, 1, 0, 1, 0, 0, 120);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (10, 302, 3, 1, 2, 1, 1, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (43, 119, 1, 2, 3, 0, 1, 490);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (65, 103, 1, 2, 2, 0, 0, 420);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (39, 110, 1, 1, 2, 0, 1, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (27, 323, 3, 1, 3, 0, 0, 460);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (44, 207, 2, 1, 3, 1, 1, 390);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (81, 118, 1, 0, 2, 1, 1, 210);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (50, 405, 4, 2, 1, 0, 0, 790);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (98, 420, 4, 1, 2, 0, 1, 290);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (72, 506, 5, 2, 3, 0, 0, 990);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (99, 429, 4, 2, 3, 1, 1, 580);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (27, 403, 4, 1, 1, 1, 0, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (63, 315, 3, 0, 2, 0, 0, 190);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 206, 2, 2, 2, 1, 0, 530);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (4, 427, 4, 2, 2, 0, 1, 420);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (33, 404, 4, 1, 2, 1, 1, 330);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 226, 2, 1, 2, 0, 1, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (10, 209, 2, 1, 3, 0, 0, 500);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (26, 422, 4, 0, 3, 0, 0, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (65, 109, 1, 1, 2, 0, 1, 370);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (98, 124, 1, 1, 2, 1, 0, 320);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (26, 527, 5, 2, 3, 0, 0, 540);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (43, 125, 1, 1, 3, 1, 1, 360);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (34, 424, 4, 2, 1, 1, 1, 330);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (40, 315, 3, 2, 2, 1, 1, 370);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (76, 308, 3, 2, 1, 1, 0, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (20, 428, 4, 1, 2, 0, 0, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (98, 222, 2, 2, 1, 0, 0, 440);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (55, 528, 5, 2, 3, 0, 1, 640);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (3, 518, 5, 1, 2, 1, 1, 340);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (94, 302, 3, 1, 1, 1, 1, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (32, 123, 1, 0, 2, 1, 0, 170);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (64, 418, 4, 1, 2, 0, 0, 300);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (15, 304, 3, 2, 2, 1, 0, 460);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (6, 217, 2, 2, 1, 1, 1, 320);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (16, 425, 4, 0, 1, 1, 1, 90);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (43, 129, 1, 2, 3, 1, 0, 540);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (70, 221, 2, 0, 3, 1, 1, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (27, 205, 2, 2, 3, 1, 1, 480);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (54, 320, 3, 1, 2, 0, 1, 330);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (3, 422, 4, 0, 3, 1, 0, 270);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (36, 411, 4, 2, 1, 1, 1, 600);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (6, 107, 1, 2, 3, 1, 1, 470);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (100, 121, 1, 0, 2, 1, 0, 200);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (95, 510, 5, 2, 3, 1, 0, 600);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (32, 518, 5, 2, 3, 0, 0, 500);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (90, 407, 4, 1, 2, 0, 1, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (40, 422, 4, 1, 1, 1, 1, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (28, 305, 3, 2, 2, 0, 1, 460);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (23, 220, 2, 1, 3, 1, 1, 380);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (3, 215, 2, 0, 3, 1, 1, 270);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (78, 503, 5, 2, 3, 1, 0, 610);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (27, 116, 1, 2, 2, 0, 1, 510);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 123, 1, 0, 2, 0, 1, 210);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (66, 414, 4, 2, 1, 0, 0, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (70, 510, 5, 2, 3, 1, 1, 630);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (11, 313, 3, 2, 1, 0, 0, 370);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (99, 425, 4, 0, 2, 1, 0, 210);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (41, 515, 5, 2, 3, 1, 1, 550);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (42, 417, 4, 1, 2, 0, 1, 340);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (100, 423, 4, 2, 1, 1, 1, 340);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (3, 501, 5, 1, 1, 1, 0, 220);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (94, 415, 4, 0, 1, 1, 1, 100);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (18, 320, 3, 1, 2, 1, 0, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (84, 300, 3, 1, 3, 1, 1, 400);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (5, 326, 3, 2, 3, 1, 1, 540);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (38, 408, 4, 2, 2, 1, 1, 500);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (49, 119, 1, 0, 2, 1, 1, 160);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (32, 106, 1, 0, 3, 1, 1, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (80, 117, 1, 1, 3, 1, 1, 410);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (75, 516, 5, 2, 1, 0, 1, 360);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (85, 115, 1, 0, 3, 0, 1, 320);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (14, 424, 4, 2, 1, 1, 0, 330);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (44, 316, 3, 2, 1, 1, 1, 420);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (10, 213, 2, 1, 3, 1, 1, 440);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (8, 405, 4, 0, 1, 0, 0, 100);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (80, 217, 2, 0, 2, 1, 1, 190);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (49, 500, 5, 2, 1, 1, 0, 370);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (66, 409, 4, 2, 1, 0, 0, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (57, 214, 2, 0, 1, 0, 1, 100);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (55, 113, 1, 1, 1, 0, 1, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (47, 406, 4, 2, 3, 1, 0, 570);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (11, 412, 4, 1, 2, 1, 0, 300);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 425, 4, 0, 2, 1, 0, 190);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (69, 314, 3, 0, 2, 1, 0, 210);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (16, 422, 4, 2, 2, 0, 0, 540);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (24, 105, 1, 0, 2, 1, 1, 220);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (92, 201, 2, 2, 2, 0, 0, 420);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (17, 415, 4, 1, 3, 1, 0, 440);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (34, 100, 1, 2, 2, 0, 1, 470);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (67, 512, 5, 0, 1, 1, 0, 80);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (52, 321, 3, 2, 3, 1, 0, 490);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (5, 216, 2, 0, 3, 1, 0, 490);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (20, 200, 2, 0, 1, 1, 1, 100);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (86, 409, 4, 1, 1, 1, 0, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (52, 323, 3, 0, 2, 1, 0, 170);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (94, 400, 4, 2, 3, 1, 1, 540);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (94, 309, 3, 0, 1, 0, 0, 90);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (91, 218, 2, 1, 3, 0, 0, 390);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (85, 521, 5, 2, 1, 0, 0, 390);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (66, 504, 5, 1, 2, 0, 0, 330);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (57, 425, 4, 0, 2, 1, 1, 200);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (18, 120, 1, 1, 1, 1, 0, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (99, 511, 5, 1, 1, 0, 0, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (49, 308, 3, 2, 2, 1, 0, 420);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (53, 407, 4, 2, 3, 0, 0, 640);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (38, 512, 5, 2, 3, 0, 1, 570);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (95, 507, 5, 2, 1, 1, 0, 450);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (30, 423, 4, 2, 3, 1, 0, 600);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (62, 508, 5, 0, 1, 1, 0, 110);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (39, 321, 3, 2, 3, 0, 1, 550);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (91, 508, 5, 1, 2, 1, 1, 360);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (53, 318, 3, 1, 2, 1, 0, 300);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (98, 315, 3, 2, 2, 1, 1, 450);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (39, 106, 1, 1, 2, 0, 1, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (39, 212, 2, 1, 3, 0, 1, 370);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (61, 404, 4, 2, 3, 1, 1, 500);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 323, 3, 0, 3, 1, 0, 280);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (33, 402, 4, 2, 3, 1, 1, 510);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (2, 418, 4, 1, 3, 0, 0, 420);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (48, 205, 2, 2, 1, 1, 1, 370);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (21, 225, 2, 0, 1, 0, 1, 90);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (45, 311, 3, 0, 1, 0, 0, 80);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (95, 215, 2, 2, 1, 0, 0, 350);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (85, 317, 3, 0, 3, 1, 1, 320);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (82, 408, 4, 2, 1, 0, 1, 380);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (57, 213, 2, 1, 1, 1, 1, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (71, 110, 1, 1, 3, 0, 1, 550);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (50, 300, 3, 1, 1, 1, 0, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (46, 214, 2, 1, 1, 1, 0, 200);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (53, 119, 1, 1, 1, 0, 0, 210);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (9, 507, 5, 1, 1, 1, 1, 190);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (92, 213, 2, 0, 1, 1, 1, 90);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (14, 229, 2, 1, 3, 0, 0, 450);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (2, 401, 4, 2, 3, 1, 1, 540);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (1, 126, 1, 1, 1, 1, 0, 220);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (31, 502, 5, 1, 3, 1, 1, 470);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (10, 216, 2, 0, 2, 0, 1, 200);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (89, 500, 5, 0, 2, 0, 1, 200);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (91, 127, 1, 2, 3, 0, 0, 510);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (90, 509, 5, 2, 3, 0, 1, 560);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (34, 218, 2, 0, 2, 0, 0, 190);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 423, 4, 0, 3, 1, 0, 300);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (96, 124, 1, 0, 2, 0, 1, 160);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (92, 109, 1, 1, 1, 1, 1, 200);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (92, 204, 2, 0, 3, 1, 0, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (78, 103, 1, 1, 1, 0, 1, 310);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (74, 100, 1, 0, 2, 0, 1, 220);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (8, 404, 4, 2, 1, 1, 1, 690);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (70, 423, 4, 2, 1, 1, 1, 410);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (66, 215, 2, 1, 1, 0, 1, 240);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (60, 519, 5, 0, 1, 0, 1, 80);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (24, 308, 3, 0, 3, 1, 0, 290);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (83, 225, 2, 1, 1, 0, 1, 250);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (21, 216, 2, 1, 3, 0, 0, 400);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (7, 211, 2, 1, 1, 1, 1, 230);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (40, 110, 1, 2, 1, 1, 0, 300);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (100, 314, 3, 1, 1, 1, 0, 400);

INSERT INTO dw_manager.camera (ID_hotel, NR_camera, NR_ETAJ, NR_PATURI_DUBLE, NR_PATURI_SIMPLE, ARE_TERASA, ARE_TELEVIZOR, PRET_PER_NOAPTE) VALUES (76, 527, 5, 0, 2, 1, 0, 180);

----------------------------------------------
---Inserarea datelor in tabelul utilizator---

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('bernard_noble', 'kr1O2h8', 'Bernard Noble', '+40 710 024 027', 'kstoltenberg@yahoo.com', to_date('13-Oct-1976', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('isis_saunders', 'PA3pnYV', 'Isis Saunders', '+40 713 721 929', 'orn.skye@huels.com', to_date('6-Apr-2001', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('micaela_gillespie', 'G7fSXy8', 'Micaela Gillespie', '+40 713 037 240', 'stuart22@yahoo.com', to_date('19-Apr-1966', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('gilbert_mccarty', 'ek1Rwcq', 'Gilbert Mccarty', '+40 711 666 147', 'gskiles@altenwerth.com', to_date('31-Jul-1969', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('harmony_ramirez', 'MOqsV7k', 'Harmony Ramirez', '+40 702 003 043', 'wfranecki@farrell.com', to_date('4-May-1996', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('noelle_schroeder', 'd2Au0dz', 'Noelle Schroeder', '+40 702 067 475', 'yasmeen86@hotmail.com', to_date('12-Feb-1982', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('nathaly_bryan', 'uaVkX6B', 'Nathaly Bryan', '+40 702 088 783', 'arne.williamson@yahoo.com', to_date('9-Jan-1999', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('melissa_mercado', 'c2SMIX0', 'Melissa Mercado', '+40 702 082 200', 'wilfredo96@wehner.com', to_date('7-Feb-1944', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('karma_haynes', 'Z1VJJkz', 'Karma Haynes', '+40 702 096 185', 'xhomenick@gmail.com', to_date('1-Oct-1959', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('lyla_gill', 'ToP7Pww', 'Lyla Gill', '+40 707 906 743', 'marlen.collins@hotmail.com', to_date('13-Jun-1942', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('yazmin_mason', 'P2rjpT0', 'Yazmin Mason', '+40 702 039 236', 'lebsack.laurianne@hotmail.com', to_date('16-Sep-1979', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('makai_larson', 'NiKk2LW', 'Makai Larson', '+40 702 063 583', 'chanel.kassulke@ullrich.com', to_date('22-Nov-1983', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('julien_vance', 'Io1JWmU', 'Julien Vance', '+40 702 009 249', 'henderson.kris@dach.com', to_date('3-Feb-1941', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jade_porter', 'kcV7NAm', 'Jade Porter', '+40 785 643 672', 'turcotte.emanuel@hotmail.com', to_date('19-Jan-1966', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jessica_dominguez', 'E7GUqri', 'Jessica Dominguez', '+40 720 732 214', 'edietrich@hotmail.com', to_date('24-Nov-2000', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('markus_mercado', 'na5Oqad', 'Markus Mercado', '+40 787 876 116', 'cyrus97@yahoo.com', to_date('21-Nov-1952', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('alejandra_patton', 'Bkg3LbS', 'Alejandra Patton', '+40 702 042 235', 'zhintz@yahoo.com', to_date('17-Apr-1959', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('angie_cox', 'y2CtwQz', 'Angie Cox', '+40 791 455 704', 'alexander59@hotmail.com', to_date('16-Dec-1952', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('susan_rangel', 'jo7DCQg', 'Susan Rangel', '+40 711 330 517', 'cody.walsh@hotmail.com', to_date('8-May-1960', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('valentino_duke', 'jNmV3Hq', 'Valentino Duke', '+40 702 078 210', 'breanne16@blick.com', to_date('9-Oct-1961', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jonathon_richmond', 'q9EjwLQ', 'JonathON dw_manager.Richmond', '+40 702 052 938', 'schiller.katelyn@heller.com', to_date('21-Sep-1984', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('reese_kramer', 'Ydu5s09', 'Reese Kramer', '+40 704 122 770', 'yquigley@mcdermott.com', to_date('12-Nov-1963', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('branden_cabrera', 'w8K4Uxm', 'Branden Cabrera', '+40 705 980 371', 'watsica.citlalli@yahoo.com', to_date('15-Oct-1995', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('kendrick_pruitt', 'xLqHx23', 'Kendrick Pruitt', '+40 710 987 951', 'vdubuque@gmail.com', to_date('12-Aug-2001', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('kian_miles', 'b5LvNGR', 'Kian Miles', '+40 702 020 646', 'bruce88@hotmail.com', to_date('6-Mar-1962', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('hope_lamb', 'LJj3K9I', 'Hope Lamb', '+40 700 279 657', 'reilly.becker@yahoo.com', to_date('23-Oct-1946', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('morgan_noble', 'R3b06De', 'Morgan Noble', '+40 701 859 569', 'plarkin@connelly.com', to_date('27-Mar-1951', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('nevaeh_cross', 'OmIHy8J', 'Nevaeh Cross', '+40 702 019 995', 'willard08@gmail.com', to_date('18-Sep-1943', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('sheldon_wiggins', 'yU45H8E', 'SheldON dw_manager.Wiggins', '+40 702 061 248', 'sheridan.pagac@yahoo.com', to_date('15-Aug-1952', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('cedric_briggs', 'uC3SwQo', 'Cedric Briggs', '+40 732 357 692', 'ida.rolfson@gmail.com', to_date('18-Dec-1993', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jason_graves', 'EsYy1yM', 'JasON dw_manager.Graves', '+40 701 625 464', 'connie94@barrows.com', to_date('18-Jun-1988', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('rayna_soto', 'GrmU91U', 'Rayna Soto', '+40 702 068 623', 'bbernier@reilly.biz', to_date('13-Oct-1959', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('monserrat_guerrero', 'ZUS6Nvr', 'Monserrat Guerrero', '+40 702 073 070', 'hmohr@rippin.com', to_date('27-Dec-2003', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('esperanza_graves', 'atWg7AX', 'Esperanza Graves', '+40 709 337 485', 'emilie14@hotmail.com', to_date('9-Feb-1988', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaylyn_pennington', 'tYtk2Vj', 'Jaylyn Pennington', '+40 702 095 217', 'kathryne49@marvin.org', to_date('12-Apr-1956', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaylah_odonnell', 'tPElc8Q', 'Jaylah Odonnell', '+40 702 065 462', 'morissette.desiree@west.com', to_date('3-Apr-1986', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('virginia_kidd', 'adKWl9l', 'Virginia Kidd', '+40 708 343 989', 'jimmie94@yahoo.com', to_date('21-Nov-1965', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('sloane_fry', 'pJj9FP2', 'Sloane Fry', '+40 743 051 663', 'hailee.zieme@willms.com', to_date('20-Dec-1981', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('kennedi_copeland', 'Wp8BNLv', 'Kennedi Copeland', '+40 712 677 394', 'gaylord.olen@gutmann.com', to_date('2-Jan-1971', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('camila_washington', 'T2hD0tg', 'Camila Washington', '+40 785 783 547', 'amelie.green@hotmail.com', to_date('18-Jan-1981', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('carley_morrison', 'Xzew2Wo', 'Carley Morrison', '+40 702 097 247', 'pabshire@kuhlman.com', to_date('26-May-1961', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaslene_atkinson', 'm9Ri67A', 'Jaslene Atkinson', '+40 713 833 060', 'savanah38@gmail.com', to_date('7-Jun-1984', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('nash_lang', 'c3fONRu', 'Nash Lang', '+40 705 814 587', 'tanya77@price.com', to_date('17-Nov-1997', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('alana_archer', 'GqzO1tC', 'Alana Archer', '+40 702 069 453', 'wgleichner@yahoo.com', to_date('7-Jul-1982', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('ava_erickson', 'A5iZc27', 'Ava Erickson', '+40 787 863 978', 'lois.kub@gmail.com', to_date('11-Dec-1947', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('adeline_andrews', 'QCFm6SD', 'Adeline Andrews', '+40 702 078 423', 'khamill@gmail.com', to_date('23-May-1991', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jacob_hampton', 'Ke6xAmm', 'Jacob Hampton', '+40 711 291 606', 'west.karley@yahoo.com', to_date('30-Oct-1948', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('zaria_clay', 'bA3FrtH', 'Zaria Clay', '+40 711 488 956', 'goberbrunner@steuber.org', to_date('31-Jan-1944', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('sonny_mata', 'G6JCtl9', 'Sonny Mata', '+40 791 387 027', 'raoul29@kerluke.com', to_date('18-Jun-1986', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('cassius_santana', 'xg3r0Tg', 'Cassius Santana', '+40 708 851 799', 'fbosco@hoppe.com', to_date('1-Nov-1978', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('gabriela_leon', 'm4NbBoX', 'Gabriela Leon', '+40 702 045 388', 'ziemann.claire@hotmail.com', to_date('9-May-1970', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaylin_paul', 'xEX3llQ', 'Jaylin Paul', '+40 702 088 928', 'fiona.schoen@gmail.com', to_date('2-Jan-2003', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('josiah_peters', 'W0qXcvw', 'Josiah Peters', '+40 702 016 299', 'simonis.loyce@hotmail.com', to_date('25-Mar-1985', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('corey_carney', 'Rus8Kj5', 'Corey Carney', '+40 702 012 799', 'patsy.waters@sporer.com', to_date('26-Sep-1940', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('lila_atkins', 'V70IOut', 'Lila Atkins', '+40 791 325 722', 'bessie39@hotmail.com', to_date('30-Jan-1963', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaylen_perry', 'Wy9DwoP', 'Jaylen Perry', '+40 748 901 640', 'koepp.rocio@dietrich.biz', to_date('14-Oct-1953', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('aubrie_schmidt', 'gQumI7d', 'Aubrie Schmidt', '+40 700 189 759', 'else.koepp@hotmail.com', to_date('16-Nov-1940', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('matteo_morgan', 'QS2RaNc', 'Matteo Morgan', '+40 755 476 091', 'winfield.christiansen@skiles.com', to_date('8-Jun-1989', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('sarahi_bell', 'oM86wM5', 'Sarahi Bell', '+40 749 245 633', 'franco.douglas@yahoo.com', to_date('15-Jul-1977', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('noemi_medina', 'l2Kf3p2', 'Noemi Medina', '+40 702 098 923', 'mariana.kihn@schimmel.com', to_date('20-Jan-1965', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('javion_oconnell', 'D8IM4yx', 'JaviON dw_manager.Oconnell', '+40 702 068 499', 'harber.laurence@gmail.com', to_date('29-Mar-1940', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('annabel_terry', 'Ng7HU1v', 'Annabel Terry', '+40 720 295 327', 'benjamin.bogisich@hotmail.com', to_date('12-Aug-1957', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('cale_charles', 'Ju4fCBh', 'Cale Charles', '+40 704 538 584', 'miles.lueilwitz@yahoo.com', to_date('26-Apr-1984', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('makayla_house', 'OYj7rCd', 'Makayla House', '+40 708 960 068', 'swift.jasen@hotmail.com', to_date('30-Apr-1944', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('mareli_turner', 'PNZvh7v', 'Mareli Turner', '+40 702 067 479', 'aiyana03@schmeler.net', to_date('20-Mar-1967', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('melody_walter', 't9k0aKu', 'Melody Walter', '+40 702 027 312', 'gottlieb.theresia@hotmail.com', to_date('31-Jul-1942', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('deborah_berry', 'Zk4hdos', 'Deborah Berry', '+40 702 084 473', 'xerdman@wisoky.org', to_date('20-Nov-1997', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('tatiana_page', 'RSObk7h', 'Tatiana Page', '+40 708 075 296', 'hammes.precious@leffler.net', to_date('18-Mar-1983', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaiden_allen', 'XPO5zmM', 'Jaiden Allen', '+40 713 268 761', 'reynolds.una@gmail.com', to_date('8-Oct-1974', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('davis_schmitt', 'XiM6Td9', 'Davis Schmitt', '+40 702 099 746', 'jules66@yahoo.com', to_date('18-Apr-1941', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('desirae_young', 'sW2Kqzb', 'Desirae Young', '+40 702 075 789', 'davis.abe@johnson.com', to_date('7-Apr-1963', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('yandel_bass', 'wqG30NR', 'Yandel Bass', '+40 710 329 543', 'vince.oberbrunner@hotmail.com', to_date('29-Jun-2002', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('alani_stanley', 'gU08j1d', 'Alani Stanley', '+40 710 329 543', 'lila.reinger@hotmail.com', to_date('10-Mar-1983', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('marcos_hoover', 'D6fjhWs', 'Marcos Hoover', '+40 707 570 127', 'kaitlyn11@padberg.com', to_date('23-Dec-1969', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('logan_branch', 'ZogFB3q', 'Logan Branch', '+40 702 025 070', 'jarod.west@wiza.biz', to_date('19-Mar-1989', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jordan_black', 'J9hGEwU', 'Jordan Black', '+40 702 050 936', 'hdavis@armstrong.net', to_date('30-Sep-1994', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('silas_spears', 'C8gGRQt', 'Silas Spears', '+40 702 056 527', 'vivien11@abernathy.com', to_date('31-Jul-1956', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('maliyah_lester', 'RQ9sDQs', 'Maliyah Lester', '+40 705 574 045', 'berniece.langworth@wunsch.net', to_date('3-Jun-2000', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('alma_kennedy', 'Ky8lCQL', 'Alma Kennedy', '+40 799 106 864', 'kertzmann.shania@ohara.com', to_date('18-May-1986', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('franco_crosby', 'k42eVX0', 'Franco Crosby', '+40 701 076 313', 'lucas.breitenberg@kautzer.org', to_date('4-Apr-1941', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jaquan_walton', 'lkSP08d', 'Jaquan Walton', '+40 790 607 284', 'anderson.guiseppe@yahoo.com', to_date('2-Oct-1979', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('harley_sampson', 'GDf2oCK', 'Harley Sampson', '+40 710 148 232', 'hegmann.moshe@little.info', to_date('14-Apr-1972', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('vincent_lucas', 'AH0qXbg', 'Vincent Lucas', '+40 710 069 696', 'oroberts@gmail.com', to_date('21-Apr-1972', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('rosemary_bridges', 'b7qXpBh', 'Rosemary Bridges', '+40 774 265 596', 'eichmann.graciela@lindgren.com', to_date('10-Oct-1954', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('waylon_fields', 'AMgF6lR', 'WaylON dw_manager.Fields', '+40 702 015 621', 'abshire.daisy@pfannerstill.net', to_date('17-Nov-1957', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('kenneth_gamble', 'BPl1h3f', 'Kenneth Gamble', '+40 702 077 044', 'shields.wilfred@yahoo.com', to_date('10-Nov-1963', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('diamond_pruitt', 'xSvj43t', 'Diamond Pruitt', '+40 702 052 018', 'qhowe@gmail.com', to_date('4-Apr-1960', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('emmy_pacheco', 'wBGr2zp', 'Emmy Pacheco', '+40 713 933 649', 'elmira25@gerlach.com', to_date('10-Apr-1977', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('joe_glenn', 'GrR4D7v', 'Joe Glenn', '+40 702 035 106', 'tromp.noe@hotmail.com', to_date('6-Mar-1988', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('camryn_rush', 'Uhcx65j', 'Camryn Rush', '+40 702 040 652', 'katrina.wiza@gmail.com', to_date('11-Mar-1989', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('sylvia_gardner', 'Jq5SbDH', 'Sylvia Gardner', '+40 708 387 457', 'germaine.pacocha@yahoo.com', to_date('16-Apr-1964', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('emelia_rocha', 'ExB04iU', 'Emelia Rocha', '+40 702 096 588', 'schneider.deangelo@hotmail.com', to_date('19-Jun-1959', 'DD-MON-RR'), 'female', 'casatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('tatiana_hendrix', 'LICmx4W', 'Tatiana Hendrix', '+40 785 199 338', 'alanis36@rath.com', to_date('15-Jun-1957', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('jeremy_mckay', 'Y8eqLnS', 'Jeremy Mckay', '+40 702 045 809', 'rice.miles@gmail.com', to_date('23-Aug-1978', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('gideon_hooper', 'rL39mA2', 'GideON dw_manager.Hooper', '+40 702 028 703', 'kade.hettinger@hotmail.com', to_date('21-Apr-1998', 'DD-MON-RR'), 'male', 'necasatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('nathan_lamb', 'UdAhH3F', 'Nathan Lamb', '+40 713 618 820', 'trippin@hotmail.com', to_date('4-Aug-1968', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('colin_walter', 'JONYc9S', 'Colin Walter', '+40 791 874 334', 'otha.kuhlman@lowe.net', to_date('21-Aug-1963', 'DD-MON-RR'), 'male', 'casatorit ');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('antwan_huffman', 'APyD01K', 'Antwan Huffman', '+40 712 305 048', 'jamar.witting@gmail.com', to_date('2-Mar-1944', 'DD-MON-RR'), 'female', 'necasatorita');

INSERT INTO dw_manager.utilizator (NUME_utilizator, HASH_PAROLA, NUME_COMPLET, TELEFON, EMAIL, DATA_NASTERII, GEN, STARE_CIVILA) VALUES ('stella_nunez', 'L3S1qx6', 'Stella Nunez', '+40 702 081 211', 'kylie.mccullough@hudson.info', to_date('23-Aug-1944', 'DD-MON-RR'), 'female', 'necasatorita');


---Inserarea datelor in tabelul rezervare(dependent de utilizator)---

INSERT INTO dw_manager.rezervare (id_client, data_inceput, data_sfarsit) VALUES (89, to_date('2-Jul-2023', 'DD-MON-RR'), to_date('9-Jul-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (49, to_date('4-Feb-2025', 'DD-MON-RR'), to_date('13-Feb-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (4, to_date('24-Apr-2023', 'DD-MON-RR'), to_date('27-Apr-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (67, to_date('18-Nov-2023', 'DD-MON-RR'), to_date('26-Nov-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (49, to_date('11-Aug-2023', 'DD-MON-RR'), to_date('22-Aug-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (40, to_date('16-Jun-2025', 'DD-MON-RR'), to_date('17-Jun-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (20, to_date('10-Feb-2024', 'DD-MON-RR'), to_date('14-Feb-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (34, to_date('17-Feb-2025', 'DD-MON-RR'), to_date('27-Feb-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (71, to_date('28-Jun-2024', 'DD-MON-RR'), to_date('3-Jul-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (21, to_date('13-Jul-2025', 'DD-MON-RR'), to_date('18-Jul-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (44, to_date('18-Sep-2025', 'DD-MON-RR'), to_date('29-Sep-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (81, to_date('12-Apr-2025', 'DD-MON-RR'), to_date('21-Apr-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (37, to_date('15-May-2025', 'DD-MON-RR'), to_date('21-May-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (38, to_date('5-Sep-2024', 'DD-MON-RR'), to_date('11-Sep-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (91, to_date('27-Jan-2024', 'DD-MON-RR'), to_date('28-Jan-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (7, to_date('8-Feb-2023', 'DD-MON-RR'), to_date('14-Feb-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (88, to_date('1-Apr-2024', 'DD-MON-RR'), to_date('7-Apr-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (60, to_date('14-Aug-2024', 'DD-MON-RR'), to_date('23-Aug-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (14, to_date('28-Sep-2023', 'DD-MON-RR'), to_date('2-Oct-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (86, to_date('11-Nov-2024', 'DD-MON-RR'), to_date('21-Nov-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (15, to_date('20-Apr-2025', 'DD-MON-RR'), to_date('26-Apr-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (81, to_date('13-Jul-2024', 'DD-MON-RR'), to_date('20-Jul-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (70, to_date('11-Dec-2025', 'DD-MON-RR'), to_date('18-Dec-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (33, to_date('6-Jun-2023', 'DD-MON-RR'), to_date('7-Jun-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (73, to_date('25-Jan-2025', 'DD-MON-RR'), to_date('4-Feb-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (76, to_date('19-Apr-2023', 'DD-MON-RR'), to_date('25-Apr-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (70, to_date('8-Nov-2025', 'DD-MON-RR'), to_date('15-Nov-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (61, to_date('6-Jun-2024', 'DD-MON-RR'), to_date('14-Jun-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (36, to_date('27-Aug-2024', 'DD-MON-RR'), to_date('3-Sep-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (21, to_date('17-Mar-2024', 'DD-MON-RR'), to_date('24-Mar-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (30, to_date('21-Nov-2023', 'DD-MON-RR'), to_date('27-Nov-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (30, to_date('6-Jun-2025', 'DD-MON-RR'), to_date('13-Jun-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (59, to_date('23-Jan-2025', 'DD-MON-RR'), to_date('3-Feb-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (80, to_date('5-Nov-2023', 'DD-MON-RR'), to_date('6-Nov-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (17, to_date('24-Dec-2024', 'DD-MON-RR'), to_date('25-Dec-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (95, to_date('16-Jan-2025', 'DD-MON-RR'), to_date('23-Jan-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (54, to_date('3-Jun-2025', 'DD-MON-RR'), to_date('7-Jun-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (22, to_date('22-Jul-2024', 'DD-MON-RR'), to_date('1-Aug-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (82, to_date('4-Mar-2024', 'DD-MON-RR'), to_date('6-Mar-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (96, to_date('30-Oct-2024', 'DD-MON-RR'), to_date('31-Oct-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (8, to_date('3-Dec-2024', 'DD-MON-RR'), to_date('7-Dec-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (73, to_date('23-May-2025', 'DD-MON-RR'), to_date('27-May-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (6, to_date('29-Apr-2023', 'DD-MON-RR'), to_date('8-May-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (15, to_date('28-Apr-2024', 'DD-MON-RR'), to_date('29-Apr-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (21, to_date('1-Mar-2025', 'DD-MON-RR'), to_date('11-Mar-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (26, to_date('8-Aug-2023', 'DD-MON-RR'), to_date('17-Aug-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (36, to_date('4-Oct-2024', 'DD-MON-RR'), to_date('7-Oct-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (3, to_date('11-May-2023', 'DD-MON-RR'), to_date('16-May-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (4, to_date('1-Jul-2024', 'DD-MON-RR'), to_date('10-Jul-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (34, to_date('15-Feb-2025', 'DD-MON-RR'), to_date('17-Feb-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (42, to_date('11-Apr-2024', 'DD-MON-RR'), to_date('21-Apr-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (88, to_date('17-Dec-2023', 'DD-MON-RR'), to_date('20-Dec-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (79, to_date('23-Apr-2024', 'DD-MON-RR'), to_date('4-May-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (63, to_date('12-Dec-2023', 'DD-MON-RR'), to_date('15-Dec-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (19, to_date('26-Jun-2025', 'DD-MON-RR'), to_date('29-Jun-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (51, to_date('22-May-2025', 'DD-MON-RR'), to_date('31-May-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (22, to_date('2-Jul-2023', 'DD-MON-RR'), to_date('7-Jul-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (89, to_date('7-Jul-2024', 'DD-MON-RR'), to_date('18-Jul-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (32, to_date('19-Jun-2024', 'DD-MON-RR'), to_date('30-Jun-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (2, to_date('23-Nov-2024', 'DD-MON-RR'), to_date('25-Nov-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (78, to_date('8-Apr-2024', 'DD-MON-RR'), to_date('19-Apr-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (21, to_date('8-Jun-2024', 'DD-MON-RR'), to_date('16-Jun-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (20, to_date('8-Dec-2025', 'DD-MON-RR'), to_date('15-Dec-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (90, to_date('14-Oct-2023', 'DD-MON-RR'), to_date('25-Oct-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (4, to_date('5-Nov-2023', 'DD-MON-RR'), to_date('6-Nov-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (59, to_date('28-Jun-2023', 'DD-MON-RR'), to_date('3-Jul-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (94, to_date('10-May-2024', 'DD-MON-RR'), to_date('11-May-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (25, to_date('20-Dec-2025', 'DD-MON-RR'), to_date('22-Dec-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (86, to_date('22-Jun-2023', 'DD-MON-RR'), to_date('26-Jun-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (23, to_date('17-Sep-2023', 'DD-MON-RR'), to_date('19-Sep-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (80, to_date('23-Apr-2023', 'DD-MON-RR'), to_date('25-Apr-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (72, to_date('9-Jul-2023', 'DD-MON-RR'), to_date('17-Jul-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (83, to_date('10-Jul-2023', 'DD-MON-RR'), to_date('17-Jul-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (46, to_date('13-Jul-2024', 'DD-MON-RR'), to_date('14-Jul-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (59, to_date('30-Jul-2024', 'DD-MON-RR'), to_date('4-Aug-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (52, to_date('26-Mar-2025', 'DD-MON-RR'), to_date('6-Apr-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (97, to_date('11-Jan-2024', 'DD-MON-RR'), to_date('15-Jan-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (94, to_date('7-Jul-2024', 'DD-MON-RR'), to_date('18-Jul-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (4, to_date('3-Jan-2024', 'DD-MON-RR'), to_date('13-Jan-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (93, to_date('6-Nov-2023', 'DD-MON-RR'), to_date('9-Nov-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (1, to_date('8-Nov-2024', 'DD-MON-RR'), to_date('16-Nov-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (7, to_date('15-Jan-2024', 'DD-MON-RR'), to_date('17-Jan-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (69, to_date('18-May-2023', 'DD-MON-RR'), to_date('23-May-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (60, to_date('27-Oct-2023', 'DD-MON-RR'), to_date('1-Nov-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (56, to_date('7-Feb-2023', 'DD-MON-RR'), to_date('13-Feb-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (64, to_date('8-Jan-2025', 'DD-MON-RR'), to_date('19-Jan-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (96, to_date('19-Jun-2025', 'DD-MON-RR'), to_date('30-Jun-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (22, to_date('11-Sep-2023', 'DD-MON-RR'), to_date('17-Sep-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (42, to_date('17-Nov-2025', 'DD-MON-RR'), to_date('22-Nov-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (95, to_date('12-Jun-2024', 'DD-MON-RR'), to_date('23-Jun-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (14, to_date('30-Mar-2025', 'DD-MON-RR'), to_date('8-Apr-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (45, to_date('31-Jul-2024', 'DD-MON-RR'), to_date('11-Aug-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (67, to_date('19-Jan-2025', 'DD-MON-RR'), to_date('21-Jan-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (45, to_date('20-Aug-2023', 'DD-MON-RR'), to_date('29-Aug-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (32, to_date('29-May-2024', 'DD-MON-RR'), to_date('30-May-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (43, to_date('29-Jan-2025', 'DD-MON-RR'), to_date('1-Feb-2025', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (27, to_date('31-Dec-2023', 'DD-MON-RR'), to_date('4-Jan-2024', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (86, to_date('10-Mar-2023', 'DD-MON-RR'), to_date('14-Mar-2023', 'DD-MON-RR'));

INSERT INTO dw_manager.rezervare (ID_CLIENT, DATA_INCEPUT, DATA_SFARSIT) VALUES (99, to_date('9-Dec-2023', 'DD-MON-RR'), to_date('20-Dec-2023', 'DD-MON-RR'));


----------------------------------------------
---Inserarea datelor in tabelul atribuie---


INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (95, 167);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (93, 54);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (47, 140);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (93, 71);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (10, 154);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (4, 120);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (48, 115);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (17, 185);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (38, 159);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (22, 153);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (51, 82);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (59, 125);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (51, 35);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (6, 47);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (20, 96);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (49, 6);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (65, 123);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (8, 175);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (40, 99);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (92, 73);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (77, 100);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (98, 159);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (68, 49);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (81, 74);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (63, 69);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (5, 131);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (72, 43);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (56, 127);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (83, 29);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (71, 59);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (34, 144);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (79, 128);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (91, 86);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (24, 187);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (51, 145);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (51, 182);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (10, 34);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (99, 139);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (69, 28);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (13, 66);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (95, 148);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (78, 70);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (51, 105);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (31, 27);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (86, 15);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (14, 7);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (60, 117);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (36, 199);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (61, 167);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (82, 161);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (95, 159);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (1, 34);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (52, 97);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (12, 61);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (32, 32);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (96, 67);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (26, 84);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (1, 33);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (82, 165);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (60, 6);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (47, 105);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (77, 154);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (2, 116);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (48, 55);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (28, 24);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (10, 27);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (91, 184);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (94, 71);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (80, 88);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (15, 117);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (84, 197);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (82, 48);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (95, 102);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (90, 181);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (27, 39);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (79, 155);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (64, 23);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (72, 149);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (91, 60);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (23, 124);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (43, 183);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (82, 94);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (45, 123);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (22, 51);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (36, 16);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (13, 99);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (6, 41);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (57, 179);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (52, 178);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (97, 32);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (13, 102);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (96, 113);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (87, 121);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (77, 98);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (28, 169);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (18, 4);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (72, 55);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (93, 98);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (46, 93);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (47, 143);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (87, 139);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (6, 140);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (12, 138);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (85, 103);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (3, 96);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (53, 193);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (68, 127);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (77, 36);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (33, 163);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (92, 12);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (11, 42);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (78, 189);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (65, 173);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (71, 93);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (26, 135);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (61, 41);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (20, 156);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (76, 138);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (30, 154);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (32, 86);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (52, 4);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (94, 30);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (60, 26);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (91, 135);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (41, 37);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (12, 50);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (25, 134);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (66, 32);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (77, 160);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (43, 27);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (57, 157);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (77, 43);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (84, 192);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (20, 191);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (12, 131);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (92, 67);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (61, 16);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (64, 2);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (65, 53);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (32, 139);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (15, 12);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (92, 64);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (12, 101);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (22, 11);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (8, 99);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (69, 87);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (88, 103);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (36, 194);

INSERT INTO dw_manager.atribuie (ID_rezervare, ID_camera) VALUES (38, 77);




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
--GRANT UPDATE ON dw_manager.dw_manager. dw_manager.rezervare TO dw_admin;
--sau daca dorim sa nu mai folosim anumite privilegii precum cel de mai putem folosi comanda
--REVOKE DELETE ON dw_manager.dw_manager. dw_manager.rezervare FROM dw_admin;

--pentru a accesa un tabel trebuie sa folosim dw_manager.nume_tabel deoarece altfel nu merge

-- iar ultimul tip de utilizator este cel cel de utilizator care are 
-- posibilitatea sa vizualizeze dw_manager.hotelurile si sa introduce date in rezervari.
-- acesta nu avea acces la baza de date.


--ca si SYS putem rula urmatoarea cerere pentru a vizualiza care sunt care sunt privilegiile oferite
SELECT substr(grantee,1,20) grantee, owner,substr(table_name,1,15) table_name, grantor, privilege
FROM DBA_TAB_PRIVS
WHERE grantee like 'DW_%';

--cu aceasta comanda putem vedea doar privilegiile mai restrictive.

-- ALTER USER marius QUOTA UNLIMITED ON dw_manager.USERS;
exit;

--Baza noastra de date OLTP va avea 3 tipuri de utilizatori in aplicatie

-- utilizatorul manager care va introduce schema si cu toate datele din aplicatie.
-- acesta va avea acces la toate datele din schema oltp prin SELECT,UPDATE,DELETE,INSERT
-- Managerul are posibilitatea de a introduce rezervari,modifica utilizatori, update pe rezervari. 
-- Practic are acces sa faca tot ce vrea pe schema
-- acesta va avea acces si in olap pentru a vizualiza rapoartele scoase dar 
--si de a modifica datele din tabele dupa propriul interes.

-- show con_name;
-- alter sessiON dw_manager.set container= orclpdb1;
-- show con_name;
-- ALTER PLUGGABLE DATABASE orclpdb1 open;



--Pentru a vizualiza privilegiile adaugate putem folosi aceasta cerere asupra utlizatorului creat.
