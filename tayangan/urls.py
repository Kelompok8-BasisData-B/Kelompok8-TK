from django.urls import path
from tayangan.views import (show_trailer, show_tayangan, show_hasil_pencarian_trailer, show_hasil_pencarian_tayangan,
                            show_film, show_series, show_episode)

app_name = 'tayangan'

urlpatterns = [
    path('', show_tayangan, name='show_tayangan'),
    path('trailer/', show_trailer, name='show_trailer'),
    path('hasil-pencarian-trailer/', show_hasil_pencarian_trailer, name='show_hasil_pencarian_trailer'),
    path('hasil-pencarian-tayangan/', show_hasil_pencarian_tayangan, name='show_hasil_pencarian_trailer'),
    path('film/', show_film, name='show_film'),
    path('series/', show_series, name='show_series'),
    path('episode/', show_episode, name='show_episode')
]

