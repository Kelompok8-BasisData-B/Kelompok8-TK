from django.urls import path
from tayangan.views import (show_trailer, show_tayangan, show_hasil_pencarian_trailer, show_hasil_pencarian_tayangan,
                            show_film, show_series, show_episode, add_ulasan, add_tonton)

app_name = 'tayangan'

urlpatterns = [
    path('', show_trailer, name='show_trailer'),
    path('tayangan/', show_tayangan, name='show_tayangan'),
    path('hasil-pencarian-trailer/<str:value>/', show_hasil_pencarian_trailer, name='show_hasil_pencarian_trailer'),
    path('hasil-pencarian-tayangan/<str:value>/', show_hasil_pencarian_tayangan, name='show_hasil_pencarian_trailer'),
    path('tayangan/film/<str:id>/', show_film, name='show_film'),
    path('tayangan/series/<str:id>/', show_series, name='show_series'),
    path('tayangan/series/<str:id>/<str:sub_judul>/', show_episode, name='show_episode'),
    path('tayangan/add-ulasan/', add_ulasan, name='add_ulasan'),
    path('tayangan/add-tonton/', add_tonton, name='add_tonton')
]
