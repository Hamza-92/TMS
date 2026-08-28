// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tailor Manager';

  @override
  String get welcome => 'Welcome';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get urdu => 'Urdu';

  @override
  String get romanUrdu => 'Roman Urdu';

  @override
  String get foundationReady => 'Flutter foundation is running';

  @override
  String get databaseReady => 'Local database initialized';

  @override
  String get introTagline =>
      'Manage customers, measurements, orders and payments with ease.';

  @override
  String get tailorIllustrationLabel =>
      'Tailor working with a tablet beside a dress form';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Continue where you left off';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get emailRequired => 'Enter your email address';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get loginIdentifier => 'Email or phone number';

  @override
  String get loginIdentifierHint => 'Email or phone number';

  @override
  String get loginIdentifierRequired => 'Enter your email or phone number';

  @override
  String get loginIdentifierInvalid => 'Enter a valid email or phone number';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get authNotConnected =>
      'Login will be connected when the authentication API is ready.';

  @override
  String get whatsAppPhone => 'WhatsApp phone number';

  @override
  String get phoneHint => '+92 300 1234567';

  @override
  String get phoneRequired => 'Enter your phone number';

  @override
  String get phoneInvalid => 'Enter a valid phone number with country code';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle =>
      'Start your secure 14-day demo for your tailoring business.';

  @override
  String get noAccountYet => 'New to Tailor Manager?';

  @override
  String get fullName => 'Your name';

  @override
  String get fullNameHint => 'Ayesha Khan';

  @override
  String get fullNameRequired => 'Enter your full name';

  @override
  String get businessName => 'Business name';

  @override
  String get businessNameHint => 'Ayesha Tailors';

  @override
  String get businessNameRequired => 'Enter your business name';

  @override
  String get passwordRequirements =>
      'Use at least 8 characters with a letter and number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Enter the password again';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registrationTermsNotice =>
      'By continuing, you confirm that this WhatsApp number belongs to you.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get verifyPhone => 'Verify phone';

  @override
  String otpSentTo(String phone) {
    return 'Enter the 6-digit code sent to $phone';
  }

  @override
  String get otpSixDigitsRequired => 'Enter the complete 6-digit code';

  @override
  String otpExpiresIn(String time) {
    return 'Code expires in $time';
  }

  @override
  String get otpExpired => 'This code has expired';

  @override
  String get authDevelopmentOtpHint =>
      'Test environment: read the OTP from Laravel\'s storage/logs/laravel.log file.';

  @override
  String get verifyAndCreateAccount => 'Verify & create account';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get resendOtp => 'Resend code';

  @override
  String get sendingOtp => 'Sending...';

  @override
  String get authOtpResent => 'A new verification code has been issued.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordSubtitle =>
      'We will verify your WhatsApp number before changing the password.';

  @override
  String get passwordOtpPrivacyNotice =>
      'For your privacy, the response is the same whether or not an account exists.';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get chooseNewPassword => 'New password';

  @override
  String get chooseNewPasswordSubtitle =>
      'Choose a strong password you have not used before.';

  @override
  String get newPassword => 'New password';

  @override
  String get updatePassword => 'Update password';

  @override
  String get passwordChangedSuccess => 'Password changed. You can now sign in.';

  @override
  String get authNetworkError =>
      'Cannot reach the server. Check your connection and try again.';

  @override
  String get authTooManyRequests =>
      'Too many attempts. Please wait and try again.';

  @override
  String get authInvalidCredentials =>
      'The phone number or password is incorrect.';

  @override
  String get authPhoneRequestFailed =>
      'We could not send a verification code. Check the number or try later.';

  @override
  String get authOtpInvalid =>
      'The verification code is incorrect, expired, or already used.';

  @override
  String get authPasswordResetFailed =>
      'The password could not be changed. Please restart password recovery.';

  @override
  String get authUnexpectedError => 'Something went wrong. Please try again.';

  @override
  String get signOut => 'Sign out';

  @override
  String get dashboardGoodMorning => 'Good morning';

  @override
  String get dashboardShopName => 'Ali Tailors';

  @override
  String get dashboardNotifications => 'Notifications';

  @override
  String get dashboardTodaysWork => 'Today\'s work';

  @override
  String get dashboardOrdersDueToday => '7 orders are due today';

  @override
  String get dashboardCompleted => 'completed';

  @override
  String get dashboardViewOrders => 'View orders';

  @override
  String get dashboardQuickActions => 'Quick actions';

  @override
  String get dashboardAddCustomer => 'Add customer';

  @override
  String get dashboardNewOrder => 'New order';

  @override
  String get dashboardMeasurements => 'Measurements';

  @override
  String get dashboardRecordPayment => 'Record payment';

  @override
  String get dashboardAttentionNeeded => 'Attention needed';

  @override
  String get dashboardOverdueOrders => 'Overdue orders';

  @override
  String get dashboardOverdueOrdersValue => '3 orders';

  @override
  String get dashboardPendingPayments => 'Pending payments';

  @override
  String get dashboardPendingPaymentsValue => 'Rs 18,500';

  @override
  String get dashboardRecentOrders => 'Recent orders';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get dashboardOrderDetailOne => 'Women\'s suit • Due today';

  @override
  String get dashboardOrderDetailTwo => 'Bridal dress • Due tomorrow';

  @override
  String get dashboardReady => 'Ready';

  @override
  String get dashboardInProgress => 'In progress';

  @override
  String get dashboardHome => 'Home';

  @override
  String get dashboardCalendar => 'Calendar';

  @override
  String get dashboardCustomers => 'Customers';

  @override
  String get dashboardCreate => 'Create new';

  @override
  String get dashboardOrders => 'Orders';

  @override
  String get dashboardProfile => 'Profile';
}
