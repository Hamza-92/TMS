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
  String get passwordTooShort => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get showPassword => 'پاس ورڈ دکھائیں';

  @override
  String get hidePassword => 'پاس ورڈ چھپائیں';

  @override
  String get authNotConnected =>
      'لاگ اِن سروس تصدیقی API تیار ہونے پر منسلک کی جائے گی۔';

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
      'Password kam az kam 6 characters ka hona chahiye';

  @override
  String get showPassword => 'Password dikhayein';

  @override
  String get hidePassword => 'Password chhupayein';

  @override
  String get authNotConnected =>
      'Authentication API tayyar hone par login connect kiya jayega.';

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
