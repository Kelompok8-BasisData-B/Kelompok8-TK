from django.urls import path
from tayangan.views import show_trailer, show_tayangan, show_ulasan

app_name = 'tayangan'

urlpatterns = [
     path('', show_tayangan, name='show_tayangan'),
     path('trailer/', show_trailer, name='show_trailer'),
     path('ulasan/', show_ulasan, name='show_ulasan'),
]

