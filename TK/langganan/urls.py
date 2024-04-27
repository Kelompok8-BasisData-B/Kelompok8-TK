from django.urls import path
from langganan.views import show_main, show_buy

app_name = 'langganan'

urlpatterns = [
    path('main/', show_main, name='show_main'),
    path('buy/', show_buy, name='show_buy'),
]