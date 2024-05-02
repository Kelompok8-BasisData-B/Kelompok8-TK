from django.shortcuts import render

# Create your views here.

def show_favorite(request):
    return render(request, 'daftar_favorit.html')
