// Author: Adrienne Chiu (2025)

import 'package:flutter/foundation.dart';

class SessionProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  void setUser(Map<String, dynamic> u) {
    _user = Map<String, dynamic>.from(u);
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
