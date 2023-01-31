from django.shortcuts import render
from .models import *

# Create your views here.

from django.db import connection

def stats(request):
    labels = []
    data = []
    bar_labels = []
    bar_data = []

    with connection.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM REZERVARE WHERE EXTRACT(MONTH FROM data_inceput) IN (1,4)")
        first_3_months = cursor.fetchone()
        cursor.execute("SELECT COUNT(*) FROM REZERVARE WHERE EXTRACT(MONTH FROM data_inceput) IN (4,7)")
        first_6_months = cursor.fetchone()
        cursor.execute("SELECT COUNT(*) FROM REZERVARE WHERE EXTRACT(MONTH FROM data_inceput) IN (7,10)")
        first_9_months = cursor.fetchone()
        cursor.execute("SELECT COUNT(*) FROM REZERVARE WHERE EXTRACT(MONTH FROM data_inceput) IN (10,1)")
        first_12_months = cursor.fetchone()


    labels.extend(['ianuarie-martie','aprilie-iunie', 'iulie-septembrie','octombrie-decembrie'])
    data.extend([first_3_months[0], first_6_months[0], first_9_months[0], first_12_months[0]])

    print("LABELS:", labels)
    print("DATa :", data)

    # *** Most expensive hotels ***


    with connection.cursor() as cursor:
        cursor.execute("select DISTINCT hotel.nume, camera.pret_per_noapte from hotel INNER JOIN camera on camera.id_hotel = hotel.id_hotel order by camera.pret_per_noapte desc fetch first 5 rows only;")
        most_expensive = cursor.fetchall()
 
    print("MOST EXPENSIVE: ", most_expensive)

    for hotel in most_expensive:
        bar_labels.append(hotel[0])
        bar_data.append(hotel[1])

    return render(request, 'stats.html', {
        'labels': labels,
        'data': data,
        'bar_labels': bar_labels,
        'bar_data': bar_data,
    })
