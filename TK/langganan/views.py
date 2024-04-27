from django.shortcuts import render

# Create your views here.
def show_main(request):
    context = {
    }
    return render(request, "daftar_langganan.html", context)

# Create your views here.
def show_buy(request):
    context = {
    }
    return render(request, "halaman_beli.html", context)
