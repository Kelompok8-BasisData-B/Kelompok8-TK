from django.urls import path
from daftar_unduhan.views import show_download, hapus_unduhan

app_name = 'daftar_unduhan'

urlpatterns = [
  path('download/', show_download, name='show_download'),
  path('download/hapus/<str:id>/<str:timestamp>', hapus_unduhan, name='hapus_unduhan'),
]