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
  String get phoneInvalid => 'ملکی کوڈ کے ساتھ درست فون نمبر درج کریں';

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
  String get businessName => 'کاروبار کا نام';

  @override
  String get businessNameHint => 'عائشہ ٹیلرز';

  @override
  String get businessNameRequired => 'کاروبار کا نام درج کریں';

  @override
  String get passwordRequirements =>
      'کم از کم 8 حروف، ایک حرف اور ایک عدد استعمال کریں';

  @override
  String get confirmPassword => 'پاس ورڈ کی تصدیق';

  @override
  String get confirmPasswordHint => 'پاس ورڈ دوبارہ درج کریں';

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
  String get otpExpired => 'یہ کوڈ ختم ہو چکا ہے';

  @override
  String get authDevelopmentOtpHint =>
      'ٹیسٹ ماحول: OTP لاراول کی storage/logs/laravel.log فائل سے دیکھیں۔';

  @override
  String get verifyAndCreateAccount => 'تصدیق اور اکاؤنٹ بنائیں';

  @override
  String get verifyCode => 'کوڈ کی تصدیق کریں';

  @override
  String get resendOtp => 'کوڈ دوبارہ بھیجیں';

  @override
  String get sendingOtp => 'بھیجا جا رہا ہے...';

  @override
  String get authOtpResent => 'نیا تصدیقی کوڈ جاری کر دیا گیا ہے۔';

  @override
  String get resetPassword => 'پاس ورڈ بحال کریں';

  @override
  String get resetPasswordSubtitle =>
      'پاس ورڈ تبدیل کرنے سے پہلے ہم آپ کے واٹس ایپ نمبر کی تصدیق کریں گے۔';

  @override
  String get passwordOtpPrivacyNotice =>
      'آپ کی رازداری کے لیے جواب یکساں ہوگا، چاہے اکاؤنٹ موجود ہو یا نہ ہو۔';

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
      'بہت زیادہ کوششیں ہو چکی ہیں۔ انتظار کرکے دوبارہ کوشش کریں۔';

  @override
  String get authInvalidCredentials => 'فون نمبر یا پاس ورڈ درست نہیں ہے۔';

  @override
  String get authPhoneRequestFailed =>
      'تصدیقی کوڈ نہیں بھیجا جا سکا۔ نمبر چیک کریں یا بعد میں کوشش کریں۔';

  @override
  String get authOtpInvalid =>
      'تصدیقی کوڈ غلط، ختم شدہ یا پہلے استعمال ہو چکا ہے۔';

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
  String get dashboardShopName => 'علی ٹیلرز';

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
      'Country code ke saath durust phone number likhein';

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
  String get businessName => 'Business ka naam';

  @override
  String get businessNameHint => 'Ayesha Tailors';

  @override
  String get businessNameRequired => 'Business ka naam likhein';

  @override
  String get passwordRequirements =>
      'Kam az kam 8 characters, aik letter aur aik number istemal karein';

  @override
  String get confirmPassword => 'Password confirm karein';

  @override
  String get confirmPasswordHint => 'Password dobara likhein';

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
  String get otpExpired => 'Yeh code expire ho chuka hai';

  @override
  String get authDevelopmentOtpHint =>
      'Test environment: OTP Laravel ki storage/logs/laravel.log file se dekhein.';

  @override
  String get verifyAndCreateAccount => 'Verify karke account banayein';

  @override
  String get verifyCode => 'Code verify karein';

  @override
  String get resendOtp => 'Code dobara bhejein';

  @override
  String get sendingOtp => 'Bheja ja raha hai...';

  @override
  String get authOtpResent => 'Naya verification code jaari kar diya gaya hai.';

  @override
  String get resetPassword => 'Password reset karein';

  @override
  String get resetPasswordSubtitle =>
      'Password badalne se pehle hum aap ka WhatsApp number verify karein ge.';

  @override
  String get passwordOtpPrivacyNotice =>
      'Aap ki privacy ke liye jawab aik jaisa hoga, chahe account mojood ho ya na ho.';

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
      'Bohat zyada koshishain ho chuki hain. Intizar karke dobara try karein.';

  @override
  String get authInvalidCredentials =>
      'Phone number ya password durust nahin hai.';

  @override
  String get authPhoneRequestFailed =>
      'Verification code nahin bheja ja saka. Number check karein ya baad mein try karein.';

  @override
  String get authOtpInvalid =>
      'Verification code ghalat, expire, ya pehle istemal ho chuka hai.';

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
  String get dashboardShopName => 'Ali Tailors';

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
}
