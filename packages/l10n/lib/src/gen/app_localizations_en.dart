// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TankerTrack';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Diesel Delivery & Fleet Tracking';

  @override
  String get loginEmailLabel => 'Company email';

  @override
  String get loginEmailHint => 'you@company.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPinLabel => 'Driver PIN';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginUseBiometric => 'Use biometrics';

  @override
  String get loginFailed =>
      'Sign-in failed. Check your credentials and try again.';

  @override
  String get loginLanguageLabel => 'Language / اللغة';

  @override
  String get loginDriverTab => 'Driver';

  @override
  String get loginOfficeTab => 'Back office';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get trackingActive => 'Duty tracking is active';

  @override
  String get pendingSync => 'Pending sync';

  @override
  String get synced => 'Synced';

  @override
  String get syncFailed => 'Sync failed';

  @override
  String get syncNow => 'Sync now';

  @override
  String lastSyncMinutes(int minutes) {
    return 'Last sync $minutes min ago';
  }

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get designComponents => 'Components';

  @override
  String get designButtons => 'Buttons';

  @override
  String get designPrimary => 'Primary';

  @override
  String get designSecondary => 'Secondary';

  @override
  String get designTertiary => 'Tertiary';

  @override
  String get designFields => 'Fields';

  @override
  String get designSearchHint => 'Search orders, drivers, vehicles…';

  @override
  String get designChips => 'Status chips';

  @override
  String get designQuantities => 'Quantities';

  @override
  String get designSync => 'Sync badges';

  @override
  String get designCards => 'Cards';

  @override
  String get designBanners => 'Banners';

  @override
  String get designStates => 'States';

  @override
  String get designEmptyTitle => 'Nothing here yet';

  @override
  String get designEmptyMessage => 'Items you create will appear in this list.';

  @override
  String get designErrorTitle => 'Something went wrong';

  @override
  String get designErrorMessage => 'Check your connection and try again.';

  @override
  String get designFlow => 'Flow';

  @override
  String get unitIg => 'IG';

  @override
  String get unitIgFull => 'Imperial Gallons';

  @override
  String get unitLitre => 'L';

  @override
  String get loginIdLabel => 'Driver ID';

  @override
  String loginDemoHint(String id, String secret) {
    return 'Demo: $id / $secret';
  }

  @override
  String loginSignedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get loginSignOut => 'Sign out';

  @override
  String get loginOpenCatalogue => 'UI catalogue';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get langEnglish => 'English';

  @override
  String get langArabic => 'العربية';
}
