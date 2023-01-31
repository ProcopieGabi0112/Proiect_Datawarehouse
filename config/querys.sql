1*  - Cea mai scumpa camera per noapte  din romania 


select max(pret_per_noapte) from
(select hotel.nume,camera.pret_per_noapte from hotel
INNER JOIN camera
on camera.id_hotel = hotel.id_hotel
order by hotel.nume)


2* Cea mai ieftina camera dintr-o zona centrala

select * from (select hotel.nume, MIN(pret_per_noapte) from camera 
INNER JOIN hotel
on hotel.id_hotel=camera.id_hotel
INNER JOIN zona
on zona.id_zona = hotel.id_zona
WHERE zona.pozitie = 'centrala'
GROUP BY hotel.nume) 
where rownum = 1


3* Hotelul cu cele mai multe rezervari efectuate 

select * from(
SELECT MAX(rezervari) as mres, numes  FROM (SELECT  hotel.nume as numes,COUNT(atribuie.id_rezervare) as rezervari from atribuie
inner join camera
on camera.id_camera=atribuie.id_camera
inner join hotel
on hotel.id_hotel = camera.id_hotel
GROUP BY hotel.nume) 
group by numes
ORDER BY mres DESC
)
where rownum=1;

4* Cele mai scumpe 5 hoteluri
select DISTINCT hotel.nume,camera.pret_per_noapte from hotel
INNER JOIN camera
on camera.id_hotel = hotel.id_hotel
order by camera.pret_per_noapte desc
fetch first 5 rows only;

5* Rezezrvari in functie de luna anului

SELECT COUNT(*) FROM REZERVARE
WHERE EXTRACT(MONTH FROM data_inceput) IN (1,4)
SELECT COUNT(*) FROM REZERVARE
WHERE EXTRACT(MONTH FROM data_inceput) IN (4, 7)
SELECT COUNT(*) FROM REZERVARE
WHERE EXTRACT(MONTH FROM data_inceput) IN (7, 10)
SELECT COUNT(*) FROM REZERVARE
WHERE EXTRACT(MONTH FROM data_inceput) IN (10, 1)
