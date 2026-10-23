import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
  ];

  /// Product name (never translated)
  ///
  /// In en, this message translates to:
  /// **'TankerTrack'**
  String get appName;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Diesel Delivery & Fleet Tracking'**
  String get loginSubtitle;

  /// Back-office login email field
  ///
  /// In en, this message translates to:
  /// **'Company email'**
  String get loginEmailLabel;

  /// Email hint (not translated)
  ///
  /// In en, this message translates to:
  /// **'you@company.com'**
  String get loginEmailHint;

  /// Password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// Driver login PIN field
  ///
  /// In en, this message translates to:
  /// **'Driver PIN'**
  String get loginPinLabel;

  /// Sign-in button
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// Biometric login option
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get loginUseBiometric;

  /// Generic login error
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Check your credentials and try again.'**
  String get loginFailed;

  /// Language switcher label (bilingual by design)
  ///
  /// In en, this message translates to:
  /// **'Language / اللغة'**
  String get loginLanguageLabel;

  /// Driver login tab
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get loginDriverTab;

  /// Back-office login tab
  ///
  /// In en, this message translates to:
  /// **'Back office'**
  String get loginOfficeTab;

  /// Common: OK
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Common: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Common: Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Common: Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Common: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Common: Search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Connectivity: online
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Connectivity: offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Privacy banner while GPS duty tracking runs
  ///
  /// In en, this message translates to:
  /// **'Duty tracking is active'**
  String get trackingActive;

  /// Outbox badge: pending
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get pendingSync;

  /// Outbox badge: synced
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// Outbox badge: failed
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get syncFailed;

  /// Manual sync button
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// Last-sync relative time
  ///
  /// In en, this message translates to:
  /// **'Last sync {minutes} min ago'**
  String lastSyncMinutes(int minutes);

  /// Validation: required
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Validation: email
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// Storybook title
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get designComponents;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get designButtons;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get designPrimary;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get designSecondary;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Tertiary'**
  String get designTertiary;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get designFields;

  /// Storybook search hint
  ///
  /// In en, this message translates to:
  /// **'Search orders, drivers, vehicles…'**
  String get designSearchHint;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Status chips'**
  String get designChips;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Quantities'**
  String get designQuantities;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Sync badges'**
  String get designSync;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get designCards;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get designBanners;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get designStates;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get designEmptyTitle;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'Items you create will appear in this list.'**
  String get designEmptyMessage;

  /// Error state title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get designErrorTitle;

  /// Error state message
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get designErrorMessage;

  /// Storybook section
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get designFlow;

  /// Imperial Gallons short unit
  ///
  /// In en, this message translates to:
  /// **'IG'**
  String get unitIg;

  /// Imperial Gallons full unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Gallons'**
  String get unitIgFull;

  /// Litre short unit
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitLitre;

  /// Driver login identifier field
  ///
  /// In en, this message translates to:
  /// **'Driver ID'**
  String get loginIdLabel;

  /// Demo credentials hint on login
  ///
  /// In en, this message translates to:
  /// **'Demo: {id} / {secret}'**
  String loginDemoHint(String id, String secret);

  /// Post-login greeting
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String loginSignedInAs(String name);

  /// Sign-out button
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get loginSignOut;

  /// Link to /design storybook
  ///
  /// In en, this message translates to:
  /// **'UI catalogue'**
  String get loginOpenCatalogue;

  /// Theme switch: light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Theme switch: dark
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Theme switch: system
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Language name (native, never translated)
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// Language name (native, never translated)
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
