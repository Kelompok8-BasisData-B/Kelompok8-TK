from django.shortcuts import render, redirect
from django.contrib.auth import logout
from django.db import connection, InternalError
from django.contrib import messages

# Create your views here.
def landing(request):
    return render(request, 'landing.html')

def login_view(request):
     context = {}
     if request.method == 'POST':
          username = request.POST.get('username')
          password = request.POST.get('password')

          print(username)
          with connection.cursor() as cursor:
               cursor.execute(f"""SELECT username, password FROM "PENGGUNA" WHERE username = %s AND password = %s""", 
                              [username, password])
               user = cursor.fetchone()
          
          if user is not None:
               request.session['username'] = username
               response = redirect('tayangan:show_tayangan')
               response.set_cookie('username', username)
               return response
          else:
               context['error'] = "Username atau password tidak ditemukan"
               messages.error(request, "Username atau password tidak ditemukan")
     return render(request, 'login_page.html', context)

def register_view(request):
     if request.method == "POST":
          username = request.POST['username']
          password = request.POST['password']
          negara_asal = request.POST['negara_asal']
          
          cursor = connection.cursor()
          try:
               cursor.execute(f"""
                    INSERT INTO "PENGGUNA" VALUES ('{username}', '{password}', '{negara_asal}');
               """)
               messages.success(request, 'Registrasi berhasil! Silahkan login')
          except InternalError as e:
               if 'Username' in str(e):
                    messages.error(request, f"Username {username} sudah terdaftar!")
     return render(request, 'register_page.html')

def logout_view(request):
     logout(request)
     return redirect('/tayangan/')