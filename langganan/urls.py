from django.urls import path
from langganan.views import show_main, show_buy, process_payment

app_name = 'langganan'

urlpatterns = [
    path('main/', show_main, name='show_main'),
    path('buy/', show_buy, name='show_buy'),
    path('process_payment/', process_payment, name='process_payment'),
]