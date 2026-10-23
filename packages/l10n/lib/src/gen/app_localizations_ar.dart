// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'TankerTrack';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'توصيل الديزل وتتبع الأسطول';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني للشركة';

  @override
  String get loginEmailHint => 'you@company.com';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPinLabel => 'الرقم السري للسائق';

  @override
  String get loginSignIn => 'دخول';

  @override
  String get loginUseBiometric => 'استخدام البصمة';

  @override
  String get loginFailed => 'فشل تسجيل الدخول. تحقق من بياناتك وحاول مجددًا.';

  @override
  String get loginLanguageLabel => 'Language / اللغة';

  @override
  String get loginDriverTab => 'سائق';

  @override
  String get loginOfficeTab => 'المكتب الخلفي';

  @override
  String get ok => 'حسنًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get search => 'بحث';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get trackingActive => 'تتبع الدوام نشط الآن';

  @override
  String get pendingSync => 'بانتظار المزامنة';

  @override
  String get synced => 'تمت المزامنة';

  @override
  String get syncFailed => 'فشلت المزامنة';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String lastSyncMinutes(int minutes) {
    return 'آخر مزامنة قبل $minutes د';
  }

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get designComponents => 'المكونات';

  @override
  String get designButtons => 'الأزرار';

  @override
  String get designPrimary => 'أساسي';

  @override
  String get designSecondary => 'ثانوي';

  @override
  String get designTertiary => 'ثالث';

  @override
  String get designFields => 'الحقول';

  @override
  String get designSearchHint => 'ابحث في الطلبات والسائقين والمركبات…';

  @override
  String get designChips => 'شارات الحالة';

  @override
  String get designQuantities => 'الكميات';

  @override
  String get designSync => 'شارات المزامنة';

  @override
  String get designCards => 'البطاقات';

  @override
  String get designBanners => 'اللافتات';

  @override
  String get designStates => 'الحالات';

  @override
  String get designEmptyTitle => 'لا يوجد شيء بعد';

  @override
  String get designEmptyMessage => 'العناصر التي تنشئها ستظهر في هذه القائمة.';

  @override
  String get designErrorTitle => 'حدث خطأ ما';

  @override
  String get designErrorMessage => 'تحقق من اتصالك وحاول مجددًا.';

  @override
  String get designFlow => 'التدفق';

  @override
  String get unitIg => 'غ.إ';

  @override
  String get unitIgFull => 'غالون إمبراطوري';

  @override
  String get unitLitre => 'لتر';

  @override
  String get loginIdLabel => 'رقم السائق';

  @override
  String loginDemoHint(String id, String secret) {
    return 'تجريبي: $id / $secret';
  }

  @override
  String loginSignedInAs(String name) {
    return 'تم الدخول باسم $name';
  }

  @override
  String get loginSignOut => 'تسجيل الخروج';

  @override
  String get loginOpenCatalogue => 'كتالوج الواجهة';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get langEnglish => 'English';

  @override
  String get langArabic => 'العربية';
}
