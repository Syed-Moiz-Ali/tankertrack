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

  /// Nav: dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get nav_dashboard;

  /// Nav: control tower
  ///
  /// In en, this message translates to:
  /// **'Control Tower'**
  String get nav_tower;

  /// Nav: customers
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get nav_customers;

  /// Nav: depots
  ///
  /// In en, this message translates to:
  /// **'Depots'**
  String get nav_depots;

  /// Nav: products
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get nav_products;

  /// Nav: drivers
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get nav_drivers;

  /// Nav: vehicles
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get nav_vehicles;

  /// Nav: UI catalogue
  ///
  /// In en, this message translates to:
  /// **'UI catalogue'**
  String get nav_catalogue;

  /// Nav: sign out
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get nav_signout;

  /// Shell search field hint
  ///
  /// In en, this message translates to:
  /// **'Search orders, drivers, vehicles…'**
  String get shell_search_hint;

  /// Shell notifications button
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get shell_notifications;

  /// Shell demo role badge label
  ///
  /// In en, this message translates to:
  /// **'Demo role'**
  String get shell_demo_role;

  /// Shell connectivity: online
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get shell_online;

  /// Shell connectivity: offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get shell_offline;

  /// MFA screen title
  ///
  /// In en, this message translates to:
  /// **'Two-step verification'**
  String get mfa_title;

  /// MFA code entry hint
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app.'**
  String get mfa_hint;

  /// MFA code field label
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get mfa_code_label;

  /// MFA verify button
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get mfa_verify;

  /// MFA invalid code error
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Try again.'**
  String get mfa_invalid;

  /// MFA demo-mode note
  ///
  /// In en, this message translates to:
  /// **'Demo build: any 6-digit code is accepted.'**
  String get mfa_note_demo;

  /// 403 screen title
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get err403_title;

  /// 403 screen message
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this page.'**
  String get err403_message;

  /// 404 screen title
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get err404_title;

  /// 404 screen message
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist or was moved.'**
  String get err404_message;

  /// Error screens: back home button
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get err_back_home;

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dash_title;

  /// Dashboard KPI: requested
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get dash_kpi_requested;

  /// Dashboard KPI: loaded
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get dash_kpi_loaded;

  /// Dashboard KPI: delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get dash_kpi_delivered;

  /// Dashboard KPI: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dash_kpi_pending;

  /// Dashboard orders-by-status section
  ///
  /// In en, this message translates to:
  /// **'Orders by status'**
  String get dash_orders_by_status;

  /// Dashboard drivers section
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get dash_drivers;

  /// Dashboard vehicles section
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get dash_vehicles;

  /// Dashboard late orders section
  ///
  /// In en, this message translates to:
  /// **'Late orders'**
  String get dash_late_orders;

  /// Dashboard alerts section
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get dash_alerts;

  /// Dashboard reload-required section
  ///
  /// In en, this message translates to:
  /// **'Reload required'**
  String get dash_reload;

  /// Dashboard process overview title
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get dash_process_title;

  /// Back-office step 1
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get dash_step1;

  /// Back-office step 2
  ///
  /// In en, this message translates to:
  /// **'Create Sales Order'**
  String get dash_step2;

  /// Back-office step 3
  ///
  /// In en, this message translates to:
  /// **'Assign & Dispatch'**
  String get dash_step3;

  /// Back-office step 4
  ///
  /// In en, this message translates to:
  /// **'Live Operations'**
  String get dash_step4;

  /// Back-office step 5
  ///
  /// In en, this message translates to:
  /// **'Delivery Monitoring'**
  String get dash_step5;

  /// Back-office step 6
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get dash_step6;

  /// Back-office step 7
  ///
  /// In en, this message translates to:
  /// **'Reconcile & Close'**
  String get dash_step7;

  /// Back-office step 8
  ///
  /// In en, this message translates to:
  /// **'Admin & Setup'**
  String get dash_step8;

  /// Control tower screen title
  ///
  /// In en, this message translates to:
  /// **'Control Tower'**
  String get tower_title;

  /// Control tower live badge
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get tower_live;

  /// Control tower board section
  ///
  /// In en, this message translates to:
  /// **'Operations board'**
  String get tower_board;

  /// Control tower alerts section
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get tower_alerts;

  /// Control tower reload section
  ///
  /// In en, this message translates to:
  /// **'Reload required'**
  String get tower_reload;

  /// Master lists: search hint
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get mst_search;

  /// Master lists: all filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mst_all;

  /// Master lists: active filter
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get mst_active;

  /// Master lists: inactive filter
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get mst_inactive;

  /// Master lists: create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get mst_create;

  /// Master lists: edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get mst_edit;

  /// Master forms: save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get mst_save;

  /// Master forms: English name field
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get mst_name_en;

  /// Master forms: Arabic name field
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get mst_name_ar;

  /// Master forms: phone field
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get mst_phone;

  /// Master forms: contact field
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get mst_contact;

  /// Master lists: status column
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get mst_status;

  /// Vehicle: capacity column
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get mst_capacity;

  /// Vehicle: on-board quantity column
  ///
  /// In en, this message translates to:
  /// **'On board'**
  String get mst_onboard;

  /// Vehicle/driver: documents valid
  ///
  /// In en, this message translates to:
  /// **'Documents valid'**
  String get mst_docs_ok;

  /// Vehicle/driver: documents expiring
  ///
  /// In en, this message translates to:
  /// **'Documents expiring'**
  String get mst_docs_expiring;

  /// Master lists: empty title
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get mst_empty_title;

  /// Master lists: empty message
  ///
  /// In en, this message translates to:
  /// **'Items you create will appear in this list.'**
  String get mst_empty_message;

  /// Master lists: error title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get mst_error_title;

  /// Master lists: retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get mst_retry;

  /// Customer detail: sites tab
  ///
  /// In en, this message translates to:
  /// **'Sites'**
  String get cust_sites_tab;

  /// Customer detail: orders hint
  ///
  /// In en, this message translates to:
  /// **'Orders for this customer appear here.'**
  String get cust_orders_hint;

  /// Site: geofence radius
  ///
  /// In en, this message translates to:
  /// **'Geofence'**
  String get site_geofence;

  /// Site: gate hours
  ///
  /// In en, this message translates to:
  /// **'Gate hours'**
  String get site_gate_hours;

  /// Site: latitude
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get site_lat;

  /// Site: longitude
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get site_lng;

  /// Driver: licence
  ///
  /// In en, this message translates to:
  /// **'Licence'**
  String get drv_licence;

  /// Driver detail: calendar title
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get drv_calendar_title;

  /// Driver: commitments
  ///
  /// In en, this message translates to:
  /// **'Commitments'**
  String get drv_commitments;

  /// Vehicle: balance
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get veh_balance;

  /// Vehicle detail: calendar title
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get veh_calendar_title;

  /// Vehicle: critical defect block
  ///
  /// In en, this message translates to:
  /// **'Blocked: critical defect reported.'**
  String get veh_defect_block;

  /// Calendar: today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get cal_today;

  /// Calendar: commitment days
  ///
  /// In en, this message translates to:
  /// **'Commitment days'**
  String get cal_commitment_days;

  /// Depot: working hours
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get depot_hours;

  /// Depot: products
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get depot_products;

  /// Product: unit
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get prod_unit;

  /// Product: active flag
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get prod_active;

  /// Master lists: row count
  ///
  /// In en, this message translates to:
  /// **'{count} rows'**
  String list_rows(int count);

  /// Role badge: admin
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get role_admin;

  /// Role badge: sales
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get role_sales;

  /// Role badge: dispatcher
  ///
  /// In en, this message translates to:
  /// **'Dispatcher'**
  String get role_dispatcher;

  /// Role badge: fleet controller
  ///
  /// In en, this message translates to:
  /// **'Fleet Controller'**
  String get role_fleet;

  /// Role badge: driver
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get role_driver;

  /// Role badge: supervisor
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get role_supervisor;

  /// Role badge: finance
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get role_finance;

  /// Role badge: customer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get role_customer;

  /// Status label: st_order_draft
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get st_order_draft;

  /// Status label: st_order_confirmed
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get st_order_confirmed;

  /// Status label: st_order_on_hold
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get st_order_on_hold;

  /// Status label: st_order_unassigned
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get st_order_unassigned;

  /// Status label: st_order_assigned
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get st_order_assigned;

  /// Status label: st_order_in_progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get st_order_in_progress;

  /// Status label: st_order_completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get st_order_completed;

  /// Status label: st_order_partial
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get st_order_partial;

  /// Status label: st_order_failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get st_order_failed;

  /// Status label: st_order_cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get st_order_cancelled;

  /// Status label: st_trip_planned
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get st_trip_planned;

  /// Status label: st_trip_assigned
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get st_trip_assigned;

  /// Status label: st_trip_accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get st_trip_accepted;

  /// Status label: st_trip_started
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get st_trip_started;

  /// Status label: st_trip_at_loading
  ///
  /// In en, this message translates to:
  /// **'At loading'**
  String get st_trip_at_loading;

  /// Status label: st_trip_loaded
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get st_trip_loaded;

  /// Status label: st_trip_delivering
  ///
  /// In en, this message translates to:
  /// **'Delivering'**
  String get st_trip_delivering;

  /// Status label: st_trip_paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get st_trip_paused;

  /// Status label: st_trip_breakdown
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get st_trip_breakdown;

  /// Status label: st_trip_completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get st_trip_completed;

  /// Status label: st_trip_closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get st_trip_closed;

  /// Status label: st_task_pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get st_task_pending;

  /// Status label: st_task_accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get st_task_accepted;

  /// Status label: st_task_en_route
  ///
  /// In en, this message translates to:
  /// **'En route'**
  String get st_task_en_route;

  /// Status label: st_task_arrived
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get st_task_arrived;

  /// Status label: st_task_started
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get st_task_started;

  /// Status label: st_task_completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get st_task_completed;

  /// Status label: st_task_skipped
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get st_task_skipped;

  /// Status label: st_task_failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get st_task_failed;

  /// Status label: st_task_cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get st_task_cancelled;

  /// Status label: st_vehicle_available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get st_vehicle_available;

  /// Status label: st_vehicle_reserved
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get st_vehicle_reserved;

  /// Status label: st_vehicle_loading
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get st_vehicle_loading;

  /// Status label: st_vehicle_in_transit
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get st_vehicle_in_transit;

  /// Status label: st_vehicle_at_customer
  ///
  /// In en, this message translates to:
  /// **'At customer'**
  String get st_vehicle_at_customer;

  /// Status label: st_vehicle_on_break
  ///
  /// In en, this message translates to:
  /// **'On break'**
  String get st_vehicle_on_break;

  /// Status label: st_vehicle_breakdown
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get st_vehicle_breakdown;

  /// Status label: st_vehicle_maintenance
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get st_vehicle_maintenance;

  /// Status label: st_vehicle_out_of_service
  ///
  /// In en, this message translates to:
  /// **'Out of service'**
  String get st_vehicle_out_of_service;

  /// Status label: st_driver_offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get st_driver_offline;

  /// Status label: st_driver_available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get st_driver_available;

  /// Status label: st_driver_assigned
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get st_driver_assigned;

  /// Status label: st_driver_driving
  ///
  /// In en, this message translates to:
  /// **'Driving'**
  String get st_driver_driving;

  /// Status label: st_driver_working
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get st_driver_working;

  /// Status label: st_driver_waiting
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get st_driver_waiting;

  /// Status label: st_driver_on_break
  ///
  /// In en, this message translates to:
  /// **'On break'**
  String get st_driver_on_break;

  /// Status label: st_driver_breakdown
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get st_driver_breakdown;

  /// Status label: st_driver_completed_day
  ///
  /// In en, this message translates to:
  /// **'Day completed'**
  String get st_driver_completed_day;

  /// Status label: st_cust_active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get st_cust_active;

  /// Status label: st_cust_credit_hold
  ///
  /// In en, this message translates to:
  /// **'Credit hold'**
  String get st_cust_credit_hold;

  /// Status label: st_cust_inactive
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get st_cust_inactive;

  /// Status label: st_sev_critical
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get st_sev_critical;

  /// Status label: st_sev_high
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get st_sev_high;

  /// Status label: st_sev_medium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get st_sev_medium;

  /// Status label: st_sev_low
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get st_sev_low;

  /// Status label: st_sev_info
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get st_sev_info;

  /// Duty roster: on duty
  ///
  /// In en, this message translates to:
  /// **'On duty'**
  String get st_duty_on;

  /// Duty roster: off duty
  ///
  /// In en, this message translates to:
  /// **'Off duty'**
  String get st_duty_off;

  /// Duty roster: suspended
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get st_duty_suspended;

  /// Duty roster: on leave
  ///
  /// In en, this message translates to:
  /// **'On leave'**
  String get st_duty_leave;

  /// Live board: active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get st_live_active;

  /// Live board: loading
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get st_live_loading;

  /// Live board: unloading
  ///
  /// In en, this message translates to:
  /// **'Unloading'**
  String get st_live_unloading;

  /// Live board: waiting
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get st_live_waiting;

  /// Live board: completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get st_live_completed;

  /// Live board: critical
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get st_live_critical;

  /// Live board: offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get st_live_offline;

  /// P1b key: dash_greeting_morning
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String dash_greeting_morning(String name);

  /// P1b key: dash_greeting_afternoon
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String dash_greeting_afternoon(String name);

  /// P1b key: dash_greeting_evening
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String dash_greeting_evening(String name);

  /// P1b key: seg_loading_now
  ///
  /// In en, this message translates to:
  /// **'Loading now'**
  String get seg_loading_now;

  /// P1b key: seg_in_transit
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get seg_in_transit;

  /// P1b key: seg_arriving_soon
  ///
  /// In en, this message translates to:
  /// **'Arriving soon'**
  String get seg_arriving_soon;

  /// P1b key: seg_upcoming
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get seg_upcoming;

  /// P1b key: seg_needs_attention
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get seg_needs_attention;

  /// P1b key: fleet_today
  ///
  /// In en, this message translates to:
  /// **'Your fleet today'**
  String get fleet_today;

  /// P1b key: map_show_all
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get map_show_all;

  /// P1b key: kpi_trend_up
  ///
  /// In en, this message translates to:
  /// **'up from yesterday'**
  String get kpi_trend_up;

  /// P1b key: kpi_trend_down
  ///
  /// In en, this message translates to:
  /// **'down from yesterday'**
  String get kpi_trend_down;

  /// P1b key: menu_title
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_title;

  /// P1b key: menu_control_tower
  ///
  /// In en, this message translates to:
  /// **'Control Tower'**
  String get menu_control_tower;

  /// P1b key: menu_depots
  ///
  /// In en, this message translates to:
  /// **'Depots'**
  String get menu_depots;

  /// P1b key: menu_products
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get menu_products;

  /// P1b key: menu_drivers
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get menu_drivers;

  /// P1b key: menu_design
  ///
  /// In en, this message translates to:
  /// **'UI catalogue'**
  String get menu_design;

  /// P1b key: menu_theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menu_theme;

  /// P1b key: menu_language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menu_language;

  /// P1b key: menu_demo_role
  ///
  /// In en, this message translates to:
  /// **'Demo role'**
  String get menu_demo_role;

  /// P1b key: menu_sign_out
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get menu_sign_out;

  /// P1b key: menu_profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menu_profile;

  /// P1b key: search_order
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get search_order;

  /// P1b key: search_driver
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get search_driver;

  /// P1b key: search_vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get search_vehicle;

  /// P1b key: search_customer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get search_customer;

  /// P1b key: detail_edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get detail_edit;

  /// P1b key: detail_assign
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get detail_assign;

  /// P1b key: detail_block
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get detail_block;

  /// P1b key: detail_overview
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get detail_overview;

  /// P1b key: detail_location
  ///
  /// In en, this message translates to:
  /// **'Where it is'**
  String get detail_location;

  /// P1b key: detail_availability
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get detail_availability;

  /// P1b key: detail_documents
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get detail_documents;

  /// P1b key: detail_activity
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get detail_activity;

  /// P1b key: detail_show_all
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get detail_show_all;

  /// P1b key: detail_photos
  ///
  /// In en, this message translates to:
  /// **'Show all photos'**
  String get detail_photos;

  /// P1b key: login_welcome
  ///
  /// In en, this message translates to:
  /// **'Welcome to TankerTrack'**
  String get login_welcome;

  /// P1b key: login_demo_accounts
  ///
  /// In en, this message translates to:
  /// **'Demo accounts'**
  String get login_demo_accounts;

  /// P1b key: tab_today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tab_today;

  /// P1b key: tab_tasks
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tab_tasks;

  /// P1b key: tab_messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get tab_messages;

  /// P1b key: tab_profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tab_profile;

  /// P1b key: today_next_up
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get today_next_up;

  /// P1b key: tab_fleet
  ///
  /// In en, this message translates to:
  /// **'Fleet'**
  String get tab_fleet;

  /// Alert label: inc_breakdown
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get inc_breakdown;

  /// Alert label: inc_accident
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get inc_accident;

  /// Alert label: inc_spill
  ///
  /// In en, this message translates to:
  /// **'Spill'**
  String get inc_spill;

  /// Alert label: inc_customer_unavailable
  ///
  /// In en, this message translates to:
  /// **'Customer unavailable'**
  String get inc_customer_unavailable;

  /// Alert label: inc_meter_issue
  ///
  /// In en, this message translates to:
  /// **'Meter issue'**
  String get inc_meter_issue;

  /// Alert label: inc_traffic
  ///
  /// In en, this message translates to:
  /// **'Traffic delay'**
  String get inc_traffic;

  /// Alert label: inc_access_denied
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get inc_access_denied;

  /// Alert label: inc_gps_issue
  ///
  /// In en, this message translates to:
  /// **'GPS issue'**
  String get inc_gps_issue;

  /// Alert label: ntf_assigned
  ///
  /// In en, this message translates to:
  /// **'Order assigned'**
  String get ntf_assigned;

  /// Alert label: ntf_late_eta
  ///
  /// In en, this message translates to:
  /// **'Late ETA risk'**
  String get ntf_late_eta;

  /// Alert label: ntf_geofence
  ///
  /// In en, this message translates to:
  /// **'Geofence event'**
  String get ntf_geofence;

  /// Alert label: ntf_variance
  ///
  /// In en, this message translates to:
  /// **'Quantity variance'**
  String get ntf_variance;

  /// Alert label: ntf_deviation
  ///
  /// In en, this message translates to:
  /// **'Route deviation'**
  String get ntf_deviation;

  /// Alert label: ntf_doc_expiry
  ///
  /// In en, this message translates to:
  /// **'Document expiring'**
  String get ntf_doc_expiry;

  /// Alert label: ntf_gps_stale
  ///
  /// In en, this message translates to:
  /// **'GPS stale'**
  String get ntf_gps_stale;

  /// Illustration semantic label: ill_tanker
  ///
  /// In en, this message translates to:
  /// **'Tanker truck'**
  String get ill_tanker;

  /// Illustration semantic label: ill_depot
  ///
  /// In en, this message translates to:
  /// **'Fuel depot'**
  String get ill_depot;

  /// Illustration semantic label: ill_driver
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get ill_driver;

  /// Illustration semantic label: ill_breakdown
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get ill_breakdown;

  /// Illustration semantic label: ill_empty_map
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get ill_empty_map;

  /// Illustration semantic label: ill_empty_tasks
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get ill_empty_tasks;

  /// Illustration semantic label: ill_no_results
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get ill_no_results;

  /// Illustration semantic label: ill_error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get ill_error;

  /// Illustration semantic label: ill_offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get ill_offline;

  /// Illustration semantic label: ill_no_notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get ill_no_notifications;

  /// Illustration semantic label: ill_forbidden
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get ill_forbidden;

  /// Illustration semantic label: ill_not_found
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get ill_not_found;
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
