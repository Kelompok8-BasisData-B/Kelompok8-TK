from django.shortcuts import render
from function.general import query_result
from django.http import HttpResponse
from django.db import connection

# Create your views here.
def show_main(request):
    riwayat_transaksi = query_result(f"""
                                    SELECT nama_paket, start_date_time, end_date_time, metode_pembayaran, timestamp_pembayaran, P.harga AS total_pembayaran
                                    FROM "TRANSACTION" AS T 
                                    JOIN "PAKET" AS P ON T.nama_paket = P.nama;
                                    """) 

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
                                        T.nama_paket IS NOT NULL
                                        AND CURRENT_DATE >= T.start_date_time
                                    GROUP BY
                                        P.nama, P.harga, P.resolusi_layar, T.start_date_time, T.end_date_time;
                                    """)

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
        # Ambil data yang dikirimkan dari formulir pembayaran
        nama_paket = request.POST.get('nama_paket')
        harga = request.POST.get('harga')
        resolusi_layar = request.POST.get('resolusi_layar')
        dukungan_perangkat = request.POST.get('dukungan_perangkat')
        metode_pembayaran = request.POST.get('metode_pembayaran')
        
        with connection.cursor() as cursor:
            cursor.execute(f"""
                            INSERT INTO "TRANSACTION" (nama_paket, harga, resolusi_layar, dukungan_perangkat, metode_pembayaran) VALUES (%s, %s, %s, %s, %s)
                            """, [nama_paket, harga, resolusi_layar, dukungan_perangkat, metode_pembayaran]
                            )
        return HttpResponse("Pembayaran berhasil!")

    return HttpResponse("Permintaan tidak valid!")

