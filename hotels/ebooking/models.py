from django.db import models

# Create your models here.

class Atribuie(models.Model):
    id_rezervare = models.OneToOneField('Rezervare', models.DO_NOTHING, db_column='id_rezervare', primary_key=True)
    id_camera = models.OneToOneField('Camera', models.DO_NOTHING, db_column='id_camera')

    class Meta:
        # managed = False
        db_table = 'atribuie'
        unique_together = (('id_rezervare', 'id_camera'),)



class Camera(models.Model):
    id_camera = models.FloatField(primary_key=True, blank=True)
    id_hotel = models.FloatField()
    nr_camera = models.FloatField(blank=True, null=True)
    nr_etaj = models.FloatField(blank=True, null=True)
    nr_paturi_duble = models.FloatField()
    nr_paturi_simple = models.FloatField()
    are_terasa = models.BooleanField()
    are_televizor = models.BooleanField()
    pret_per_noapte = models.FloatField()

    def __str__(self) -> str:
        return "Camera " + str(self.id_camera)

    class Meta:
        # managed = False
        db_table = 'camera'

    def _do_insert(self, manager, using, fields, update_pk, raw):
        fields = [
            f for f in fields if f.attname not in ['id_camera']
        ]
        return super()._do_insert(manager, using, fields, update_pk, raw)

    def _do_update(self, base_qs, using, pk_val, values, update_fields, forced_update):
        values = [
            value for value in values if value[0].attname not in ['id_camera']
        ]
        return super()._do_update(base_qs, using, pk_val, values, update_fields, forced_update)    




class Hotel(models.Model):
    id_hotel = models.FloatField(primary_key=True, blank=True)
    nume = models.CharField(max_length=50)
    nr_stele = models.FloatField()
    id_zona = models.ForeignKey('Zona', models.DO_NOTHING, db_column='id_zona')
    are_mic_dejun_inclus = models.BooleanField()

    class Meta:
        # managed = False
        db_table = 'hotel'

    def _do_insert(self, manager, using, fields, update_pk, raw):
        fields = [
            f for f in fields if f.attname not in ['id_hotel']
        ]
        return super()._do_insert(manager, using, fields, update_pk, raw)

    def _do_update(self, base_qs, using, pk_val, values, update_fields, forced_update):
        values = [
            value for value in values if value[0].attname not in ['id_hotel']
        ]
        return super()._do_update(base_qs, using, pk_val, values, update_fields, forced_update)

    def __str__(self) -> str:
        return "Hotel " + str(self.id_hotel)        


class Rezervare(models.Model):
    id_rezervare = models.FloatField(primary_key=True, blank=True)
    id_client = models.FloatField()
    data_inceput = models.DateField()
    data_sfarsit = models.DateField()

    class Meta:
        # managed = False
        db_table = 'rezervare'

    def _do_insert(self, manager, using, fields, update_pk, raw):
        fields = [
            f for f in fields if f.attname not in ['id_rezervare']
        ]
        return super()._do_insert(manager, using, fields, update_pk, raw)

    def _do_update(self, base_qs, using, pk_val, values, update_fields, forced_update):
        values = [
            value for value in values if value[0].attname not in ['id_rezervare']
        ]
        return super()._do_update(base_qs, using, pk_val, values, update_fields, forced_update)    

    def __str__(self) -> str:
        return "Rezervare " + str(self.id_rezervare)  


class Utilizator(models.Model):
    id_utilizator = models.FloatField(primary_key=True, blank=True)
    nume_utilizator = models.CharField(max_length=30)
    hash_parola = models.CharField(max_length=25)
    nume_complet = models.CharField(max_length=30)
    telefon = models.CharField(max_length=15)
    email = models.CharField(max_length=50)
    data_nasterii = models.DateField()
    gen = models.CharField(max_length=20, blank=True, null=True)
    stare_civila = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        # managed = False
        db_table = 'utilizator'

    def _do_insert(self, manager, using, fields, update_pk, raw):
        fields = [
            f for f in fields if f.attname not in ['id_utilizator']
        ]
        return super()._do_insert(manager, using, fields, update_pk, raw)

    def _do_update(self, base_qs, using, pk_val, values, update_fields, forced_update):
        values = [
            value for value in values if value[0].attname not in ['id_utilizator']
        ]
        return super()._do_update(base_qs, using, pk_val, values, update_fields, forced_update)    

    def __str__(self) -> str:
        return "Utilizator " + str(self.id_utilizator)     

class Zona(models.Model):
    id_zona = models.FloatField(primary_key=True, blank=True)
    judet = models.CharField(max_length=50)
    localitate = models.CharField(max_length=50)
    pozitie = models.CharField(max_length=50)

    class Meta:
        # managed = False
        db_table = 'zona'

    def _do_insert(self, manager, using, fields, update_pk, raw):
        fields = [
            f for f in fields if f.attname not in ['id_zona']
        ]
        return super()._do_insert(manager, using, fields, update_pk, raw)

    def _do_update(self, base_qs, using, pk_val, values, update_fields, forced_update):
        values = [
            value for value in values if value[0].attname not in ['id_zona']
        ]
        return super()._do_update(base_qs, using, pk_val, values, update_fields, forced_update)

    def __str__(self) -> str:
        return "Zona " + str(self.id_zona)        