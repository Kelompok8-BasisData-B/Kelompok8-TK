from django.urls import path
from tayangan.views import (show_trailer, show_tayangan, show_hasil_pencarian_trailer, show_hasil_pencarian_tayangan,
                            show_film, show_series, show_episode)

app_name = 'tayangan'

urlpatterns = [
    path('tayangan/', show_tayangan, name='show_tayangan'),
    path('', show_trailer, name='show_trailer'),
    path('hasil-pencarian-trailer/', show_hasil_pencarian_trailer, name='show_hasil_pencarian_trailer'),
    path('hasil-pencarian-tayangan/', show_hasil_pencarian_tayangan, name='show_hasil_pencarian_trailer'),
    path('tayangan/film/', show_film, name='show_film'),
    path('tayangan/series/', show_series, name='show_series'),
    path('tayangan/episode/', show_episode, name='show_episode')
]
