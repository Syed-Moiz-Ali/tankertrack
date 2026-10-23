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

  @override
  String get nav_dashboard => 'لوحة التحكم';

  @override
  String get nav_tower => 'برج المراقبة';

  @override
  String get nav_customers => 'العملاء';

  @override
  String get nav_depots => 'المستودعات';

  @override
  String get nav_products => 'المنتجات';

  @override
  String get nav_drivers => 'السائقون';

  @override
  String get nav_vehicles => 'المركبات';

  @override
  String get nav_catalogue => 'كتالوج الواجهة';

  @override
  String get nav_signout => 'تسجيل الخروج';

  @override
  String get shell_search_hint => 'ابحث في الطلبات والسائقين والمركبات…';

  @override
  String get shell_notifications => 'الإشعارات';

  @override
  String get shell_demo_role => 'دور تجريبي';

  @override
  String get shell_online => 'متصل';

  @override
  String get shell_offline => 'غير متصل';

  @override
  String get mfa_title => 'التحقق بخطوتين';

  @override
  String get mfa_hint => 'أدخل الرمز المكوّن من 6 أرقام من تطبيق المصادقة.';

  @override
  String get mfa_code_label => 'رمز التحقق';

  @override
  String get mfa_verify => 'تحقق';

  @override
  String get mfa_invalid => 'رمز غير صالح. حاول مجددًا.';

  @override
  String get mfa_note_demo => 'نسخة تجريبية: أي رمز من 6 أرقام مقبول.';

  @override
  String get err403_title => 'تم رفض الوصول';

  @override
  String get err403_message => 'ليست لديك صلاحية لعرض هذه الصفحة.';

  @override
  String get err404_title => 'الصفحة غير موجودة';

  @override
  String get err404_message => 'الصفحة التي تبحث عنها غير موجودة أو تم نقلها.';

  @override
  String get err_back_home => 'عودة إلى الرئيسية';

  @override
  String get dash_title => 'لوحة التحكم';

  @override
  String get dash_kpi_requested => 'المطلوب';

  @override
  String get dash_kpi_loaded => 'المحمّل';

  @override
  String get dash_kpi_delivered => 'المسلّم';

  @override
  String get dash_kpi_pending => 'المعلّق';

  @override
  String get dash_orders_by_status => 'الطلبات حسب الحالة';

  @override
  String get dash_drivers => 'السائقون';

  @override
  String get dash_vehicles => 'المركبات';

  @override
  String get dash_late_orders => 'الطلبات المتأخرة';

  @override
  String get dash_alerts => 'التنبيهات';

  @override
  String get dash_reload => 'إعادة التحميل مطلوبة';

  @override
  String get dash_process_title => 'كيف يعمل';

  @override
  String get dash_step1 => 'تسجيل الدخول';

  @override
  String get dash_step2 => 'إنشاء أمر بيع';

  @override
  String get dash_step3 => 'التعيين والإرسال';

  @override
  String get dash_step4 => 'العمليات المباشرة';

  @override
  String get dash_step5 => 'مراقبة التسليم';

  @override
  String get dash_step6 => 'التقارير والتحليلات';

  @override
  String get dash_step7 => 'التسوية والإغلاق';

  @override
  String get dash_step8 => 'الإدارة والإعداد';

  @override
  String get tower_title => 'برج المراقبة';

  @override
  String get tower_live => 'مباشر';

  @override
  String get tower_board => 'لوحة العمليات';

  @override
  String get tower_alerts => 'التنبيهات';

  @override
  String get tower_reload => 'إعادة التحميل مطلوبة';

  @override
  String get mst_search => 'بحث';

  @override
  String get mst_all => 'الكل';

  @override
  String get mst_active => 'نشط';

  @override
  String get mst_inactive => 'غير نشط';

  @override
  String get mst_create => 'إنشاء';

  @override
  String get mst_edit => 'تعديل';

  @override
  String get mst_save => 'حفظ';

  @override
  String get mst_name_en => 'الاسم (بالإنجليزية)';

  @override
  String get mst_name_ar => 'الاسم (بالعربية)';

  @override
  String get mst_phone => 'الهاتف';

  @override
  String get mst_contact => 'جهة الاتصال';

  @override
  String get mst_status => 'الحالة';

  @override
  String get mst_capacity => 'السعة';

  @override
  String get mst_onboard => 'على متن المركبة';

  @override
  String get mst_docs_ok => 'المستندات سارية';

  @override
  String get mst_docs_expiring => 'المستندات قاربت على الانتهاء';

  @override
  String get mst_empty_title => 'لا يوجد شيء بعد';

  @override
  String get mst_empty_message => 'العناصر التي تنشئها ستظهر في هذه القائمة.';

  @override
  String get mst_error_title => 'حدث خطأ ما';

  @override
  String get mst_retry => 'إعادة المحاولة';

  @override
  String get cust_sites_tab => 'المواقع';

  @override
  String get cust_orders_hint => 'تظهر طلبات هذا العميل هنا.';

  @override
  String get site_geofence => 'النطاق الجغرافي';

  @override
  String get site_gate_hours => 'ساعات البوابة';

  @override
  String get site_lat => 'خط العرض';

  @override
  String get site_lng => 'خط الطول';

  @override
  String get drv_licence => 'الرخصة';

  @override
  String get drv_calendar_title => 'الجدول';

  @override
  String get drv_commitments => 'الالتزامات';

  @override
  String get veh_balance => 'الرصيد';

  @override
  String get veh_calendar_title => 'الجدول';

  @override
  String get veh_defect_block => 'محظورة: تم الإبلاغ عن عيب حرج.';

  @override
  String get cal_today => 'اليوم';

  @override
  String get cal_commitment_days => 'أيام الالتزامات';

  @override
  String get depot_hours => 'ساعات العمل';

  @override
  String get depot_products => 'المنتجات';

  @override
  String get prod_unit => 'الوحدة';

  @override
  String get prod_active => 'نشط';

  @override
  String list_rows(int count) {
    return '$count من الصفوف';
  }

  @override
  String get role_admin => 'مدير النظام';

  @override
  String get role_sales => 'المبيعات';

  @override
  String get role_dispatcher => 'المرسل';

  @override
  String get role_fleet => 'مراقب الأسطول';

  @override
  String get role_driver => 'سائق';

  @override
  String get role_supervisor => 'مشرف';

  @override
  String get role_finance => 'المالية';

  @override
  String get role_customer => 'عميل';

  @override
  String get st_order_draft => 'مسودة';

  @override
  String get st_order_confirmed => 'مؤكدة';

  @override
  String get st_order_on_hold => 'معلقة';

  @override
  String get st_order_unassigned => 'غير مسندة';

  @override
  String get st_order_assigned => 'مسندة';

  @override
  String get st_order_in_progress => 'قيد التنفيذ';

  @override
  String get st_order_completed => 'مكتملة';

  @override
  String get st_order_partial => 'جزئية';

  @override
  String get st_order_failed => 'فاشلة';

  @override
  String get st_order_cancelled => 'ملغاة';

  @override
  String get st_trip_planned => 'مخططة';

  @override
  String get st_trip_assigned => 'مسندة';

  @override
  String get st_trip_accepted => 'مقبولة';

  @override
  String get st_trip_started => 'بدأت';

  @override
  String get st_trip_at_loading => 'في التحميل';

  @override
  String get st_trip_loaded => 'محملة';

  @override
  String get st_trip_delivering => 'قيد التوصيل';

  @override
  String get st_trip_paused => 'متوقفة مؤقتا';

  @override
  String get st_trip_breakdown => 'عطل';

  @override
  String get st_trip_completed => 'مكتملة';

  @override
  String get st_trip_closed => 'مغلقة';

  @override
  String get st_task_pending => 'بانتظار';

  @override
  String get st_task_accepted => 'مقبولة';

  @override
  String get st_task_en_route => 'في الطريق';

  @override
  String get st_task_arrived => 'وصل';

  @override
  String get st_task_started => 'بدأت';

  @override
  String get st_task_completed => 'مكتملة';

  @override
  String get st_task_skipped => 'متجاوزة';

  @override
  String get st_task_failed => 'فاشلة';

  @override
  String get st_task_cancelled => 'ملغاة';

  @override
  String get st_vehicle_available => 'متاحة';

  @override
  String get st_vehicle_reserved => 'محجوزة';

  @override
  String get st_vehicle_loading => 'تحميل';

  @override
  String get st_vehicle_in_transit => 'في الطريق';

  @override
  String get st_vehicle_at_customer => 'عند العميل';

  @override
  String get st_vehicle_on_break => 'استراحة';

  @override
  String get st_vehicle_breakdown => 'عطل';

  @override
  String get st_vehicle_maintenance => 'صيانة';

  @override
  String get st_vehicle_out_of_service => 'خارج الخدمة';

  @override
  String get st_driver_offline => 'غير متصل';

  @override
  String get st_driver_available => 'متاح';

  @override
  String get st_driver_assigned => 'مسند';

  @override
  String get st_driver_driving => 'يقود';

  @override
  String get st_driver_working => 'يعمل';

  @override
  String get st_driver_waiting => 'بانتظار';

  @override
  String get st_driver_on_break => 'استراحة';

  @override
  String get st_driver_breakdown => 'عطل';

  @override
  String get st_driver_completed_day => 'أنهى اليوم';

  @override
  String get st_cust_active => 'نشط';

  @override
  String get st_cust_credit_hold => 'ائتمان معلق';

  @override
  String get st_cust_inactive => 'غير نشط';

  @override
  String get st_sev_critical => 'حرج';

  @override
  String get st_sev_high => 'عالية';

  @override
  String get st_sev_medium => 'متوسطة';

  @override
  String get st_sev_low => 'منخفضة';

  @override
  String get st_sev_info => 'معلومات';

  @override
  String get st_duty_on => 'على رأس العمل';

  @override
  String get st_duty_off => 'خارج الدوام';

  @override
  String get st_duty_suspended => 'موقوف';

  @override
  String get st_duty_leave => 'في إجازة';

  @override
  String get st_live_active => 'نشط';

  @override
  String get st_live_loading => 'يحمل';

  @override
  String get st_live_unloading => 'يفرغ';

  @override
  String get st_live_waiting => 'بانتظار';

  @override
  String get st_live_completed => 'مكتمل';

  @override
  String get st_live_critical => 'حرج';

  @override
  String get st_live_offline => 'غير متصل';
}
