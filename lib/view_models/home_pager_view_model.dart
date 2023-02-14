import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class HomePagerViewModel with ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  void disposePageController() {
    _pageController.dispose();
    notifyListeners();
  }

  void navigateToPage(int pageIndex, BuildContext context) {
    try {
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn);
    } catch (e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: "Unexpected Error",
        icon: const Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.grey,
        ),
        duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.redAccent,
      ).show(context);
    }
  }
}
