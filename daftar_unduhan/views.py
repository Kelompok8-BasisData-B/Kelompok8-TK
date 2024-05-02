from django.shortcuts import render

# Create your views here.
def show_download(request):
    return render(request, 'daftar_unduhan.html')