from django.http import JsonResponse
from django.shortcuts import redirect, render
from django.db import connection

# Create your views here.
def show_download(request):
    with connection.cursor() as cursor:
        logged_in_username = request.session.get('username')
        cursor.execute(f"""SELECT t.id, t.judul, tt.timestamp 
                            FROM "TAYANGAN" t
                            JOIN "TAYANGAN_TERUNDUH" tt ON t.ID = tt.ID_TAYANGAN
                            WHERE USERNAME = '{logged_in_username}'
                    """)
        tayangan_yg_terunduh = cursor.fetchall()
        
        id = []
        judul = []
        timestamp = []
        for row in tayangan_yg_terunduh:
            id.append(row[0])
            judul.append(row[1])
            timestamp.append(row[2])
        print(id)
        print(judul)
        print(timestamp)  
        
        complete_detail = zip(id, judul, timestamp)
            
        context = {
            'tayangan_yg_terunduh': complete_detail
        }
    return render(request, 'daftar_unduhan.html', context)

def hapus_unduhan(request, id):
    logged_in_username = request.session.get('username')
    
    if logged_in_username:
        with connection.cursor() as cursor:
            cursor.execute(f"""DELETE FROM "TAYANGAN_TERUNDUH" 
                               WHERE id_tayangan = '{id}'
                               AND username = '{logged_in_username}'""")
        return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'error', 'message': 'User not authenticated'}, status=401)
