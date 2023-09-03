import 'package:go_router/go_router.dart';
import 'package:second_life/router/routes_names.dart';
import 'package:second_life/screen/auth/boarding_screen.dart';



//bool isUserLogin = Prefs.getBool(PrefNames.isLogin) ?? false;

String getInitialRoute() {
  switch (true) {
    case false:
      return RouteNames.onBoarding;
    default:
      return RouteNames.splashScreen;
  }
}

final appRoute = GoRouter(initialLocation: getInitialRoute(), routes: [
  GoRoute(
    path: RouteNames.onBoarding,
    name: RouteNames.onBoarding,
    builder: (context, state) {
      return const OnBoarding();
    },
  ),
  
 
]);
