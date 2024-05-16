from django.shortcuts import render
from django.db import connection

# Create your views here.
def show_download(request):
    with connection.cursor() as cursor:
        logged_in_username = request.session.get('username')
        cursor.execute(f"""SELECT t.judul FROM "TAYANGAN" t
                            JOIN "TAYANGAN_TERUNDUH" tt ON t.ID = tt.ID_TAYANGAN
                            WHERE USERNAME = '{logged_in_username}'""")
        list_unduhan = cursor.fetchall()
        list_unduhan = [row[0] for row in list_unduhan]
        print(list_unduhan)
        context = {
            'list_unduhan': list_unduhan,
        }
    return render(request, 'daftar_unduhan.html', context)
