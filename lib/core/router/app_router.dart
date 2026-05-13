import 'package:green_wheel/core/widgets/error_screen.dart';
import 'package:green_wheel/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:green_wheel/features/base/presentation/screens/base_screen.dart';


abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: ErrorScreen.routeName,
        builder: (context, state) => ErrorScreen(error: state.extra as String?),
      ),

      GoRoute(
        path: BaseScreen.routeName,
        builder: (context, state) => const BaseScreen(),
      ),
    ],
  );
}
