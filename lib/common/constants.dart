var _totalNotifications;

String checkStatus(status){
  if (status == -1){
    return 'Cancelled';
  }
  if (status == 0){
    return 'Pending';
  } else if (status == 1){
    return 'Accepted';
  } else if (status == 2){
    return 'On the way';
  } else if (status == 3){
    return 'In-Service';
  } else if (status == 4){
    return 'Completed';
  } else {
    return 'Error';
  }
}