from django.http import HttpResponse
from django.shortcuts import render
from django.db import connection

# Create your views here.

def show_favorite(request):
    logged_in_username = request.session.get('username')
    if logged_in_username:
            with connection.cursor() as cursor:
                cursor.execute(f"""
                               SELECT df.judul, df.timestamp
                               FROM "DAFTAR_FAVORIT" df
                               JOIN
                                "TAYANGAN_MEMILIKI_DAFTAR_FAVORIT" tmf ON df.timestamp = tmf.timestamp AND df.username = tmf.username
                                WHERE
                                df.username = '{logged_in_username}'
                               """)
                tayangan_favoritnya = cursor.fetchall()
                judul_daftar_favorit = []
                timestamp_daftar_favorit = []
                for row in tayangan_favoritnya:
                    judul_daftar_favorit.append(row[0])
                    timestamp_daftar_favorit.append(row[1])
                detail_daftar_favorit = zip(judul_daftar_favorit, timestamp_daftar_favorit)
                context = {
                    'detail_daftar_favorit': detail_daftar_favorit
                }
                return render(request, 'daftar_favorit.html', context)

def show_film_in_daftar_favorit(request, judul):
    logged_in_username = request.session.get('username')
    if logged_in_username:
        with connection.cursor() as cursor:
            cursor.execute(f"""
                           SELECT t.judul, t.id
                           FROM "TAYANGAN" t
                           JOIN
                            "TAYANGAN_MEMILIKI_DAFTAR_FAVORIT" tmf ON t.id = tmf.id_tayangan
                            JOIN
                            "DAFTAR_FAVORIT" df ON tmf.timestamp = df.timestamp AND tmf.username = df.username
                            WHERE
                            df.username = '{logged_in_username}' AND df.judul = '{judul}'
                           """)
            list_tayangan = cursor.fetchall()
            print(list_tayangan)
            judul_film = []
            id_film = []
            for row in list_tayangan:
                judul_film.append(row[0])
                id_film.append(row[1])
            detail_tayangan_di_daftar = zip(judul_film, id_film)
            context = {
                'judul_daftar_favorit': judul,
                'detail_tayangan_di_daftar': detail_tayangan_di_daftar
            }
            return render(request, 'detail_daftar_favorit.html', context)

    else:
        return HttpResponse('User not authenticated', status=401)

def delete_from_favorite(request, judul_daftar_favorit, id):
    with connection.cursor() as cursor:
        logged_in_username = request.session.get('username')
        cursor.execute(f"""DELETE FROM "TAYANGAN_MEMILIKI_DAFTAR_FAVORIT"
                           WHERE id_tayangan = '{id}'
                           AND username = '{logged_in_username}'
                           AND TIMESTAMP = (SELECT TIMESTAMP FROM "DAFTAR_FAVORIT" WHERE JUDUL = '{judul_daftar_favorit}' AND USERNAME = '{logged_in_username}')
                           """)
        return HttpResponse('Deleted from favorite', status=200)
