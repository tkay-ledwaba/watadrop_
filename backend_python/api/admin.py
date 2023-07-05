from django.contrib import admin

from api.models import Store, Menu, Category, Product

# Register your models here.
admin.site.register(Store)
admin.site.register(Menu)
admin.site.register(Category)
admin.site.register(Product)