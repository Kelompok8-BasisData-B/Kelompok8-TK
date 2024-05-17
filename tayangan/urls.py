from django.urls import path
from tayangan.views import (show_trailer, show_tayangan, show_hasil_pencarian_trailer, show_hasil_pencarian_tayangan,
                            show_film, show_series, show_episode, unduh_tayangan, tambah_ke_daftar_favorit,
                            add_ulasan, add_tonton, tambah_ke_daftar_favorit_series)
app_name = 'tayangan'

urlpatterns = [
    path('', show_trailer, name='show_trailer'),
    path('tayangan/', show_tayangan, name='show_tayangan'),
    path('hasil-pencarian-trailer/<str:value>/', show_hasil_pencarian_trailer, name='show_hasil_pencarian_trailer'),
    path('hasil-pencarian-tayangan/<str:value>/', show_hasil_pencarian_tayangan, name='show_hasil_pencarian_trailer'),
    path('tayangan/film/<str:id>/', show_film, name='show_film'),
    path('tayangan/series/<str:id>/', show_series, name='show_series'),
    path('tayangan/series/<str:id>/<str:sub_judul>/', show_episode, name='show_episode'),
    path('unduh/<str:id>/', unduh_tayangan, name='unduh_tayangan'),
    path('tayangan/film/<str:id>/<str:judul>/', tambah_ke_daftar_favorit, name='tambah_ke_favorit'),
    path('tayangan/add-ulasan/', add_ulasan, name='add_ulasan'),
    path('tayangan/add-tonton/', add_tonton, name='add_tonton'),
    path('favorit-series/<str:id>/<str:judul>', tambah_ke_daftar_favorit_series, name='tambah_ke_favorit_series')
]
