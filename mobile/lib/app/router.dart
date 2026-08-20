import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/dashboard/presentation/screens/foundation_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const FoundationScreen()),
  ],
);
