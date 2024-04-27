from django.urls import path
from daftar_kontributor.views import show_main

app_name = 'daftar_kontributor'

urlpatterns = [
    path('main/', show_main, name='show_main'),
]