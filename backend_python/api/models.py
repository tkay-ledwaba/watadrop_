from django.db import models
from django.contrib.postgres.fields import ArrayField

# Create your models here.


WEEKDAYS = [
    (1, ("Monday")),
    (2, ("Tuesday")),
    (3, ("Wednesday")),
    (4, ("Thursday")),
    (5, ("Friday")),
    (6, ("Saturday")),
    (7, ("Sunday")),
]

class Store(models.Model):
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    phone = models.CharField(max_length=12)
    email = models.EmailField()
    
    def __str__(self):
        return self.name

    class Meta:
        db_table = "store"

class Menu(models.Model):
    title = models.CharField(max_length=30)
    
    def __str__(self):
        return self.title

class Category(models.Model):
    title = models.CharField(max_length=30)
    description = models.TextField()
    
    def __str__(self):
        return self.title
      
class Product(models.Model):
    name = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.TextField()
    discount = models.DecimalField(max_digits=10, decimal_places=0)
    description = models.CharField(max_length=200)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)

    def __str__(self):
        return self.name