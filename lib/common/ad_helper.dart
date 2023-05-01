import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2108109327779150~7973542910';
    }
    //else if (Platform.isIOS) {
      //return 'ca-app-pub-3940256099942544/2934735716';
    //}
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
//--- Call like this ----


