
import 'package:flutter/material.dart';

class LoginScreenNotifier extends ChangeNotifier {
  bool isVisible = false;
 TextEditingController referController = TextEditingController();
 FocusNode referCodeFocusNode = FocusNode();

  void changeVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  
  
}
