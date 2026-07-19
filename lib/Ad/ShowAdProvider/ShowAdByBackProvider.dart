import 'package:high_and_low/Ad/InterstitialAd.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ShowAdByBackProvider.g.dart';

@Riverpod(keepAlive: true)
class ShowAdByBack extends _$ShowAdByBack {
  /// SharedPreferences に保存するキー。
  static const String _prefsKey = 'showAdByBackCounter';

  @override
  int build() {
    // 初期値は 0 を返しつつ、保存済みのカウンタを非同期で読み込んで反映する。
    _loadCounter();
    return 0;
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_prefsKey) ?? 0;
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, state);
  }

  void showAdByBack() {
    _addTimesOfBack();
    if (state > 9) {
      _showInterstitialAd();
      state = 0;
      _saveCounter();
    }
  }

  void _addTimesOfBack() {
    state += 1;
    _saveCounter();
  }

  void _showInterstitialAd() {
    InterstitialAd.instance.show();
  }
}
