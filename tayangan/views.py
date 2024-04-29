from django.shortcuts import render

# Create your views here.
def show_trailer(request):
    return render(request, 'daftar_trailer.html')

def show_tayangan(request):
    return render(request, 'daftar_tayangan.html')

def show_ulasan(request):
    return render(request, 'bagian_ulasan.html')