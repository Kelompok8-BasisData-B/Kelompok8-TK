from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import logout

from django.contrib.auth import authenticate, login
from django import forms
from django.contrib.auth.models import User
# from django.contrib.auth.forms import AuthenticationForm
# from django.contrib.auth.decorators import login_required

# Create your views here.
def landing(request):
    return render(request, 'landing.html')

def login_view(request):
     if request.method == 'POST':
          username = request.POST.get('username')
          password = request.POST.get('password')
          user = authenticate(request, username=username, password=password)
          if user is not None:
               login(request, user)
               return redirect('tayangan:show_tayangan')
          else:
               messages.info(request, 'Username atau password yang Anda masukkan salah! Silahkan coba lagi')
     context = {}
     return render(request, 'login_page.html', context)

class RegisterForm(forms.ModelForm):
     username = forms.CharField(max_length=50, required=True)
     password = forms.CharField(label='Password', widget=forms.PasswordInput)
     negara_asal = forms.CharField(max_length=50, required=True)

     class Meta:
          model = User
          fields = ('username', 'password', 'negara_asal')

def register_view(request):
     form = RegisterForm()

     if request.method == "POST":
          form = RegisterForm(request.POST)
          if form.is_valid():
               user = form.save(commit=False)
               user.set_password(form.cleaned_data['password'])
               user.save()
               messages.success(request, 'Akun Anda berhasil dibuat!')
               return redirect('authentication:landing')
     context = {'form':form}
     return render(request, 'register_page.html', context)

def logout_view(request):
     logout(request)
     return redirect('authentication:landing')

# from django.shortcuts import render, redirect
# from django.contrib import messages
# from django.contrib.auth import logout

# from django.contrib.auth import authenticate, login
# from django import forms
# from django.contrib.auth.models import User
# # from django.contrib.auth.decorators import login_required

# # Create your views here.
# def landing(request):
#     return render(request, 'landing.html')

# def login_view(request):
#      return render(request, 'login_page.html')

# def register_view(request):
#      return render(request, 'register_page.html')

# def logout_view(request):
#      logout(request)
#      return redirect('authentication:login_view')
