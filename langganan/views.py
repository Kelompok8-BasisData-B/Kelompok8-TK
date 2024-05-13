from django.shortcuts import render
from function.general import query_result
from django.http import HttpResponse
from django.db import connection
from datetime import date, datetime, timedelta
from django.db import IntegrityError


# Create your views here.
def show_main(request):
    username = request.COOKIES.get('username')
    riwayat_transaksi = query_result(f"""
                                    SELECT nama_paket, start_date_time, end_date_time, metode_pembayaran, timestamp_pembayaran, P.harga AS total_pembayaran
                                    FROM "TRANSACTION" AS T 
                                    JOIN "PAKET" AS P ON T.nama_paket = P.nama
                                    WHERE T.username = %s;
                                    """, [username]) 

    paket = query_result(f"""
                        SELECT 
                            P.nama AS nama_paket,
                            COALESCE(harga, 0) AS harga,
                            COALESCE(resolusi_layar, '-') AS resolusi_layar,
                            COALESCE(STRING_AGG(D.dukungan_perangkat, ', '), '-') AS dukungan_perangkat
                        FROM 
                            "PAKET" AS P
                        LEFT JOIN 
                            "DUKUNGAN_PERANGKAT" AS D ON P.nama = D.nama_paket
                        GROUP BY 
                            P.nama, harga, resolusi_layar;
                        """)
    
    activate_package = query_result(f"""
                                    SELECT
                                        P.nama AS nama,
                                        P.harga AS harga,
                                        P.resolusi_layar AS resolusi_layar,
                                        STRING_AGG(D.dukungan_perangkat, ', ') AS dukungan_perangkat,
                                        T.start_date_time AS start_date,
                                        T.end_date_time AS end_date
                                    FROM
                                        "TRANSACTION" AS T
                                    JOIN
                                        "PAKET" AS P ON P.nama = T.nama_paket
                                    JOIN
                                        "DUKUNGAN_PERANGKAT" AS D ON D.nama_paket = P.nama
                                    WHERE
                                        T.username = %s AND
                                        T.nama_paket IS NOT NULL
                                        AND CURRENT_DATE >= T.start_date_time
                                        AND CURRENT_DATE <= T.end_date_time
                                    GROUP BY
                                        P.nama, P.harga, P.resolusi_layar, T.start_date_time, T.end_date_time;
                                    """, [username])

    context = {
        'riwayat_transaksi': riwayat_transaksi,
        'paket' : paket,
        'activate_package' : activate_package,
    }
    return render(request, "daftar_langganan.html", context)


def show_buy(request):
    context = {
    }
    return render(request, "halaman_beli.html", context)

def process_payment(request):
    if request.method == 'POST':
        nama_paket = request.POST.get('nama_paket')
        harga = request.POST.get('harga')
        resolusi_layar = request.POST.get('resolusi_layar')
        dukungan_perangkat = request.POST.get('dukungan_perangkat')
        metode_pembayaran = request.POST.get('metode_pembayaran')
        username = request.COOKIES.get('username')
        current_date = date.today()
        current_timestamp = datetime.now()
        next_month = current_date.month + 1
        next_year = current_date.year

        if next_month > 12:
            next_month = 1
            next_year += 1

        end_date = current_date.replace(month=next_month, year=next_year)
        print(end_date)

        try:
            context = {
                'check_time_add': True,
            }
            with connection.cursor() as cursor:
                cursor.execute(f"""
                    INSERT INTO "TRANSACTION" (username, start_date_time, end_date_time, nama_paket, metode_pembayaran, timestamp_pembayaran) 
                    VALUES ('{username}', '{current_date}', '{end_date}', '{nama_paket}', '{metode_pembayaran}', '{current_timestamp}')
                """)
                connection.commit()
            return render(request, 'notification.html', context)
        except IntegrityError:
            context = {
                'check_time_add': False,
            }
            return render(request, 'notification.html', context)

def your_view(request, check_time_add):
    context = {
        'check_time_add': check_time_add,
    }
    return render(request, 'notification.html', context)