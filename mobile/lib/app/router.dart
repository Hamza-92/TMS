import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/presentation/screens/entry_screen.dart';
import 'package:tailor_app/features/dashboard/presentation/screens/dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const EntryScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
