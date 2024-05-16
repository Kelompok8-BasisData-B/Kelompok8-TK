from django.http import JsonResponse
from django.shortcuts import render
from function.general import *
from urllib.parse import quote

def show_trailer(request):
    top_10 = query_result(f"""WITH all_duration AS (
                            SELECT T.id AS id, F.durasi_film AS durasi
                            FROM "TAYANGAN" AS T
                            JOIN "FILM" AS F ON F.id_tayangan = T.id
                            UNION
                            SELECT T.id AS id, AVG(E.durasi) AS durasi
                            FROM "TAYANGAN" AS t
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id
                            JOIN "EPISODE" AS E on E.id_series = T.id
                            GROUP BY T.id
                        ), recent_views AS (
                            SELECT T.id AS id, COUNT(*) AS total_view
                            FROM "TAYANGAN" AS T 
                            JOIN "RIWAYAT_NONTON" AS RW ON RW.id_tayangan = T.id
                            JOIN "all_duration" AS AD ON AD.id = T.id
                            WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS' AND
                            EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60 > (0.7 * AD.durasi)
                            GROUP BY T.id
                        )
                        
                        SELECT T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer, RV.total_view
                        FROM "TAYANGAN" AS T
                        JOIN "recent_views" AS RV ON RV.id = T.id
                        ORDER BY RV.total_view DESC
                        LIMIT 10;""")
    
    film = query_result(f"""SELECT T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                            FROM "TAYANGAN" AS T
                            JOIN "FILM" AS F ON F.id_tayangan = T.id;""")

    series = query_result(f"""SELECT T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
                            FROM "TAYANGAN" AS T
                            JOIN "SERIES" AS S ON S.id_tayangan = T.id;""")

    context = {
        "film": film,
        "series": series,
        "top_10": top_10
    }

    return render(request, 'daftar_trailer.html', context)

def show_tayangan(request):
    top_10 = query_result(f"""WITH all_duration AS (
                              SELECT T.id AS id, F.durasi_film AS durasi
                              FROM "TAYANGAN" AS T
                              JOIN "FILM" AS F ON F.id_tayangan = T.id
                              UNION
                              SELECT T.id AS id, AVG(E.durasi) AS durasi
                              FROM "TAYANGAN" AS t
                              JOIN "SERIES" AS S ON S.id_tayangan = T.id
                              JOIN "EPISODE" AS E on E.id_series = T.id
                              GROUP BY T.id
                          ), recent_views AS (
                              SELECT T.id AS id, COUNT(*) AS total_view
                              FROM "TAYANGAN" AS T 
                              JOIN "RIWAYAT_NONTON" AS RW ON RW.id_tayangan = T.id
                              JOIN "all_duration" AS AD ON AD.id = T.id
                              WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS' AND
                              EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60 > (0.7 * AD.durasi)
                              GROUP BY T.id
                          )
                          
                          SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer, RV.total_view
                          FROM "TAYANGAN" AS T
                          JOIN "recent_views" AS RV ON RV.id = T.id
                          ORDER BY RV.total_view DESC
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
    film = query_result(f"""SELECT T.judul, T.sinopsis, T.asal_negara, F.url_video_film, F.release_date_film, F.durasi_film, G.genre, C.nama AS nama_sutradara
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
                              WHERE id_tayangan = '{id}';""")

    released = query_result(f"""SELECT
                                    CASE
                                        WHEN release_date_film < CURRENT_DATE THEN 1
                                        ELSE 0
                                    END AS is_released
                                FROM "FILM"
                                WHERE id_tayangan = '{id}';""")
    
    context = {'film': film[0],
               'pemain': pemain,
               'penulis': penulis,
               'view': view[0],
               'rating': rating[0],
               'ulasan': ulasan,
               'released': released[0]}
    
    return render(request, 'film.html', context)

def show_series(request, id):
    series = query_result(f"""SELECT T.judul, T.sinopsis, T.asal_negara, G.genre, C.nama AS nama_sutradara
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
                              WHERE id_tayangan = '{id}';""")
    
    episode = query_result(f"""SELECT id_series, sub_judul
                               FROM "EPISODE"
                               WHERE id_series = '{id}';""")
    for i in episode:
        encoded = quote(i.get('sub_judul'))
        url = f"{i.get('id_series')}/{encoded}/"
        i.pop('id_series')
        i.update({'url': url})
    
    context = {'series': series[0],
               'pemain': pemain,
               'penulis': penulis,
               'view': view[0],
               'rating': rating[0],
               'ulasan': ulasan,
               'episode': episode}
    
    return render(request, 'series.html', context)

def show_episode(request, id, sub_judul):
    sub_judul = check_string_valid(sub_judul)
    episode = query_result(f"""SELECT T.judul, E.sub_judul, E.sinopsis, E.durasi, E.url_video, E.release_date
                              FROM "EPISODE" AS E
                              JOIN "TAYANGAN" AS T ON T.id = E.id_series
                              WHERE E.id_series = '{id}' AND E.sub_judul = '{sub_judul}';""")
    
    other_episodes = query_result(f"""SELECT id_series, sub_judul
                                      FROM "EPISODE"
                                      WHERE id_series = '{id}' AND sub_judul != '{sub_judul}';""")
    
    released = query_result(f"""SELECT
                                    CASE
                                        WHEN release_date_film < CURRENT_DATE THEN 1
                                        ELSE 0
                                    END AS is_released
                                FROM "FILM"
                                WHERE id_tayangan = '{id}';""")
    
    context = {'episode': episode[0],
               'other_episodes': other_episodes,
               'released': released[0]}

    return render(request, 'episode.html', context)

def unduh_tayangan(request, id):
    username = request.COOKIES.get('username')
    
    if username:
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO "TAYANGAN_TERUNDUH" (ID_TAYANGAN, USERNAME)
                VALUES (%s, %s)
            """, [id, username])
        
        return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'error', 'message': 'User not authenticated'}, status=401)

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
