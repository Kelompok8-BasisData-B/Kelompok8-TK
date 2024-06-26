from django.http import HttpResponse, HttpResponseBadRequest, JsonResponse
from django.shortcuts import render
from django.contrib import messages
from django.db import connection, InternalError
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render
from django.urls import reverse
from function.general import *
from urllib.parse import quote
import datetime

def show_trailer(request):
    if 'username' in request.session and 'username' in request.COOKIES:
        return redirect('tayangan:show_tayangan')

    top_10 = query_result(f"""WITH durasi_tayangan AS (
                            SELECT T.id AS id, F.durasi_film AS durasi
                            FROM "TAYANGAN" AS T
                            JOIN "FILM" AS F ON F.id_tayangan = T.id
                            UNION
                            SELECT T.id AS id, SUM(E.durasi) AS durasi
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id
                            JOIN "EPISODE" AS E on E.id_series = T.id
                            GROUP BY T.id
                        ), recent_views AS (
                            SELECT T.id AS id, EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60 AS watch_time
                            FROM "TAYANGAN" AS T 
                            JOIN "FILM" AS F ON F.id_tayangan = T.id
                            JOIN "RIWAYAT_NONTON" AS RW ON RW.id_tayangan = T.id
                            WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS'
                            UNION
                            SELECT T.id AS id, SUM(EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60) AS watch_time
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id
                            JOIN "EPISODE" AS E ON E.id_series = T.id
                            JOIN "RIWAYAT_NONTON" AS RW ON RW.id_tayangan = T.id
                            WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS'
                            GROUP BY T.id, RW.username
                        )
                        
                        SELECT T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer, COUNT(*) as total_view
                        FROM "TAYANGAN" AS T
                        JOIN "durasi_tayangan" AS DT ON DT.id = T.id
                        JOIN "recent_views" AS RV ON RV.id = T.id
                        WHERE RV.watch_time > (0.7 * DT.durasi)
                        GROUP BY T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                        ORDER BY total_view DESC, T.judul ASC
                        LIMIT 10;""")

    film = query_result(f"""SELECT T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                            FROM "TAYANGAN" AS T
                            JOIN "FILM" AS F ON F.id_tayangan = T.id;""")

    series = query_result(f"""SELECT T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id;""")

    rank = 1
    for i in top_10:
        i['rank'] = rank
        rank += 1

    context = {
        "film": film,
        "series": series,
        "top_10": top_10
    }

    return render(request, 'daftar_trailer.html', context)

def show_tayangan(request):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')
    
    top_10 = query_result(f"""WITH durasi_tayangan AS (
                            SELECT T.id AS id, F.durasi_film AS durasi
                            FROM "TAYANGAN" AS T
                            JOIN "FILM" AS F ON F.id_tayangan = T.id
                            UNION
                            SELECT T.id AS id, AVG(E.durasi) AS durasi
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id
                            JOIN "EPISODE" AS E on E.id_series = T.id
                            GROUP BY T.id
                        ), recent_views AS (
                            SELECT T.id AS id, EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60 AS watch_time
                            FROM "TAYANGAN" AS T 
                            JOIN "FILM" AS F ON F.id_tayangan = T.id
                            JOIN "RIWAYAT_NONTON" AS RW ON RW.id_tayangan = T.id
                            WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS'
                            UNION
                            SELECT T.id AS id, EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60 AS watch_time
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id
                            JOIN "EPISODE" AS E ON E.id_series = T.id
                            JOIN "RIWAYAT_NONTON" AS RW ON RW.id_tayangan = T.id
                            WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS'
                        )
                        
                        SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer, COUNT(*) as total_view
                        FROM "TAYANGAN" AS T
                        JOIN "durasi_tayangan" AS DT ON DT.id = T.id
                        JOIN "recent_views" AS RV ON RV.id = T.id
                        WHERE RV.watch_time > (0.7 * DT.durasi)
                        GROUP BY T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                        ORDER BY total_view DESC, T.judul ASC
                        LIMIT 10;""")
    
    film = query_result(f"""SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                            FROM "TAYANGAN" AS T
                            JOIN "FILM" AS F ON F.id_tayangan = T.id;""")

    series = query_result(f"""SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id;""")

    paket = query_result(f"""SELECT
                                CASE
                                    WHEN MAX(end_date_time) > CURRENT_DATE THEN 1
                                    ELSE 0
                                END AS is_valid
                            FROM "TRANSACTION"
                            WHERE username = '{request.COOKIES.get('username')}';""")

    rank = 1
    for i in top_10:
        i['rank'] = rank
        rank += 1

    context = {
        "film": film,
        "series": series,
        "top_10": top_10,
        "paket": paket[0]
    }

    return render(request, 'daftar_tayangan.html', context)

def show_hasil_pencarian_trailer(request, value):
    checked_value = check_string_valid(value)
    tayangan = query_result(f"""SELECT judul, sinopsis_trailer, url_video_trailer, release_date_trailer
                                FROM "TAYANGAN"
                                WHERE judul ILIKE '%{checked_value}%';""")   

    context = {"tayangan": tayangan,
                "searchvalue": value}

    return render(request, 'hasil_pencarian_trailer.html', context)

def show_hasil_pencarian_tayangan(request, value):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')
    
    checked_value = check_string_valid(value)
    tayangan = query_result(f"""SELECT id, judul, sinopsis_trailer, url_video_trailer, release_date_trailer
                                FROM "TAYANGAN"
                                WHERE judul ILIKE '%{checked_value}%';""")
    
    paket = query_result(f"""SELECT
                                 CASE
                                     WHEN MAX(end_date_time) > CURRENT_DATE THEN 1
                                     ELSE 0
                                 END AS is_valid
                             FROM "TRANSACTION"
                             WHERE username = '{request.COOKIES.get('username')}';""")
    
    context = {"tayangan": tayangan,
               "searchvalue": value,
               "paket": paket[0]}

    return render(request, 'hasil_pencarian_tayangan.html', context)

def show_film(request, id):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')

    film = query_result(f"""SELECT T.id, T.judul, T.sinopsis, T.asal_negara, F.url_video_film, F.release_date_film, F.durasi_film, G.genre, C.nama AS nama_sutradara
                              FROM "FILM" AS F
                              JOIN "TAYANGAN" AS T ON T.id = F.id_tayangan
                              LEFT JOIN "GENRE_TAYANGAN" AS G ON G.id_tayangan = F.id_tayangan
                              JOIN "CONTRIBUTORS" AS C ON C.id = T.id_sutradara
                              WHERE F.id_tayangan = '{id}';""")

    pemain = query_result(f"""SELECT C.nama
                              FROM "FILM" AS F
                              JOIN "MEMAINKAN_TAYANGAN" AS MT ON MT.id_tayangan = F.id_tayangan
                              JOIN "CONTRIBUTORS" AS C ON C.id = MT.id_pemain
                              WHERE F.id_tayangan = '{id}';""")
    
    penulis = query_result(f"""SELECT C.nama
                              FROM "FILM" AS F
                              JOIN "MENULIS_SKENARIO_TAYANGAN" AS MST ON MST.id_tayangan = F.id_tayangan
                              JOIN "CONTRIBUTORS" AS C ON C.id = MST.id_penulis_skenario
                              WHERE F.id_tayangan = '{id}';""")
    
    view = query_result(f"""SELECT COUNT(id_tayangan)
                            FROM "RIWAYAT_NONTON"
                            WHERE id_tayangan = '{id}';""")
    
    rating = query_result(f"""SELECT ROUND(AVG(rating), 1) as avg
                              FROM "ULASAN"
                              WHERE id_tayangan = '{id}';""")
    
    ulasan = query_result(f"""SELECT username, rating, deskripsi
                              FROM "ULASAN"
                              WHERE id_tayangan = '{id}'
                              ORDER BY timestamp DESC;""")

    released = query_result(f"""SELECT
                                    CASE
                                        WHEN release_date_film < CURRENT_DATE THEN 1
                                        ELSE 0
                                    END AS is_released
                                FROM "FILM"
                                WHERE id_tayangan = '{id}';""")
    
    username = request.COOKIES.get('username')
    with connection.cursor() as cursor:
        cursor.execute(f"""SELECT judul
                           FROM "DAFTAR_FAVORIT"
                           WHERE username = '{username}'
                           """)
        hasil_judul_daftar_favorit = cursor.fetchall()
        list_daftar_favorit = []
        for row in hasil_judul_daftar_favorit:
            list_daftar_favorit.append(row[0])
    
    context = {'film': film[0],
               'pemain': pemain,
               'penulis': penulis,
               'view': view[0],
               'rating': rating[0],
               'ulasan': ulasan,
               'released': released[0],
               'list_daftar_favorit': list_daftar_favorit
               }
    
    return render(request, 'film.html', context)

def show_series(request, id):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')

    series = query_result(f"""SELECT T.id, T.judul, T.sinopsis, T.asal_negara, G.genre, C.nama AS nama_sutradara
                              FROM "SERIES" AS S
                              JOIN "TAYANGAN" AS T ON T.id = S.id_tayangan
                              LEFT JOIN "GENRE_TAYANGAN" AS G ON G.id_tayangan = S.id_tayangan
                              JOIN "CONTRIBUTORS" AS C ON C.id = T.id_sutradara
                              WHERE S.id_tayangan = '{id}';""")
    
    pemain = query_result(f"""SELECT C.nama
                            FROM "SERIES" AS S
                            JOIN "MEMAINKAN_TAYANGAN" AS MT ON MT.id_tayangan = S.id_tayangan
                            JOIN "CONTRIBUTORS" AS C ON C.id = MT.id_pemain
                            WHERE S.id_tayangan = '{id}';""")

    penulis = query_result(f"""SELECT C.nama
                              FROM "SERIES" AS S
                              JOIN "MENULIS_SKENARIO_TAYANGAN" AS MST ON MST.id_tayangan = S.id_tayangan
                              JOIN "CONTRIBUTORS" AS C ON C.id = MST.id_penulis_skenario
                              WHERE S.id_tayangan = '{id}';""")
    
    view = query_result(f"""SELECT COUNT(id_tayangan)
                            FROM "RIWAYAT_NONTON"
                            WHERE id_tayangan = '{id}';""")
    
    rating = query_result(f"""SELECT ROUND(AVG(rating), 1) as avg
                              FROM "ULASAN"
                              WHERE id_tayangan = '{id}';""")
    
    ulasan = query_result(f"""SELECT username, rating, deskripsi
                              FROM "ULASAN"
                              WHERE id_tayangan = '{id}'
                              ORDER BY timestamp DESC;""")
    
    episode = query_result(f"""SELECT id_series, sub_judul
                               FROM "EPISODE"
                               WHERE id_series = '{id}';""")
    
    for i in episode:
        encoded = quote(i.get('sub_judul'))
        url = f"{i.get('id_series')}/{encoded}/"
        i.pop('id_series')
        i.update({'url': url})
        
    username = request.COOKIES.get('username')
    with connection.cursor() as cursor:
        cursor.execute(f"""SELECT judul
                           FROM "DAFTAR_FAVORIT"
                           WHERE username = '{username}'
                           """)
        hasil_judul_daftar_favorit = cursor.fetchall()
        list_daftar_favorit = []
        for row in hasil_judul_daftar_favorit:
            list_daftar_favorit.append(row[0])
    
    
    context = {'series': series[0],
               'pemain': pemain,
               'penulis': penulis,
               'view': view[0],
               'rating': rating[0],
               'ulasan': ulasan,
               'episode': episode,
               'list_daftar_favorit': list_daftar_favorit}
    
    return render(request, 'series.html', context)

def show_episode(request, id, sub_judul):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')
    
    sub_judul = check_string_valid(sub_judul)
    episode = query_result(f"""SELECT T.id, T.judul, E.sub_judul, E.sinopsis, E.durasi, E.url_video, E.release_date
                              FROM "EPISODE" AS E
                              JOIN "TAYANGAN" AS T ON T.id = E.id_series
                              WHERE E.id_series = '{id}' AND E.sub_judul = '{sub_judul}';""")
    
    other_episodes = query_result(f"""SELECT id_series, sub_judul
                                      FROM "EPISODE"
                                      WHERE id_series = '{id}' AND sub_judul != '{sub_judul}';""")
    
    released = query_result(f"""SELECT
                                    CASE
                                        WHEN release_date < CURRENT_DATE THEN 1
                                        ELSE 0
                                    END AS is_released
                                FROM "EPISODE"
                                WHERE id_series = '{id}' AND sub_judul = '{sub_judul}';""")
    
    username = request.COOKIES.get('username')
    with connection.cursor() as cursor:
        cursor.execute(f"""SELECT judul
                           FROM "DAFTAR_FAVORIT"
                           WHERE username = '{username}'
                           """)
        hasil_judul_daftar_favorit = cursor.fetchall()
        list_daftar_favorit = []
        for row in hasil_judul_daftar_favorit:
            list_daftar_favorit.append(row[0])
    
    if sub_judul in list_daftar_favorit:
        with connection.cursor() as cursor:
            cursor.execute(f"""SELECT timestamp
                            FROM "DAFTAR_FAVORIT"
                            WHERE username = '{username}' AND judul = '{sub_judul}'
                            """)
            timestamp = cursor.fetchall()
            timestamp_output = timestamp[0][0]
            print(timestamp_output)
            with connection.cursor() as cursor:
                cursor.execute(f"""INSERT INTO "TAYANGAN_MEMILIKI_DAFTAR_FAVORIT" VALUES ('{id}', '{timestamp_output}', '{username}')
                            """)
            return HttpResponseRedirect(f'/tayangan/series/{id}')  # Or return any other response as needed
    else:
        for i in other_episodes:
            encoded = quote(i.get('sub_judul'))
            url = f"{i.get('id_series')}/{encoded}/"
            i.pop('id_series')
            i.update({'url': url})
            

        context = {'episode': episode[0],
                'other_episodes': other_episodes,
                'released': released[0],
                'list_daftar_favorit': list_daftar_favorit}

        return render(request, 'episode.html', context)# Or return any other response as needed

def unduh_tayangan(request, id):
    username = request.COOKIES.get('username')
    
    if username:
        current_time = datetime.datetime.now()
        add_time_gmt_plus_seven = datetime.timedelta(hours=7) 
        current_time_real = current_time + add_time_gmt_plus_seven
        current_time_format = current_time_real.strftime('%Y-%m-%d %H:%M:%S')
        
        with connection.cursor() as cursor:
            cursor.execute(f"""
                    INSERT INTO "TAYANGAN_TERUNDUH" VALUES ('{id}', '{username}', '{current_time_format}');
                """)
        
        with connection.cursor() as cursor:
            cursor.execute(f"""SELECT id_tayangan
                            FROM "FILM"
                            WHERE id_tayangan = '{id}'
                            """)
            hasil_judul_tayangan = cursor.fetchall()
            if len(hasil_judul_tayangan) == 0:
                return HttpResponseRedirect(f'/tayangan/series/{id}')
            else:
                return HttpResponseRedirect(f'/tayangan/film/{id}')

    else:
        return HttpResponseBadRequest('User not authenticated')

def tambah_ke_daftar_favorit(request, id, judul):
    username = request.COOKIES.get('username')
    with connection.cursor() as cursor:
        cursor.execute(f"""SELECT timestamp
                           FROM "DAFTAR_FAVORIT"
                           WHERE username = '{username}' AND judul = '{judul}'
                        """)
        timestamp = cursor.fetchall()
        timestamp_output = timestamp[0][0]
        print(timestamp_output)
    
    with connection.cursor() as cursor:
        cursor.execute(f"""INSERT INTO "TAYANGAN_MEMILIKI_DAFTAR_FAVORIT" VALUES ('{id}', '{timestamp_output}', '{username}')
                       """)
        
    return HttpResponseRedirect(f'/tayangan/film/{id}')
  # Or return any other response as needed


def add_ulasan(request):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')

    if request.method == "POST":
        username = request.COOKIES.get('username')
        id = request.POST['id']
        rating = int(request.POST['rating'])
        deskripsi = request.POST['deskripsi']
        tipe = request.POST['tipe']

        cursor = connection.cursor()
        try:
            cursor.execute(f"""
                INSERT INTO "ULASAN" VALUES ('{id}', '{username}', NOW(), '{rating}', '{deskripsi}');
            """)
            messages.add_message(request, messages.SUCCESS, 'Ulasan berhasil ditambahkan!', extra_tags='ulasan')
        except InternalError as e:
            if 'Username' in str(e):
                messages.add_message(request, messages.ERROR, f"Username {username} sudah memberikan ulasan pada tayangan ini!", extra_tags='ulasan')
        if tipe == 'series':
            return HttpResponseRedirect(f'/tayangan/series/{id}')
        return HttpResponseRedirect(f'/tayangan/film/{id}')

def add_tonton(request):
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:landing')
    
    if request.method == "POST":
        username = request.COOKIES.get('username')
        id = request.POST['id']
        tipe = request.POST['tipe']
        progress = int(request.POST['progress'])
        durasi = int(request.POST['durasi'])
        progress = int((progress/100) * durasi)

        cursor = connection.cursor()
        try:
            cursor.execute(f"""
                INSERT INTO "RIWAYAT_NONTON" VALUES ('{id}', '{username}', NOW(), NOW() + {progress} * INTERVAL '1 minute');
            """)
            messages.add_message(request, messages.SUCCESS, 'Tayangan behasil di tonton!', extra_tags='tonton')
        except InternalError as e:
            messages.add_message(request, messages.ERROR, 'Tayangan gagal di tonton!', extra_tags='tonton')
        if tipe == 'series':
            subjudul = request.POST['subjudul']
            encoded = quote(subjudul)
            url = f"{id}/{encoded}/"
            return HttpResponseRedirect(f'/tayangan/series/{url}')
        return HttpResponseRedirect(f'/tayangan/film/{id}')

def check_string_valid(string):
    new_string = ''
    for char in string:
        if char == "'":
            new_string += "''"
        elif char == "\\":
            new_string += "\\\\"
        else:
            new_string += char
    return new_string
