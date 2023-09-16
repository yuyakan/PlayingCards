import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showDialog() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int _counter = prefs.getInt('dialogCounter') ?? 0;
  _counter++;
  if (_counter > 3) {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
    _counter = 0;
  }
  prefs.setInt('dialogCounter', _counter);
}
