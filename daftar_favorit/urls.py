from django.urls import path
from daftar_favorit.views import show_favorite, show_film_in_daftar_favorit

app_name = 'daftar_favorit'
urlpatterns = [
    path('fav/', show_favorite, name='show_favorite'),
    path('fav/<str:judul>/', show_film_in_daftar_favorit, name='show_film_in_daftar_favorite')
]