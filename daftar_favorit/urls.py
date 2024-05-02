from django.urls import path
from daftar_favorit.views import show_favorite

app_name = 'daftar_favorit'
urlpatterns = [
    path('fav/', show_favorite, name='show_favorite')
]