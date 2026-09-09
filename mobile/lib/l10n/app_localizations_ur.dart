// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'Tailor Manager';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get language => 'زبان';

  @override
  String get english => 'انگریزی';

  @override
  String get urdu => 'اردو';

  @override
  String get romanUrdu => 'رومن اردو';

  @override
  String get foundationReady => 'فلٹر کی بنیاد چل رہی ہے';

  @override
  String get databaseReady => 'مقامی ڈیٹا بیس تیار ہے';

  @override
  String get introTagline =>
      'اپنے گاہک، پیمائشیں، آرڈرز اور ادائیگیاں آسانی سے سنبھالیں۔';

  @override
  String get welcomeToTailorManager => 'ٹیلر مینیجر میں خوش آمدید';

  @override
  String get whatsYourPhoneNumber => 'آپ کا فون نمبر کیا ہے؟';

  @override
  String get phoneLoginHelp =>
      'اپنے اکاؤنٹ سے منسلک واٹس ایپ نمبر استعمال کریں۔';

  @override
  String get enterPasswordTitle => 'اپنا پاس ورڈ درج کریں';

  @override
  String signingInAs(String phone) {
    return '$phone سے سائن اِن کر رہے ہیں';
  }

  @override
  String get tailorIllustrationLabel =>
      'لباس کے سانچے کے پاس ٹیبلٹ استعمال کرتا ہوا درزی';

  @override
  String get welcomeBack => 'خوش آمدید';

  @override
  String get signInSubtitle => 'اپنا کام وہیں سے جاری رکھیں';

  @override
  String get emailAddress => 'ای میل';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get passwordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get signIn => 'سائن اِن';

  @override
  String get emailRequired => 'اپنا ای میل درج کریں';

  @override
  String get emailInvalid => 'درست ای میل درج کریں';

  @override
  String get loginIdentifier => 'ای میل یا فون نمبر';

  @override
  String get loginIdentifierHint => 'ای میل یا فون نمبر';

  @override
  String get loginIdentifierRequired => 'اپنا ای میل یا فون نمبر درج کریں';

  @override
  String get loginIdentifierInvalid => 'درست ای میل یا فون نمبر درج کریں';

  @override
  String get passwordRequired => 'اپنا پاس ورڈ درج کریں';

  @override
  String get passwordTooShort => 'پاس ورڈ کم از کم 8 حروف کا ہونا چاہیے';

  @override
  String get showPassword => 'پاس ورڈ دکھائیں';

  @override
  String get hidePassword => 'پاس ورڈ چھپائیں';

  @override
  String get authNotConnected =>
      'لاگ اِن سروس تصدیقی API تیار ہونے پر منسلک کی جائے گی۔';

  @override
  String get whatsAppPhone => 'واٹس ایپ فون نمبر';

  @override
  String get phoneHint => '+92 300 1234567';

  @override
  String get phoneRequired => 'اپنا فون نمبر درج کریں';

  @override
  String get phoneInvalid => 'درست نمبر درج کریں، مثلاً +92 300 1234567';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get createAccountSubtitle =>
      'اپنے درزی کے کاروبار کے لیے محفوظ 14 روزہ ڈیمو شروع کریں۔';

  @override
  String get noAccountYet => 'ٹیلر مینیجر پر نئے ہیں؟';

  @override
  String get fullName => 'آپ کا نام';

  @override
  String get fullNameHint => 'عائشہ خان';

  @override
  String get fullNameRequired => 'اپنا پورا نام درج کریں';

  @override
  String get fullNameTooShort => 'اپنے نام کے لیے کم از کم 2 حروف درج کریں';

  @override
  String get businessName => 'کاروبار کا نام';

  @override
  String get businessNameHint => 'عائشہ ٹیلرز';

  @override
  String get businessNameRequired => 'کاروبار کا نام درج کریں';

  @override
  String get businessNameTooShort =>
      'کاروبار کے نام کے لیے کم از کم 2 حروف درج کریں';

  @override
  String get passwordRequirements =>
      'کم از کم 8 حروف میں ایک حرف اور ایک عدد شامل کریں';

  @override
  String get passwordLetterAndNumberRequired =>
      'کم از کم ایک حرف اور ایک عدد شامل کریں';

  @override
  String get confirmPassword => 'پاس ورڈ کی تصدیق';

  @override
  String get confirmPasswordHint => 'پاس ورڈ دوبارہ درج کریں';

  @override
  String get confirmPasswordRequired => 'نیا پاس ورڈ دوبارہ درج کریں';

  @override
  String get passwordsDoNotMatch => 'پاس ورڈ ایک جیسے نہیں ہیں';

  @override
  String get registrationTermsNotice =>
      'جاری رکھ کر آپ تصدیق کرتے ہیں کہ یہ واٹس ایپ نمبر آپ کا ہے۔';

  @override
  String get continueLabel => 'جاری رکھیں';

  @override
  String get alreadyHaveAccount => 'پہلے سے اکاؤنٹ ہے؟ سائن اِن کریں';

  @override
  String get verifyPhone => 'فون کی تصدیق';

  @override
  String otpSentTo(String phone) {
    return '$phone پر بھیجا گیا 6 ہندسوں کا کوڈ درج کریں';
  }

  @override
  String get otpSixDigitsRequired => 'مکمل 6 ہندسوں کا کوڈ درج کریں';

  @override
  String otpExpiresIn(String time) {
    return 'کوڈ $time میں ختم ہوگا';
  }

  @override
  String get otpExpired => 'کوڈ ختم ہو گیا۔ نیا کوڈ منگوائیں۔';

  @override
  String get authDevelopmentOtpHint =>
      'ٹیسٹ ماحول: کوڈ سپر ایڈمن کے Test OTPs صفحے پر دیکھیں۔';

  @override
  String get verifyAndCreateAccount => 'تصدیق اور اکاؤنٹ بنائیں';

  @override
  String get verifyCode => 'کوڈ کی تصدیق کریں';

  @override
  String get resendOtp => 'کوڈ دوبارہ بھیجیں';

  @override
  String resendOtpIn(int seconds) {
    return 'کوڈ $seconds سیکنڈ بعد دوبارہ بھیجیں';
  }

  @override
  String get sendingOtp => 'بھیجا جا رہا ہے...';

  @override
  String get authOtpResent => 'نیا کوڈ بھیج دیا گیا ہے۔';

  @override
  String get resetPassword => 'پاس ورڈ بحال کریں';

  @override
  String get resetPasswordSubtitle => 'اپنے واٹس ایپ نمبر کی تصدیق کریں';

  @override
  String get passwordOtpPrivacyNotice =>
      'اگر اکاؤنٹ موجود ہوا تو تصدیقی کوڈ بھیج دیا جائے گا۔';

  @override
  String get sendVerificationCode => 'تصدیقی کوڈ بھیجیں';

  @override
  String get chooseNewPassword => 'نیا پاس ورڈ';

  @override
  String get chooseNewPasswordSubtitle =>
      'ایک مضبوط پاس ورڈ منتخب کریں جو پہلے استعمال نہ کیا ہو۔';

  @override
  String get newPassword => 'نیا پاس ورڈ';

  @override
  String get updatePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get passwordChangedSuccess => 'پاس ورڈ تبدیل ہوگیا۔ اب سائن اِن کریں۔';

  @override
  String get authNetworkError =>
      'سرور سے رابطہ نہیں ہو سکا۔ انٹرنیٹ چیک کرکے دوبارہ کوشش کریں۔';

  @override
  String get authTooManyRequests =>
      'بہت زیادہ کوششیں ہو چکی ہیں۔ کچھ دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get authInvalidCredentials => 'فون نمبر یا پاس ورڈ درست نہیں ہے۔';

  @override
  String get authPhoneRequestFailed =>
      'تصدیقی کوڈ نہیں بھیجا جا سکا۔ نمبر چیک کریں یا بعد میں کوشش کریں۔';

  @override
  String get authRegistrationFailed =>
      'رجسٹریشن شروع نہیں ہو سکی۔ ممکن ہے اس نمبر کا اکاؤنٹ پہلے سے موجود ہو، یا کچھ دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get authOtpInvalid => 'کوڈ غلط ہے یا ختم ہو گیا۔ نیا کوڈ منگوائیں۔';

  @override
  String get authPasswordResetFailed =>
      'پاس ورڈ تبدیل نہیں ہو سکا۔ دوبارہ پاس ورڈ بحالی شروع کریں۔';

  @override
  String get authUnexpectedError => 'کچھ غلط ہوگیا۔ دوبارہ کوشش کریں۔';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get dashboardGoodMorning => 'صبح بخیر';

  @override
  String dashboardGreeting(String name) {
    return 'صبح بخیر، $name';
  }

  @override
  String get accountAccessPaused => 'اکاؤنٹ تک رسائی رکی ہوئی ہے';

  @override
  String get subscriptionExpiredMessage =>
      'آپ کا ڈیمو یا سبسکرپشن ختم ہو گیا ہے۔ ادائیگی کے بعد رسائی بحال کروانے کے لیے سپورٹ سے رابطہ کریں۔';

  @override
  String get businessSuspendedMessage =>
      'یہ کاروبار معطل ہے۔ رسائی بحال کروانے کے لیے سپورٹ سے رابطہ کریں۔';

  @override
  String get membershipInactiveMessage =>
      'اس کاروبار تک آپ کی رسائی فعال نہیں ہے۔ کاروبار کے مالک یا سپورٹ سے رابطہ کریں۔';

  @override
  String get accountAccessUnavailableMessage =>
      'یہ کاروبار فی الحال دستیاب نہیں ہے۔ اپنا انٹرنیٹ چیک کریں یا سپورٹ سے رابطہ کریں۔';

  @override
  String get checkAccessAgain => 'دوبارہ چیک کریں';

  @override
  String get dashboardNotifications => 'اطلاعات';

  @override
  String get dashboardTodaysWork => 'آج کا کام';

  @override
  String get dashboardOrdersDueToday => '7 آرڈرز آج مکمل ہونے ہیں';

  @override
  String get dashboardCompleted => 'مکمل';

  @override
  String get dashboardViewOrders => 'آرڈرز دیکھیں';

  @override
  String get dashboardQuickActions => 'فوری کام';

  @override
  String get dashboardAddCustomer => 'گاہک شامل کریں';

  @override
  String get dashboardNewOrder => 'نیا آرڈر';

  @override
  String get dashboardMeasurements => 'پیمائش';

  @override
  String get dashboardRecordPayment => 'ادائیگی درج کریں';

  @override
  String get dashboardAttentionNeeded => 'توجہ درکار';

  @override
  String get dashboardOverdueOrders => 'تاخیر شدہ آرڈرز';

  @override
  String get dashboardOverdueOrdersValue => '3 آرڈرز';

  @override
  String get dashboardPendingPayments => 'بقایا ادائیگیاں';

  @override
  String get dashboardPendingPaymentsValue => '18,500 روپے';

  @override
  String get dashboardRecentOrders => 'حالیہ آرڈرز';

  @override
  String get dashboardSeeAll => 'سب دیکھیں';

  @override
  String get dashboardOrderDetailOne => 'خواتین کا سوٹ • آج تک';

  @override
  String get dashboardOrderDetailTwo => 'دلہن کا لباس • کل تک';

  @override
  String get dashboardReady => 'تیار';

  @override
  String get dashboardInProgress => 'جاری';

  @override
  String get dashboardHome => 'ہوم';

  @override
  String get dashboardCalendar => 'کیلنڈر';

  @override
  String get dashboardCustomers => 'گاہک';

  @override
  String get dashboardCreate => 'نیا بنائیں';

  @override
  String get dashboardOrders => 'آرڈرز';

  @override
  String get dashboardProfile => 'پروفائل';

  @override
  String get customersTitle => 'گاہک';

  @override
  String get addCustomer => 'گاہک شامل کریں';

  @override
  String get editCustomer => 'گاہک میں ترمیم کریں';

  @override
  String get customerDetails => 'گاہک کی تفصیل';

  @override
  String get customerSearchHint => 'نام یا فون نمبر تلاش کریں';

  @override
  String get clearSearch => 'تلاش صاف کریں';

  @override
  String get syncCustomers => 'گاہک سنک کریں';

  @override
  String get customerChangesSynced => 'گاہکوں کی تبدیلیوں کا بیک اپ ہوگیا۔';

  @override
  String customerPendingChanges(int count) {
    return '$count تبدیلیاں سنک ہونے کی منتظر ہیں';
  }

  @override
  String get customerOfflineNotice =>
      'آف لائن — تبدیلیاں اس فون میں محفوظ ہیں۔';

  @override
  String get retryLabel => 'دوبارہ کوشش';

  @override
  String get noCustomersTitle => 'کوئی گاہک نہیں ملا';

  @override
  String get noCustomersMessage =>
      'فہرست ہم وقت کرنے کے لیے نیچے کھینچیں، یا پہلا گاہک شامل کریں۔';

  @override
  String get noArchivedCustomersTitle => 'کوئی محفوظ شدہ گاہک نہیں';

  @override
  String get noArchivedCustomersMessage =>
      'محفوظ فہرست میں ڈالے گئے گاہک یہاں نظر آئیں گے اور دوبارہ بحال کیے جا سکیں گے۔';

  @override
  String get noCustomerMatches => 'کوئی گاہک نہیں ملا';

  @override
  String get tryAnotherSearch => 'کوئی دوسرا نام یا فون نمبر لکھیں۔';

  @override
  String get customerLoadFailed => 'گاہک لوڈ نہیں ہوسکے۔';

  @override
  String get noPhoneNumber => 'فون نمبر موجود نہیں';

  @override
  String get customerSyncConflict => 'سنک سے پہلے جائزہ ضروری ہے';

  @override
  String get customerWaitingToSync =>
      'اس فون میں محفوظ ہے اور بیک اپ کا منتظر ہے۔';

  @override
  String get customerNotFound => 'یہ گاہک اب دستیاب نہیں ہے۔';

  @override
  String get customerBasicInformation => 'بنیادی معلومات';

  @override
  String get customerFormHelp =>
      'نام ضروری ہے۔ باقی معلومات بعد میں بھی شامل کی جاسکتی ہیں۔';

  @override
  String get customerName => 'گاہک کا نام';

  @override
  String get customerNameHint => 'عائشہ خان';

  @override
  String get customerNameRequired => 'گاہک کا نام لکھیں۔';

  @override
  String get customerNameTooShort => 'کم از کم 2 حروف لکھیں۔';

  @override
  String get customerPhone => 'واٹس ایپ فون نمبر';

  @override
  String get customerAlternatePhone => 'دوسرا فون نمبر';

  @override
  String get customerPhoneInvalid => 'درست نمبر لکھیں، مثلاً +92 300 1234567۔';

  @override
  String get customerAlternatePhoneDifferent =>
      'دوسرا فون نمبر مختلف ہونا چاہیے۔';

  @override
  String get customerAddress => 'پتہ';

  @override
  String get customerAddressHint => 'گلی، علاقہ اور شہر';

  @override
  String get customerNotes => 'نوٹس';

  @override
  String get customerNotesHint => 'پسند یا ضروری تفصیل';

  @override
  String get customerOfflineSaveHelp =>
      'انٹرنیٹ کے بغیر بھی محفوظ کرسکتے ہیں۔ رابطہ ملتے ہی بیک اپ خود ہوجائے گا۔';

  @override
  String get saveCustomer => 'گاہک محفوظ کریں';

  @override
  String get customerSavedLocally => 'گاہک کی معلومات کامیابی سے محفوظ ہوگئیں۔';

  @override
  String get customerContactInformation => 'رابطے کی معلومات';

  @override
  String get notProvided => 'فراہم نہیں کیا گیا';

  @override
  String get noCustomerNotes => 'کوئی نوٹس شامل نہیں کیے گئے۔';

  @override
  String get customerStatusActive => 'فعال';

  @override
  String get customerStatusArchived => 'محفوظ شدہ';

  @override
  String get archiveCustomer => 'گاہک محفوظ فہرست میں ڈالیں';

  @override
  String get restoreCustomer => 'گاہک بحال کریں';

  @override
  String get archiveCustomerMessage =>
      'گاہک فعال فہرست سے چھپ جائے گا۔ اس کی تاریخ محفوظ رہے گی۔';

  @override
  String get cancelLabel => 'منسوخ';

  @override
  String get archiveLabel => 'محفوظ کریں';

  @override
  String get customerArchived => 'گاہک محفوظ فہرست میں چلا گیا۔';

  @override
  String get customerRestored => 'گاہک بحال ہوگیا۔';

  @override
  String get customerConflictHelp =>
      'یہ گاہک دوسرے آلے پر تبدیل ہوا ہے۔ تفصیل دیکھ کر اپنا ورژن دوبارہ محفوظ کریں۔';

  @override
  String get doneLabel => 'مکمل';

  @override
  String get okayLabel => 'ٹھیک ہے';

  @override
  String get successTitle => 'کامیاب';

  @override
  String get errorTitle => 'کچھ درست نہیں ہوا';

  @override
  String get syncCompleteTitle => 'ہم وقت مکمل';

  @override
  String get customerSavedTitle => 'گاہک محفوظ ہوگیا';

  @override
  String get chooseCustomerPhoto => 'گاہک کی تصویر';

  @override
  String get takePhoto => 'تصویر کھینچیں';

  @override
  String get chooseFromGallery => 'گیلری سے منتخب کریں';

  @override
  String get removePhoto => 'تصویر ہٹائیں';

  @override
  String get customerPhotoHint => 'گاہک کی تصویر';

  @override
  String get photoSelectionFailed =>
      'تصویر منتخب نہیں ہوسکی۔ کوئی دوسری تصویر آزمائیں۔';

  @override
  String get customerSaveFailed =>
      'گاہک محفوظ نہیں ہوسکا۔ معلومات دیکھ کر دوبارہ کوشش کریں۔';

  @override
  String get customerCreated => 'شمولیت کی تاریخ';

  @override
  String get customerUpdated => 'آخری تبدیلی';

  @override
  String get customerQuickActions => 'فوری کام';

  @override
  String get customerPersonalInformation => 'ذاتی معلومات';

  @override
  String get customerMoreActions => 'گاہک کے اختیارات';

  @override
  String get featureUnavailableTitle => 'ابھی دستیاب نہیں';

  @override
  String get featureUnavailableMessage =>
      'یہ سہولت اگلے ماڈیول میں دستیاب ہوگی۔';

  @override
  String get customerStatusChangeFailed =>
      'گاہک کی حیثیت تبدیل نہیں ہوسکی۔ دوبارہ کوشش کریں۔';

  @override
  String customersSelected(int count) {
    return '$count منتخب';
  }

  @override
  String get selectAllCustomers => 'تمام گاہک منتخب کریں';

  @override
  String get clearSelection => 'انتخاب ختم کریں';

  @override
  String get archiveSelectedCustomers => 'منتخب گاہک محفوظ فہرست میں ڈالیں';

  @override
  String get restoreSelectedCustomers => 'منتخب گاہک بحال کریں';

  @override
  String archiveSelectedCustomersMessage(int count) {
    return '$count منتخب گاہک محفوظ فہرست میں ڈالیں؟ وہ فعال فہرست سے ہٹ جائیں گے لیکن ان کی معلومات محفوظ رہیں گی۔';
  }

  @override
  String restoreSelectedCustomersMessage(int count) {
    return '$count منتخب گاہک فعال فہرست میں بحال کریں؟';
  }

  @override
  String customersArchived(int count) {
    return '$count گاہک محفوظ فہرست میں منتقل ہوگئے۔';
  }

  @override
  String customersRestored(int count) {
    return '$count گاہک بحال ہوگئے۔';
  }

  @override
  String get deletePermanently => 'ہمیشہ کے لیے حذف کریں';

  @override
  String get deletePermanentlyTitle => 'ہمیشہ کے لیے حذف کریں؟';

  @override
  String get deletePermanentlyMessage =>
      'اس گاہک کی معلومات تمام ہم وقت آلات سے مٹا دی جائیں گی اور واپس حاصل نہیں ہوسکیں گی۔';

  @override
  String deleteSelectedPermanentlyMessage(int count) {
    return '$count منتخب گاہک ہمیشہ کے لیے حذف کریں؟ ان کی معلومات تمام ہم وقت آلات سے مٹا دی جائیں گی اور واپس حاصل نہیں ہوسکیں گی۔';
  }

  @override
  String get deleteLabel => 'حذف کریں';

  @override
  String get customerDeletedPermanently => 'گاہک ہمیشہ کے لیے حذف ہوگیا۔';

  @override
  String customersDeletedPermanently(int count) {
    return '$count گاہک ہمیشہ کے لیے حذف ہوگئے۔';
  }

  @override
  String get measurementsTitle => 'پیمائشیں';

  @override
  String get measurementProfilesSubtitle => 'اس گاہک کے محفوظ فٹنگ پروفائل';

  @override
  String get addMeasurements => 'پیمائش شامل کریں';

  @override
  String get noMeasurementsTitle => 'ابھی کوئی پیمائش نہیں';

  @override
  String get noMeasurementsMessage =>
      'شروع کرنے کے لیے گاہک کا پہلا فٹنگ پروفائل شامل کریں۔';

  @override
  String get measurementTemplate => 'لباس کی قسم';

  @override
  String get selectMeasurementTemplate => 'لباس کی قسم منتخب کریں';

  @override
  String get measurementProfileName => 'پروفائل کا نام';

  @override
  String get measurementProfileNameHint => 'عام فٹنگ';

  @override
  String get preferredUnit => 'پیمائش کی اکائی';

  @override
  String get inches => 'انچ';

  @override
  String get centimetres => 'سینٹی میٹر';

  @override
  String get measurementValues => 'پیمائش کی تفصیل';

  @override
  String get measurementNotes => 'پیمائش کے نوٹس';

  @override
  String get measurementNotesHint => 'فٹنگ کی پسند یا خاص ہدایات';

  @override
  String get saveMeasurements => 'پیمائش محفوظ کریں';

  @override
  String get measurementSavedTitle => 'پیمائش محفوظ ہوگئی';

  @override
  String get measurementSavedMessage => 'فٹنگ پروفائل کامیابی سے محفوظ ہوگیا۔';

  @override
  String get measurementSaveFailed =>
      'پیمائش محفوظ نہیں ہوسکی۔ قدریں دیکھ کر دوبارہ کوشش کریں۔';

  @override
  String get measurementTemplateRequired => 'لباس کی قسم منتخب کریں۔';

  @override
  String get measurementProfileNameRequired => 'پروفائل کا نام لکھیں۔';

  @override
  String get measurementValueRequired => 'یہ پیمائش لکھیں۔';

  @override
  String get measurementValueInvalid => 'درست پیمائش لکھیں۔';

  @override
  String get latestMeasurements => 'تازہ ترین پیمائش';

  @override
  String get measurementHistory => 'پیمائش کی تاریخ';

  @override
  String measurementRevision(int number) {
    return 'ترمیم $number';
  }

  @override
  String get measuredOn => 'پیمائش کی تاریخ';

  @override
  String measurementFieldsCount(int count) {
    return '$count پیمائشیں';
  }

  @override
  String get measurementLoadFailed => 'پیمائشیں لوڈ نہیں ہوسکیں۔';

  @override
  String get measurementTemplateLoadFailed =>
      'لباس کی اقسام لوڈ نہیں ہوسکیں۔ دوبارہ کوشش کریں۔';

  @override
  String get measurementProfileNotFound =>
      'یہ پیمائش پروفائل اب دستیاب نہیں ہے۔';

  @override
  String get measurementRequiredHint => 'ضروری خانوں پر * کا نشان ہے';

  @override
  String get addMeasurementRevision => 'نئی پیمائش شامل کریں';

  @override
  String get measurementRevisionSavedMessage =>
      'نئی پیمائش کامیابی سے محفوظ ہوگئی۔';

  @override
  String get measurementSectionUpperGarment => 'اوپری لباس';

  @override
  String get measurementSectionUpperBody => 'جسم کا اوپری حصہ';

  @override
  String get measurementSectionSleeves => 'آستینیں';

  @override
  String get measurementSectionLowerGarment => 'زیریں لباس';

  @override
  String get measurementSectionGarment => 'لباس';

  @override
  String get measurementSectionCollar => 'گلا';

  @override
  String get measurementSectionLengths => 'لمبائیاں';

  @override
  String get measurementSectionBody => 'جسم';

  @override
  String get measurementSectionLeg => 'ٹانگ';

  @override
  String get measurementSectionCustom => 'حسبِ ضرورت پیمائشیں';

  @override
  String get manageMeasurementTemplates => 'پیمائش کے سانچوں کا انتظام';

  @override
  String get measurementTemplatesTitle => 'پیمائش کے سانچے';

  @override
  String get measurementTemplatesSubtitle =>
      'دوبارہ استعمال ہونے والے لباس کے پیمائشی مجموعے بنائیں';

  @override
  String get newMeasurementTemplate => 'نیا سانچہ';

  @override
  String get builtInTemplate => 'پہلے سے موجود';

  @override
  String get customTemplate => 'حسبِ ضرورت';

  @override
  String get copyAndCustomize => 'نقل بنا کر تبدیل کریں';

  @override
  String get editTemplate => 'سانچہ تبدیل کریں';

  @override
  String get templateName => 'سانچے کا نام';

  @override
  String get templateNameUrdu => 'اردو میں سانچے کا نام';

  @override
  String get templateNameRomanUrdu => 'رومن اردو میں سانچے کا نام';

  @override
  String get templateFields => 'پیمائش کے خانے';

  @override
  String get addMeasurementField => 'خانہ شامل کریں';

  @override
  String get editMeasurementField => 'خانہ تبدیل کریں';

  @override
  String get fieldNameEnglish => 'انگریزی میں خانے کا نام';

  @override
  String get fieldNameUrdu => 'اردو میں خانے کا نام';

  @override
  String get fieldNameRomanUrdu => 'رومن اردو میں خانے کا نام';

  @override
  String get fieldSection => 'حصہ';

  @override
  String get fieldType => 'قدر کی قسم';

  @override
  String get numericValue => 'عدد';

  @override
  String get textValue => 'متن';

  @override
  String get usesMeasurementUnit => 'انچ/سینٹی میٹر استعمال کریں';

  @override
  String get requiredField => 'لازمی خانہ';

  @override
  String get saveField => 'خانہ محفوظ کریں';

  @override
  String get removeField => 'خانہ ہٹائیں';

  @override
  String get saveTemplate => 'سانچہ محفوظ کریں';

  @override
  String get templateSavedTitle => 'سانچہ محفوظ ہوگیا';

  @override
  String get templateSavedMessage => 'پیمائش کا سانچہ استعمال کے لیے تیار ہے۔';

  @override
  String get templateSaveFailed =>
      'سانچہ محفوظ نہیں ہوسکا۔ خانے جانچ کر دوبارہ کوشش کریں۔';

  @override
  String get templateNameRequired => 'سانچے کا نام درج کریں۔';

  @override
  String get fieldNameRequired => 'خانے کا نام درج کریں۔';

  @override
  String get atLeastOneFieldRequired =>
      'کم از کم ایک پیمائش کا خانہ شامل کریں۔';

  @override
  String get addCustomerMeasurementField => 'حسبِ ضرورت خانہ شامل کریں';

  @override
  String get customerMeasurementFields => 'صرف اس گاہک کے خانے';

  @override
  String get customerFieldHint =>
      'یہ خانے صرف اسی پیمائشی پروفائل پر لاگو ہوں گے۔';
}

/// The translations for Urdu, using the Latin script (`ur_Latn`).
class AppLocalizationsUrLatn extends AppLocalizationsUr {
  AppLocalizationsUrLatn() : super('ur_Latn');

  @override
  String get appName => 'Tailor Manager';

  @override
  String get welcome => 'Khush Aamdeed';

  @override
  String get language => 'Zabaan';

  @override
  String get english => 'Angrezi';

  @override
  String get urdu => 'Urdu';

  @override
  String get romanUrdu => 'Roman Urdu';

  @override
  String get foundationReady => 'Flutter foundation chal rahi hai';

  @override
  String get databaseReady => 'Local database tayyar hai';

  @override
  String get introTagline =>
      'Apne customers, measurements, orders aur payments asaani se sambhalein.';

  @override
  String get welcomeToTailorManager => 'Tailor Manager mein khush aamdeed';

  @override
  String get whatsYourPhoneNumber => 'Aap ka phone number kya hai?';

  @override
  String get phoneLoginHelp =>
      'Apne account se linked WhatsApp number istemal karein.';

  @override
  String get enterPasswordTitle => 'Apna password likhein';

  @override
  String signingInAs(String phone) {
    return '$phone se sign in kar rahe hain';
  }

  @override
  String get tailorIllustrationLabel =>
      'Dress form ke paas tablet istemal karta darzi';

  @override
  String get welcomeBack => 'Khush aamdeed';

  @override
  String get signInSubtitle => 'Apna kaam wahin se jaari rakhein';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Apna password likhein';

  @override
  String get forgotPassword => 'Password bhool gaye?';

  @override
  String get signIn => 'Sign in';

  @override
  String get emailRequired => 'Apna email address likhein';

  @override
  String get emailInvalid => 'Durust email address likhein';

  @override
  String get loginIdentifier => 'Email ya phone number';

  @override
  String get loginIdentifierHint => 'Email ya phone number';

  @override
  String get loginIdentifierRequired => 'Apna email ya phone number likhein';

  @override
  String get loginIdentifierInvalid => 'Durust email ya phone number likhein';

  @override
  String get passwordRequired => 'Apna password likhein';

  @override
  String get passwordTooShort =>
      'Password kam az kam 8 characters ka hona chahiye';

  @override
  String get showPassword => 'Password dikhayein';

  @override
  String get hidePassword => 'Password chhupayein';

  @override
  String get authNotConnected =>
      'Authentication API tayyar hone par login connect kiya jayega.';

  @override
  String get whatsAppPhone => 'WhatsApp phone number';

  @override
  String get phoneHint => '+92 300 1234567';

  @override
  String get phoneRequired => 'Apna phone number likhein';

  @override
  String get phoneInvalid =>
      'Durust number likhein, misal ke taur par +92 300 1234567';

  @override
  String get createAccount => 'Account banayein';

  @override
  String get createAccountSubtitle =>
      'Apne tailoring business ke liye mehfooz 14 din ka demo shuru karein.';

  @override
  String get noAccountYet => 'Tailor Manager par naye hain?';

  @override
  String get fullName => 'Aap ka naam';

  @override
  String get fullNameHint => 'Ayesha Khan';

  @override
  String get fullNameRequired => 'Apna poora naam likhein';

  @override
  String get fullNameTooShort =>
      'Apne naam ke liye kam az kam 2 characters likhein';

  @override
  String get businessName => 'Business ka naam';

  @override
  String get businessNameHint => 'Ayesha Tailors';

  @override
  String get businessNameRequired => 'Business ka naam likhein';

  @override
  String get businessNameTooShort =>
      'Business ke naam ke liye kam az kam 2 characters likhein';

  @override
  String get passwordRequirements =>
      '8 ya zyada characters mein kam az kam aik letter aur aik number rakhein';

  @override
  String get passwordLetterAndNumberRequired =>
      'Kam az kam aik letter aur aik number shamil karein';

  @override
  String get confirmPassword => 'Password confirm karein';

  @override
  String get confirmPasswordHint => 'Password dobara likhein';

  @override
  String get confirmPasswordRequired => 'Naya password dobara likhein';

  @override
  String get passwordsDoNotMatch => 'Passwords aik jaise nahin hain';

  @override
  String get registrationTermsNotice =>
      'Jaari rakh kar aap tasdeeq karte hain ke yeh WhatsApp number aap ka hai.';

  @override
  String get continueLabel => 'Jaari rakhein';

  @override
  String get alreadyHaveAccount => 'Pehle se account hai? Sign in karein';

  @override
  String get verifyPhone => 'Phone verify karein';

  @override
  String otpSentTo(String phone) {
    return '$phone par bheja gaya 6 digit code likhein';
  }

  @override
  String get otpSixDigitsRequired => 'Poora 6 digit code likhein';

  @override
  String otpExpiresIn(String time) {
    return 'Code $time mein expire hoga';
  }

  @override
  String get otpExpired => 'Code expire ho gaya. Naya code mangwayein.';

  @override
  String get authDevelopmentOtpHint =>
      'Test environment: code Superadmin ke Test OTPs page par dekhein.';

  @override
  String get verifyAndCreateAccount => 'Verify karke account banayein';

  @override
  String get verifyCode => 'Code verify karein';

  @override
  String get resendOtp => 'Code dobara bhejein';

  @override
  String resendOtpIn(int seconds) {
    return 'Code ${seconds}s baad dobara bhejein';
  }

  @override
  String get sendingOtp => 'Bheja ja raha hai...';

  @override
  String get authOtpResent => 'Naya code bhej diya gaya hai.';

  @override
  String get resetPassword => 'Password reset karein';

  @override
  String get resetPasswordSubtitle => 'Apna WhatsApp number verify karein';

  @override
  String get passwordOtpPrivacyNotice =>
      'Agar account mojood hua to verification code bhej diya jayega.';

  @override
  String get sendVerificationCode => 'Verification code bhejein';

  @override
  String get chooseNewPassword => 'Naya password';

  @override
  String get chooseNewPasswordSubtitle =>
      'Aisa mazboot password chunain jo pehle istemal na kiya ho.';

  @override
  String get newPassword => 'Naya password';

  @override
  String get updatePassword => 'Password update karein';

  @override
  String get passwordChangedSuccess =>
      'Password badal gaya. Ab sign in karein.';

  @override
  String get authNetworkError =>
      'Server se rabta nahin ho saka. Internet check karke dobara koshish karein.';

  @override
  String get authTooManyRequests =>
      'Bohat zyada koshishain ho chuki hain. Thori dair baad dobara try karein.';

  @override
  String get authInvalidCredentials =>
      'Phone number ya password durust nahin hai.';

  @override
  String get authPhoneRequestFailed =>
      'Verification code nahin bheja ja saka. Number check karein ya baad mein try karein.';

  @override
  String get authRegistrationFailed =>
      'Registration shuru nahin ho saki. Is number ka account pehle se ho sakta hai, ya baad mein dobara try karein.';

  @override
  String get authOtpInvalid =>
      'Code ghalat ya expire ho gaya hai. Naya code mangwayein.';

  @override
  String get authPasswordResetFailed =>
      'Password badla nahin ja saka. Password recovery dobara shuru karein.';

  @override
  String get authUnexpectedError =>
      'Kuch ghalat ho gaya. Dobara koshish karein.';

  @override
  String get signOut => 'Sign out';

  @override
  String get dashboardGoodMorning => 'Subah bakhair';

  @override
  String dashboardGreeting(String name) {
    return 'Subah bakhair, $name';
  }

  @override
  String get accountAccessPaused => 'Account access ruki hui hai';

  @override
  String get subscriptionExpiredMessage =>
      'Aap ka demo ya subscription khatam ho gaya hai. Payment ke baad access bahal karwane ke liye support se rabta karein.';

  @override
  String get businessSuspendedMessage =>
      'Yeh business suspended hai. Access bahal karwane ke liye support se rabta karein.';

  @override
  String get membershipInactiveMessage =>
      'Is business tak aap ki access active nahin hai. Business owner ya support se rabta karein.';

  @override
  String get accountAccessUnavailableMessage =>
      'Yeh business filhal available nahin hai. Internet check karein ya support se rabta karein.';

  @override
  String get checkAccessAgain => 'Dobara check karein';

  @override
  String get dashboardNotifications => 'Notifications';

  @override
  String get dashboardTodaysWork => 'Aaj ka kaam';

  @override
  String get dashboardOrdersDueToday => '7 orders aaj mukammal hone hain';

  @override
  String get dashboardCompleted => 'mukammal';

  @override
  String get dashboardViewOrders => 'Orders dekhein';

  @override
  String get dashboardQuickActions => 'Fori kaam';

  @override
  String get dashboardAddCustomer => 'Customer shamil karein';

  @override
  String get dashboardNewOrder => 'Naya order';

  @override
  String get dashboardMeasurements => 'Measurements';

  @override
  String get dashboardRecordPayment => 'Payment likhein';

  @override
  String get dashboardAttentionNeeded => 'Tawajjoh darkar';

  @override
  String get dashboardOverdueOrders => 'Late orders';

  @override
  String get dashboardOverdueOrdersValue => '3 orders';

  @override
  String get dashboardPendingPayments => 'Baqaya payments';

  @override
  String get dashboardPendingPaymentsValue => 'Rs 18,500';

  @override
  String get dashboardRecentOrders => 'Haliya orders';

  @override
  String get dashboardSeeAll => 'Sab dekhein';

  @override
  String get dashboardOrderDetailOne => 'Women\'s suit • Aaj tak';

  @override
  String get dashboardOrderDetailTwo => 'Bridal dress • Kal tak';

  @override
  String get dashboardReady => 'Tayyar';

  @override
  String get dashboardInProgress => 'Jaari';

  @override
  String get dashboardHome => 'Home';

  @override
  String get dashboardCalendar => 'Calendar';

  @override
  String get dashboardCustomers => 'Customers';

  @override
  String get dashboardCreate => 'Naya banayein';

  @override
  String get dashboardOrders => 'Orders';

  @override
  String get dashboardProfile => 'Profile';

  @override
  String get customersTitle => 'Customers';

  @override
  String get addCustomer => 'Customer shamil karein';

  @override
  String get editCustomer => 'Customer edit karein';

  @override
  String get customerDetails => 'Customer ki tafseel';

  @override
  String get customerSearchHint => 'Naam ya phone number talash karein';

  @override
  String get clearSearch => 'Search saaf karein';

  @override
  String get syncCustomers => 'Customers sync karein';

  @override
  String get customerChangesSynced => 'Customer changes ka backup ho gaya.';

  @override
  String customerPendingChanges(int count) {
    return '$count change(s) sync ke muntazir';
  }

  @override
  String get customerOfflineNotice =>
      'Offline — changes is phone mein mehfooz hain.';

  @override
  String get retryLabel => 'Dobara koshish';

  @override
  String get noCustomersTitle => 'Koi customer nahin mila';

  @override
  String get noCustomersMessage =>
      'List sync karne ke liye neeche khenchain, ya pehla customer shamil karein.';

  @override
  String get noArchivedCustomersTitle => 'Koi archived customer nahin';

  @override
  String get noArchivedCustomersMessage =>
      'Archive kiye gaye customers yahan nazar aayenge aur restore kiye ja sakenge.';

  @override
  String get noCustomerMatches => 'Customer nahin mila';

  @override
  String get tryAnotherSearch => 'Koi aur naam ya phone number likhein.';

  @override
  String get customerLoadFailed => 'Customers load nahin ho sake.';

  @override
  String get noPhoneNumber => 'Phone number nahin diya';

  @override
  String get customerSyncConflict => 'Sync se pehle review zaroori hai';

  @override
  String get customerWaitingToSync =>
      'Is phone mein save hai aur backup ka muntazir hai.';

  @override
  String get customerNotFound => 'Yeh customer ab available nahin hai.';

  @override
  String get customerBasicInformation => 'Bunyadi maloomat';

  @override
  String get customerFormHelp =>
      'Naam zaroori hai. Baqi maloomat baad mein bhi di ja sakti hai.';

  @override
  String get customerName => 'Customer ka naam';

  @override
  String get customerNameHint => 'Ayesha Khan';

  @override
  String get customerNameRequired => 'Customer ka naam likhein.';

  @override
  String get customerNameTooShort => 'Kam az kam 2 characters likhein.';

  @override
  String get customerPhone => 'WhatsApp phone number';

  @override
  String get customerAlternatePhone => 'Doosra phone number';

  @override
  String get customerPhoneInvalid =>
      'Durust number likhein, misal +92 300 1234567.';

  @override
  String get customerAlternatePhoneDifferent =>
      'Doosra phone number mukhtalif hona chahiye.';

  @override
  String get customerAddress => 'Pata';

  @override
  String get customerAddressHint => 'Gali, ilaqa aur shehar';

  @override
  String get customerNotes => 'Notes';

  @override
  String get customerNotesHint => 'Pasand ya zaroori tafseel';

  @override
  String get customerOfflineSaveHelp =>
      'Internet ke baghair bhi save kar sakte hain. Connection milte hi backup khud ho jayega.';

  @override
  String get saveCustomer => 'Customer save karein';

  @override
  String get customerSavedLocally =>
      'Customer ki maloomat kamyabi se save ho gayi.';

  @override
  String get customerContactInformation => 'Rabtay ki maloomat';

  @override
  String get notProvided => 'Nahin diya gaya';

  @override
  String get noCustomerNotes => 'Koi notes shamil nahin kiye gaye.';

  @override
  String get customerStatusActive => 'Active';

  @override
  String get customerStatusArchived => 'Archived';

  @override
  String get archiveCustomer => 'Customer archive karein';

  @override
  String get restoreCustomer => 'Customer restore karein';

  @override
  String get archiveCustomerMessage =>
      'Customer active list se chhup jayega. Uski history mehfooz rahegi.';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get archiveLabel => 'Archive';

  @override
  String get customerArchived => 'Customer archive ho gaya.';

  @override
  String get customerRestored => 'Customer restore ho gaya.';

  @override
  String get customerConflictHelp =>
      'Yeh customer doosre device par badla hai. Tafseel review karke apna version dobara save karein.';

  @override
  String get doneLabel => 'Done';

  @override
  String get okayLabel => 'Theek hai';

  @override
  String get successTitle => 'Kamyaab';

  @override
  String get errorTitle => 'Kuch durust nahin hua';

  @override
  String get syncCompleteTitle => 'Sync mukammal';

  @override
  String get customerSavedTitle => 'Customer save ho gaya';

  @override
  String get chooseCustomerPhoto => 'Customer photo';

  @override
  String get takePhoto => 'Photo khenchain';

  @override
  String get chooseFromGallery => 'Gallery se chunain';

  @override
  String get removePhoto => 'Photo hata dein';

  @override
  String get customerPhotoHint => 'Customer image';

  @override
  String get photoSelectionFailed =>
      'Photo select nahin ho saki. Koi aur image try karein.';

  @override
  String get customerSaveFailed =>
      'Customer save nahin ho saka. Maloomat dekh kar dobara koshish karein.';

  @override
  String get customerCreated => 'Customer banne ki tareekh';

  @override
  String get customerUpdated => 'Aakhri tabdeeli';

  @override
  String get customerQuickActions => 'Fori kaam';

  @override
  String get customerPersonalInformation => 'Zaati maloomat';

  @override
  String get customerMoreActions => 'Customer ke options';

  @override
  String get featureUnavailableTitle => 'Abhi available nahin';

  @override
  String get featureUnavailableMessage =>
      'Yeh feature aglay module mein available hoga.';

  @override
  String get customerStatusChangeFailed =>
      'Customer ka status tabdeel nahin ho saka. Dobara koshish karein.';

  @override
  String customersSelected(int count) {
    return '$count selected';
  }

  @override
  String get selectAllCustomers => 'Sab customers select karein';

  @override
  String get clearSelection => 'Selection khatam karein';

  @override
  String get archiveSelectedCustomers => 'Selected customers archive karein';

  @override
  String get restoreSelectedCustomers => 'Selected customers restore karein';

  @override
  String archiveSelectedCustomersMessage(int count) {
    return '$count selected customers archive karein? Woh active list se hat jayenge lekin unki maloomat mehfooz rahegi.';
  }

  @override
  String restoreSelectedCustomersMessage(int count) {
    return '$count selected customers active list mein restore karein?';
  }

  @override
  String customersArchived(int count) {
    return '$count customers archive ho gaye.';
  }

  @override
  String customersRestored(int count) {
    return '$count customers restore ho gaye.';
  }

  @override
  String get deletePermanently => 'Hamesha ke liye delete karein';

  @override
  String get deletePermanentlyTitle => 'Hamesha ke liye delete karein?';

  @override
  String get deletePermanentlyMessage =>
      'Is customer ki maloomat har synced device se mita di jayegi aur wapas hasil nahin ho sakegi.';

  @override
  String deleteSelectedPermanentlyMessage(int count) {
    return '$count selected customers hamesha ke liye delete karein? Unki maloomat har synced device se mita di jayegi aur wapas hasil nahin ho sakegi.';
  }

  @override
  String get deleteLabel => 'Delete';

  @override
  String get customerDeletedPermanently =>
      'Customer hamesha ke liye delete ho gaya.';

  @override
  String customersDeletedPermanently(int count) {
    return '$count customers hamesha ke liye delete ho gaye.';
  }

  @override
  String get measurementsTitle => 'Measurements';

  @override
  String get measurementProfilesSubtitle => 'Is customer ke fitting profiles';

  @override
  String get addMeasurements => 'Measurements shamil karein';

  @override
  String get noMeasurementsTitle => 'Abhi measurements nahin hain';

  @override
  String get noMeasurementsMessage =>
      'Shuru karne ke liye customer ka pehla fitting profile shamil karein.';

  @override
  String get measurementTemplate => 'Libas ki qisam';

  @override
  String get selectMeasurementTemplate => 'Libas ki qisam select karein';

  @override
  String get measurementProfileName => 'Profile ka naam';

  @override
  String get measurementProfileNameHint => 'Regular fitting';

  @override
  String get preferredUnit => 'Measurement unit';

  @override
  String get inches => 'Inches';

  @override
  String get centimetres => 'Centimetres';

  @override
  String get measurementValues => 'Measurement details';

  @override
  String get measurementNotes => 'Measurement notes';

  @override
  String get measurementNotesHint => 'Fitting pasand ya khaas hidayaat';

  @override
  String get saveMeasurements => 'Measurements save karein';

  @override
  String get measurementSavedTitle => 'Measurements save ho gayin';

  @override
  String get measurementSavedMessage =>
      'Fitting profile kamyabi se save ho gaya.';

  @override
  String get measurementSaveFailed =>
      'Measurements save nahin ho sakin. Values dekh kar dobara koshish karein.';

  @override
  String get measurementTemplateRequired => 'Libas ki qisam select karein.';

  @override
  String get measurementProfileNameRequired => 'Profile ka naam likhein.';

  @override
  String get measurementValueRequired => 'Yeh measurement likhein.';

  @override
  String get measurementValueInvalid => 'Durust measurement likhein.';

  @override
  String get latestMeasurements => 'Latest measurements';

  @override
  String get measurementHistory => 'Measurement history';

  @override
  String measurementRevision(int number) {
    return 'Revision $number';
  }

  @override
  String get measuredOn => 'Measurement ki tareekh';

  @override
  String measurementFieldsCount(int count) {
    return '$count measurements';
  }

  @override
  String get measurementLoadFailed => 'Measurements load nahin ho sakin.';

  @override
  String get measurementTemplateLoadFailed =>
      'Libas ki qisamain load nahin ho sakin. Dobara koshish karein.';

  @override
  String get measurementProfileNotFound =>
      'Yeh measurement profile ab available nahin hai.';

  @override
  String get measurementRequiredHint => 'Zaroori fields par * laga hua hai';

  @override
  String get addMeasurementRevision => 'Nayi measurements shamil karein';

  @override
  String get measurementRevisionSavedMessage =>
      'Nayi measurements kamyabi se save ho gayin.';

  @override
  String get measurementSectionUpperGarment => 'Upar ka libas';

  @override
  String get measurementSectionUpperBody => 'Jism ka upar wala hissa';

  @override
  String get measurementSectionSleeves => 'Aasteenain';

  @override
  String get measurementSectionLowerGarment => 'Neechay ka libas';

  @override
  String get measurementSectionGarment => 'Libas';

  @override
  String get measurementSectionCollar => 'Gala';

  @override
  String get measurementSectionLengths => 'Lambaiyan';

  @override
  String get measurementSectionBody => 'Jism';

  @override
  String get measurementSectionLeg => 'Taang';

  @override
  String get measurementSectionCustom => 'Custom measurements';

  @override
  String get manageMeasurementTemplates =>
      'Measurement templates manage karein';

  @override
  String get measurementTemplatesTitle => 'Measurement templates';

  @override
  String get measurementTemplatesSubtitle =>
      'Dobara istemal honay walay libas measurement sets banayein';

  @override
  String get newMeasurementTemplate => 'Naya template';

  @override
  String get builtInTemplate => 'Built-in';

  @override
  String get customTemplate => 'Custom';

  @override
  String get copyAndCustomize => 'Copy aur customize karein';

  @override
  String get editTemplate => 'Template edit karein';

  @override
  String get templateName => 'Template ka naam';

  @override
  String get templateNameUrdu => 'Urdu mein template ka naam';

  @override
  String get templateNameRomanUrdu => 'Roman Urdu mein template ka naam';

  @override
  String get templateFields => 'Measurement fields';

  @override
  String get addMeasurementField => 'Field shamil karein';

  @override
  String get editMeasurementField => 'Field edit karein';

  @override
  String get fieldNameEnglish => 'English mein field ka naam';

  @override
  String get fieldNameUrdu => 'Urdu mein field ka naam';

  @override
  String get fieldNameRomanUrdu => 'Roman Urdu mein field ka naam';

  @override
  String get fieldSection => 'Section';

  @override
  String get fieldType => 'Value ki qisam';

  @override
  String get numericValue => 'Number';

  @override
  String get textValue => 'Text';

  @override
  String get usesMeasurementUnit => 'Inch/cm istemal karein';

  @override
  String get requiredField => 'Lazmi field';

  @override
  String get saveField => 'Field save karein';

  @override
  String get removeField => 'Field hata dein';

  @override
  String get saveTemplate => 'Template save karein';

  @override
  String get templateSavedTitle => 'Template save ho gaya';

  @override
  String get templateSavedMessage =>
      'Measurement template istemal ke liye tayyar hai.';

  @override
  String get templateSaveFailed =>
      'Template save nahin ho saka. Fields check karke dobara koshish karein.';

  @override
  String get templateNameRequired => 'Template ka naam darj karein.';

  @override
  String get fieldNameRequired => 'Field ka naam darj karein.';

  @override
  String get atLeastOneFieldRequired =>
      'Kam az kam aik measurement field shamil karein.';

  @override
  String get addCustomerMeasurementField => 'Custom field shamil karein';

  @override
  String get customerMeasurementFields => 'Sirf is gahak ke fields';

  @override
  String get customerFieldHint =>
      'Yeh fields sirf isi measurement profile par lagu hon ge.';
}
