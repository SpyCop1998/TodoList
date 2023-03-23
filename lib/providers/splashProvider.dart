import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  bool _status = false;
  bool get status => _status;

  String? _token;
  String? get token => _token;

  String? _userName;
  String? get userName => _userName;

  String? _email;
  String? get email => _email;

  Future<bool> get getUser async {

    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('googleSignInEmail');
    if (email != null) {
      _token=sharedPreferences.getString("secretToken");
      _userName=sharedPreferences.getString("userName");
      _email=sharedPreferences.getString("googleSignInEmail");
      _status = true;
      notifyListeners();

      return _status;
    } else {
      return _status;
    }
  }
}
