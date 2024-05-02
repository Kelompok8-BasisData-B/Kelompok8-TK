from django.shortcuts import render

# Create your views here.
def show_trailer(request):
    return render(request, 'daftar_trailer.html')

def show_tayangan(request):
    return render(request, 'daftar_tayangan.html')

def show_hasil_pencarian_trailer(request):
    return render(request, 'hasil_pencarian_trailer.html')

def show_hasil_pencarian_tayangan(request):
    return render(request, 'hasil_pencarian_tayangan.html')

def show_film(request):
    return render(request, 'film.html')

def show_series(request):
    return render(request, 'series.html')

def show_episode(request):
    return render(request, 'episode.html')