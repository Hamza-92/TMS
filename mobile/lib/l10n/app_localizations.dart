import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
    Locale.fromSubtags(languageCode: 'ur', scriptCode: 'Latn'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tailor Manager'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urdu;

  /// No description provided for @romanUrdu.
  ///
  /// In en, this message translates to:
  /// **'Roman Urdu'**
  String get romanUrdu;

  /// No description provided for @foundationReady.
  ///
  /// In en, this message translates to:
  /// **'Flutter foundation is running'**
  String get foundationReady;

  /// No description provided for @databaseReady.
  ///
  /// In en, this message translates to:
  /// **'Local database initialized'**
  String get databaseReady;

  /// No description provided for @introTagline.
  ///
  /// In en, this message translates to:
  /// **'Manage customers, measurements, orders and payments with ease.'**
  String get introTagline;

  /// No description provided for @welcomeToTailorManager.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tailor Manager'**
  String get welcomeToTailorManager;

  /// No description provided for @whatsYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'What\'s your phone number?'**
  String get whatsYourPhoneNumber;

  /// No description provided for @phoneLoginHelp.
  ///
  /// In en, this message translates to:
  /// **'Use the WhatsApp number linked to your account.'**
  String get phoneLoginHelp;

  /// No description provided for @enterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPasswordTitle;

  /// No description provided for @signingInAs.
  ///
  /// In en, this message translates to:
  /// **'Signing in as {phone}'**
  String signingInAs(String phone);

  /// No description provided for @tailorIllustrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Tailor working with a tablet beside a dress form'**
  String get tailorIllustrationLabel;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off'**
  String get signInSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @loginIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get loginIdentifier;

  /// No description provided for @loginIdentifierHint.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get loginIdentifierHint;

  /// No description provided for @loginIdentifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number'**
  String get loginIdentifierRequired;

  /// No description provided for @loginIdentifierInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email or phone number'**
  String get loginIdentifierInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @authNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Login will be connected when the authentication API is ready.'**
  String get authNotConnected;

  /// No description provided for @whatsAppPhone.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp phone number'**
  String get whatsAppPhone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+92 300 1234567'**
  String get phoneHint;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number, for example +92 300 1234567'**
  String get phoneInvalid;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your secure 14-day demo for your tailoring business.'**
  String get createAccountSubtitle;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'New to Tailor Manager?'**
  String get noAccountYet;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ayesha Khan'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameRequired;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessName;

  /// No description provided for @businessNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ayesha Tailors'**
  String get businessNameHint;

  /// No description provided for @businessNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your business name'**
  String get businessNameRequired;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Use 8+ characters with at least one letter and one number'**
  String get passwordRequirements;

  /// No description provided for @passwordLetterAndNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Include at least one letter and one number'**
  String get passwordLetterAndNumberRequired;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the password again'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @registrationTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you confirm that this WhatsApp number belongs to you.'**
  String get registrationTermsNotice;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify phone'**
  String get verifyPhone;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phone}'**
  String otpSentTo(String phone);

  /// No description provided for @otpSixDigitsRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the complete 6-digit code'**
  String get otpSixDigitsRequired;

  /// No description provided for @otpExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in {time}'**
  String otpExpiresIn(String time);

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'Code expired. Request a new one.'**
  String get otpExpired;

  /// No description provided for @authDevelopmentOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Test environment: read the OTP from Laravel\'s storage/logs/laravel.log file.'**
  String get authDevelopmentOtpHint;

  /// No description provided for @verifyAndCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify & create account'**
  String get verifyAndCreateAccount;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendOtpIn(int seconds);

  /// No description provided for @sendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sendingOtp;

  /// No description provided for @authOtpResent.
  ///
  /// In en, this message translates to:
  /// **'A new code was sent.'**
  String get authOtpResent;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your WhatsApp number'**
  String get resetPasswordSubtitle;

  /// No description provided for @passwordOtpPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, we\'ll send a verification code.'**
  String get passwordOtpPrivacyNotice;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// No description provided for @chooseNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get chooseNewPassword;

  /// No description provided for @chooseNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password you have not used before.'**
  String get chooseNewPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed. You can now sign in.'**
  String get passwordChangedSuccess;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server. Check your connection and try again.'**
  String get authNetworkError;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment and try again.'**
  String get authTooManyRequests;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The phone number or password is incorrect.'**
  String get authInvalidCredentials;

  /// No description provided for @authPhoneRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not send a verification code. Check the number or try later.'**
  String get authPhoneRequestFailed;

  /// No description provided for @authOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect or expired. Request a new code.'**
  String get authOtpInvalid;

  /// No description provided for @authPasswordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'The password could not be changed. Please restart password recovery.'**
  String get authPasswordResetFailed;

  /// No description provided for @authUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authUnexpectedError;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @dashboardGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboardGoodMorning;

  /// No description provided for @dashboardShopName.
  ///
  /// In en, this message translates to:
  /// **'Ali Tailors'**
  String get dashboardShopName;

  /// No description provided for @dashboardNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashboardNotifications;

  /// No description provided for @dashboardTodaysWork.
  ///
  /// In en, this message translates to:
  /// **'Today\'s work'**
  String get dashboardTodaysWork;

  /// No description provided for @dashboardOrdersDueToday.
  ///
  /// In en, this message translates to:
  /// **'7 orders are due today'**
  String get dashboardOrdersDueToday;

  /// No description provided for @dashboardCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get dashboardCompleted;

  /// No description provided for @dashboardViewOrders.
  ///
  /// In en, this message translates to:
  /// **'View orders'**
  String get dashboardViewOrders;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get dashboardAddCustomer;

  /// No description provided for @dashboardNewOrder.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get dashboardNewOrder;

  /// No description provided for @dashboardMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get dashboardMeasurements;

  /// No description provided for @dashboardRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get dashboardRecordPayment;

  /// No description provided for @dashboardAttentionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Attention needed'**
  String get dashboardAttentionNeeded;

  /// No description provided for @dashboardOverdueOrders.
  ///
  /// In en, this message translates to:
  /// **'Overdue orders'**
  String get dashboardOverdueOrders;

  /// No description provided for @dashboardOverdueOrdersValue.
  ///
  /// In en, this message translates to:
  /// **'3 orders'**
  String get dashboardOverdueOrdersValue;

  /// No description provided for @dashboardPendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Pending payments'**
  String get dashboardPendingPayments;

  /// No description provided for @dashboardPendingPaymentsValue.
  ///
  /// In en, this message translates to:
  /// **'Rs 18,500'**
  String get dashboardPendingPaymentsValue;

  /// No description provided for @dashboardRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get dashboardRecentOrders;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardOrderDetailOne.
  ///
  /// In en, this message translates to:
  /// **'Women\'s suit • Due today'**
  String get dashboardOrderDetailOne;

  /// No description provided for @dashboardOrderDetailTwo.
  ///
  /// In en, this message translates to:
  /// **'Bridal dress • Due tomorrow'**
  String get dashboardOrderDetailTwo;

  /// No description provided for @dashboardReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get dashboardReady;

  /// No description provided for @dashboardInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get dashboardInProgress;

  /// No description provided for @dashboardHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardHome;

  /// No description provided for @dashboardCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get dashboardCalendar;

  /// No description provided for @dashboardCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashboardCustomers;

  /// No description provided for @dashboardCreate.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get dashboardCreate;

  /// No description provided for @dashboardOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardOrders;

  /// No description provided for @dashboardProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashboardProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'ur':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return AppLocalizationsUrLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
