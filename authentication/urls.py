from django.urls import path
from authentication.views import landing, login_view, logout_view

app_name = 'authentication'

urlpatterns = [
     path('', landing, name='landing'),
     path('login/', login_view, name='login_view'),
     # path('register/', register_view, name='register_view'),
     path('logout/', logout_view, name='logout'),
]