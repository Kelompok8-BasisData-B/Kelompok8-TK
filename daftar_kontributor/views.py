from django.shortcuts import render
from function.general import query_result

# Create your views here.
def show_main(request):
    result = query_result(f"""
                            SELECT
                                nama,
                                STRING_AGG(tipe, ', ') AS tipe,
                                CASE jenis_kelamin
                                    WHEN 0 THEN 'Laki-laki'
                                    WHEN 1 THEN 'Perempuan'
                                END AS jenis_kelamin,
                                kewarganegaraan
                            FROM (
                                SELECT K.nama, 'Pemain' AS tipe, K.jenis_kelamin, K.kewarganegaraan FROM "CONTRIBUTORS" AS K JOIN "PEMAIN" AS P ON P.id = K.id
                                UNION
                                SELECT K.nama, 'Sutradara' AS tipe, K.jenis_kelamin, K.kewarganegaraan FROM "CONTRIBUTORS" AS K JOIN "SUTRADARA" AS S ON S.id = K.id
                                UNION
                                SELECT K.nama, 'Penulis Skenario' AS tipe, K.jenis_kelamin, K.kewarganegaraan FROM "CONTRIBUTORS" AS K JOIN "PENULIS_SKENARIO" AS E ON E.id = K.id
                            ) AS combined_data
                            GROUP BY nama, jenis_kelamin, kewarganegaraan;
                            """) 

    context = {
        'result': result
    }

    return render(request, "daftar_kontributor.html", context)
