import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/ui/home_page.dart';
import 'package:swap_mate_mobile/ui/auth/welcome_view.dart';

import '../ui/user_management_page/user_management_provider.dart';

abstract class Routes {
  Routes._();

  ///main navigation using the app.
  static const WELCOME_ROUTE = "welcome";
  static const HOME_ROUTE = "home";
  static const PROFILE_ROUTE = "profile";

  static const welcome = WelcomeView();
  static const home = HomePage();

  static Route generator(RouteSettings settings) {
    switch (settings.name) {
      case WELCOME_ROUTE:
        return MaterialPageRoute(builder: (context) => welcome);

      case HOME_ROUTE:
        return MaterialPageRoute(builder: (context) => home);

      default:
        return MaterialPageRoute(builder: (context) => welcome);
    }
  }
}
