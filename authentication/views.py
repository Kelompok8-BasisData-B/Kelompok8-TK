from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import logout

from django.contrib.auth import authenticate, login
from django import forms
from django.contrib.auth.models import User
# from django.contrib.auth.decorators import login_required

# Create your views here.
def landing(request):
    return render(request, 'landing.html')

def login_view(request):
     return render(request, 'login_page.html')

def register_view(request):
     return render(request, 'register_page.html')

def logout_view(request):
     logout(request)
     return redirect('authentication:login_view')
