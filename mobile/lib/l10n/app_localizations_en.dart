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
  String get welcomeToTailorManager => 'Welcome to Tailor Manager';

  @override
  String get whatsYourPhoneNumber => 'What\'s your phone number?';

  @override
  String get phoneLoginHelp =>
      'Use the WhatsApp number linked to your account.';

  @override
  String get enterPasswordTitle => 'Enter your password';

  @override
  String signingInAs(String phone) {
    return 'Signing in as $phone';
  }

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
  String get phoneInvalid =>
      'Enter a valid number, for example +92 300 1234567';

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
  String get fullNameTooShort => 'Enter at least 2 characters for your name';

  @override
  String get businessName => 'Business name';

  @override
  String get businessNameHint => 'Ayesha Tailors';

  @override
  String get businessNameRequired => 'Enter your business name';

  @override
  String get businessNameTooShort =>
      'Enter at least 2 characters for the business name';

  @override
  String get passwordRequirements =>
      'Use 8+ characters with at least one letter and one number';

  @override
  String get passwordLetterAndNumberRequired =>
      'Include at least one letter and one number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Enter the password again';

  @override
  String get confirmPasswordRequired => 'Confirm your new password';

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
  String get otpExpired => 'Code expired. Request a new one.';

  @override
  String get authDevelopmentOtpHint =>
      'Test environment: view the code in Superadmin > Test OTPs.';

  @override
  String get verifyAndCreateAccount => 'Verify & create account';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get resendOtp => 'Resend code';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get sendingOtp => 'Sending...';

  @override
  String get authOtpResent => 'A new code was sent.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordSubtitle => 'Verify your WhatsApp number';

  @override
  String get passwordOtpPrivacyNotice =>
      'If an account exists, we\'ll send a verification code.';

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
      'Too many attempts. Wait a moment and try again.';

  @override
  String get authInvalidCredentials =>
      'The phone number or password is incorrect.';

  @override
  String get authPhoneRequestFailed =>
      'We could not send a verification code. Check the number or try later.';

  @override
  String get authRegistrationFailed =>
      'We could not start registration. This number may already have an account, or you can try again later.';

  @override
  String get authOtpInvalid =>
      'That code is incorrect or expired. Request a new code.';

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
  String dashboardGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String get accountAccessPaused => 'Account access paused';

  @override
  String get subscriptionExpiredMessage =>
      'Your demo or subscription has expired. Contact support after payment to reactivate access.';

  @override
  String get businessSuspendedMessage =>
      'This business is suspended. Contact support to restore access.';

  @override
  String get membershipInactiveMessage =>
      'Your access to this business is not active. Contact the business owner or support.';

  @override
  String get accountAccessUnavailableMessage =>
      'This business is not available right now. Check your connection or contact support.';

  @override
  String get checkAccessAgain => 'Check again';

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

  @override
  String get customersTitle => 'Customers';

  @override
  String get addCustomer => 'Add customer';

  @override
  String get editCustomer => 'Edit customer';

  @override
  String get customerDetails => 'Customer details';

  @override
  String get customerSearchHint => 'Search name or phone number';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get syncCustomers => 'Sync customers';

  @override
  String get customerChangesSynced => 'Customer changes are backed up.';

  @override
  String customerPendingChanges(int count) {
    return '$count change(s) waiting to sync';
  }

  @override
  String get customerOfflineNotice =>
      'Offline — changes are safe on this phone.';

  @override
  String get retryLabel => 'Retry';

  @override
  String get noCustomersTitle => 'No customers found';

  @override
  String get noCustomersMessage =>
      'Pull down to sync, or add your first customer to get started.';

  @override
  String get noArchivedCustomersTitle => 'No archived customers';

  @override
  String get noArchivedCustomersMessage =>
      'Customers you archive will appear here and can be restored.';

  @override
  String get noCustomerMatches => 'No customer found';

  @override
  String get tryAnotherSearch => 'Try another name or phone number.';

  @override
  String get customerLoadFailed => 'Customers could not be loaded.';

  @override
  String get noPhoneNumber => 'No phone number';

  @override
  String get customerSyncConflict => 'Needs review before syncing';

  @override
  String get customerWaitingToSync =>
      'Saved on this phone and waiting for backup.';

  @override
  String get customerNotFound => 'This customer is no longer available.';

  @override
  String get customerBasicInformation => 'Basic information';

  @override
  String get customerFormHelp =>
      'A name is required. Everything else can be added later.';

  @override
  String get customerName => 'Customer name';

  @override
  String get customerNameHint => 'Ayesha Khan';

  @override
  String get customerNameRequired => 'Enter the customer name.';

  @override
  String get customerNameTooShort => 'Enter at least 2 characters.';

  @override
  String get customerPhone => 'WhatsApp phone number';

  @override
  String get customerAlternatePhone => 'Alternate phone number';

  @override
  String get customerPhoneInvalid =>
      'Enter a valid number, for example +92 300 1234567.';

  @override
  String get customerAlternatePhoneDifferent =>
      'Use a different alternate phone number.';

  @override
  String get customerAddress => 'Address';

  @override
  String get customerAddressHint => 'Street, area and city';

  @override
  String get customerNotes => 'Notes';

  @override
  String get customerNotesHint => 'Preferences or important details';

  @override
  String get customerOfflineSaveHelp =>
      'You can save without internet. Backup happens automatically when a connection is available.';

  @override
  String get saveCustomer => 'Save customer';

  @override
  String get customerSavedLocally =>
      'The customer details have been saved successfully.';

  @override
  String get customerContactInformation => 'Contact information';

  @override
  String get notProvided => 'Not provided';

  @override
  String get noCustomerNotes => 'No notes have been added.';

  @override
  String get customerStatusActive => 'Active';

  @override
  String get customerStatusArchived => 'Archived';

  @override
  String get archiveCustomer => 'Archive customer';

  @override
  String get restoreCustomer => 'Restore customer';

  @override
  String get archiveCustomerMessage =>
      'This customer will be hidden from the active list. Their history will remain safe.';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get archiveLabel => 'Archive';

  @override
  String get customerArchived => 'Customer archived.';

  @override
  String get customerRestored => 'Customer restored.';

  @override
  String get customerConflictHelp =>
      'This customer changed on another device. Review the details and save again to confirm your version.';

  @override
  String get doneLabel => 'Done';

  @override
  String get okayLabel => 'OK';

  @override
  String get successTitle => 'Success';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get syncCompleteTitle => 'Sync complete';

  @override
  String get customerSavedTitle => 'Customer saved';

  @override
  String get chooseCustomerPhoto => 'Customer photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get customerPhotoHint => 'Customer image';

  @override
  String get photoSelectionFailed =>
      'The photo could not be selected. Please try another image.';

  @override
  String get customerSaveFailed =>
      'The customer could not be saved. Please review the details and try again.';

  @override
  String get customerCreated => 'Customer since';

  @override
  String get customerUpdated => 'Last updated';

  @override
  String get customerQuickActions => 'Quick actions';

  @override
  String get customerPersonalInformation => 'Personal information';

  @override
  String get customerMoreActions => 'Customer actions';

  @override
  String get featureUnavailableTitle => 'Not available yet';

  @override
  String get featureUnavailableMessage =>
      'This feature will be available in the next module.';

  @override
  String get customerStatusChangeFailed =>
      'The customer status could not be changed. Please try again.';

  @override
  String customersSelected(int count) {
    return '$count selected';
  }

  @override
  String get selectAllCustomers => 'Select all customers';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get archiveSelectedCustomers => 'Archive selected customers';

  @override
  String get restoreSelectedCustomers => 'Restore selected customers';

  @override
  String archiveSelectedCustomersMessage(int count) {
    return 'Archive $count selected customers? They will leave the active list, but their information will remain safe.';
  }

  @override
  String restoreSelectedCustomersMessage(int count) {
    return 'Restore $count selected customers to the active list?';
  }

  @override
  String customersArchived(int count) {
    return '$count customers archived.';
  }

  @override
  String customersRestored(int count) {
    return '$count customers restored.';
  }

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get deletePermanentlyTitle => 'Delete permanently?';

  @override
  String get deletePermanentlyMessage =>
      'This customer\'s information will be erased from every synced device and cannot be recovered.';

  @override
  String deleteSelectedPermanentlyMessage(int count) {
    return 'Permanently delete $count selected customers? Their information will be erased from every synced device and cannot be recovered.';
  }

  @override
  String get deleteLabel => 'Delete';

  @override
  String get customerDeletedPermanently => 'Customer permanently deleted.';

  @override
  String customersDeletedPermanently(int count) {
    return '$count customers permanently deleted.';
  }
}
