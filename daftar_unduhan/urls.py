from django.urls import path
from daftar_unduhan.views import show_download

app_name = 'daftar_unduhan'

urlpatterns = [
  path('download/', show_download, name='show_download')
]