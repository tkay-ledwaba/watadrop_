from django.urls import path
from . import views

urlpatterns = [ 
    path('user/', views.UserRecordView),
    path('getstores/', views.getStores),
    
]