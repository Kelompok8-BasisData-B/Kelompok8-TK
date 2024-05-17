from django.urls import path
from daftar_favorit.views import show_favorite, show_film_in_daftar_favorit, delete_daftar_favorite, delete_from_favorite

app_name = 'daftar_favorit'
urlpatterns = [
    path('fav/', show_favorite, name='show_favorite'),
    path('fav/<str:judul>/', show_film_in_daftar_favorit, name='show_film_in_daftar_favorite'),
    path('fav/hapus/<str:judul>/', delete_daftar_favorite, name='delete_daftar_favorite'),
    path('fav//<str:judul_daftar>/<str:id>/', delete_from_favorite, name='delete_from_favorite')
]