import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_wheel/core/utils/service_locator.dart';
import 'package:green_wheel/core/widgets/error_screen.dart';
import 'package:green_wheel/features/bms/cubit/bms_cubit.dart';
import 'package:green_wheel/features/bms/presentation/pages/bms_dashboard_page.dart';
import 'package:green_wheel/features/bms/presentation/pages/bms_devices_page.dart';
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
      ShellRoute(
        builder: (context, state, child) => BlocProvider.value(
          value: locator<BmsCubit>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: BmsDevicesPage.routeName,
            builder: (context, state) => const BmsDevicesPage(),
          ),
          GoRoute(
            path: BmsDashboardPage.routeName,
            builder: (context, state) => const BmsDashboardPage(),
          ),
        ],
      ),
    ],
  );
}
