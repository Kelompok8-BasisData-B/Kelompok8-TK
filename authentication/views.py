from django.shortcuts import render, redirect
from django.contrib.auth import logout
# from function.general import query_result
# from django.http import HttpResponse
from django.db import connection
from django.contrib import messages

# Create your views here.
def landing(request):
    return render(request, 'landing.html')

def login_view(request):
     context = {}
     if request.method == 'POST':
          username = request.POST.get('username')
          password = request.POST.get('password')

          with connection.cursor() as cursor:
               cursor.execute(f"""SELECT username, password FROM "PENGGUNA" WHERE username = %s AND password = %s""", 
                              [username, password])
               user = cursor.fetchone()
          
          if user is not None:
               return redirect('tayangan:show_tayangan')
          else:
               context['error'] = "Username atau password tidak ditemukan"
               messages.error(request, "Username atau password tidak ditemukan")
     return render(request, 'login_page.html', context)

# class RegisterForm(forms.ModelForm):
#      username = forms.CharField(max_length=50, required=True)
#      password = forms.CharField(label='Password', widget=forms.PasswordInput)
#      negara_asal = forms.CharField(max_length=50, required=True)

#      class Meta:
#           model = User
#           fields = ('username', 'password', 'negara_asal')

# def register_view(request):
#      form = RegisterForm()

#      if request.method == "POST":
#           form = RegisterForm(request.POST)
#           if form.is_valid():
#                user = form.save(commit=False)
#                user.set_password(form.cleaned_data['password'])
#                user.save()
#                messages.success(request, 'Akun Anda berhasil dibuat!')
#                return redirect('authentication:landing')
#      context = {'form':form}
#      return render(request, 'register_page.html', context)

def logout_view(request):
     logout(request)
     return redirect('authentication:landing')