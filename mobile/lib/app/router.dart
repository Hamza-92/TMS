import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/presentation/screens/entry_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/login_password_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/login_phone_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/password_otp_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/registration_otp_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/registration_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:tailor_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:tailor_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tailor_app/features/customers/presentation/screens/customer_detail_screen.dart';
import 'package:tailor_app/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:tailor_app/features/customers/presentation/screens/customer_list_screen.dart';
import 'package:tailor_app/features/measurements/presentation/screens/measurement_detail_screen.dart';
import 'package:tailor_app/features/measurements/presentation/screens/measurement_form_screen.dart';
import 'package:tailor_app/features/measurements/presentation/screens/measurement_profile_list_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const EntryScreen()),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login/phone',
      builder: (context, state) => const LoginPhoneScreen(),
    ),
    GoRoute(
      path: '/login/password',
      builder: (context, state) {
        final draft = state.extra;
        return draft is LoginDraft
            ? LoginPasswordScreen(draft: draft)
            : const LoginPhoneScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/register/otp',
      builder: (context, state) {
        final draft = state.extra;
        return draft is RegistrationDraft
            ? RegistrationOtpScreen(draft: draft)
            : const RegistrationScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(
        initialPhone: state.extra is String ? state.extra! as String : null,
      ),
    ),
    GoRoute(
      path: '/forgot-password/otp',
      builder: (context, state) {
        final draft = state.extra;
        return draft is PasswordOtpDraft
            ? PasswordOtpScreen(draft: draft)
            : const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password/reset',
      builder: (context, state) {
        final draft = state.extra;
        return draft is PasswordResetDraft
            ? ResetPasswordScreen(draft: draft)
            : const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/customers',
      builder: (context, state) => const CustomerListScreen(),
    ),
    GoRoute(
      path: '/customers/new',
      builder: (context, state) => const CustomerFormScreen(),
    ),
    GoRoute(
      path: '/customers/:clientUuid/measurements',
      builder: (context, state) => MeasurementProfileListScreen(
        customerClientUuid: state.pathParameters['clientUuid']!,
      ),
    ),
    GoRoute(
      path: '/customers/:clientUuid/measurements/new',
      builder: (context, state) => MeasurementFormScreen(
        customerClientUuid: state.pathParameters['clientUuid']!,
      ),
    ),
    GoRoute(
      path: '/customers/:clientUuid/measurements/:profileUuid',
      builder: (context, state) => MeasurementDetailScreen(
        customerClientUuid: state.pathParameters['clientUuid']!,
        profileClientUuid: state.pathParameters['profileUuid']!,
      ),
    ),
    GoRoute(
      path: '/customers/:clientUuid',
      builder: (context, state) =>
          CustomerDetailScreen(clientUuid: state.pathParameters['clientUuid']!),
    ),
    GoRoute(
      path: '/customers/:clientUuid/edit',
      builder: (context, state) =>
          CustomerFormScreen(clientUuid: state.pathParameters['clientUuid']!),
    ),
  ],
);
