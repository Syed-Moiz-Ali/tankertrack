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
  String get designSearchHint => 'Search orders, drivers, vehiclesÃ¢â‚¬Â¦';

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
  String get langArabic => 'Ã˜Â§Ã™â€žÃ˜Â¹Ã˜Â±Ã˜Â¨Ã™Å Ã˜Â©';

  @override
  String get nav_dashboard => 'Dashboard';

  @override
  String get nav_tower => 'Control Tower';

  @override
  String get nav_customers => 'Customers';

  @override
  String get nav_depots => 'Depots';

  @override
  String get nav_products => 'Products';

  @override
  String get nav_drivers => 'Drivers';

  @override
  String get nav_vehicles => 'Vehicles';

  @override
  String get nav_catalogue => 'UI catalogue';

  @override
  String get nav_signout => 'Sign out';

  @override
  String get shell_search_hint => 'Search orders, drivers, vehiclesÃ¢â‚¬Â¦';

  @override
  String get shell_notifications => 'Notifications';

  @override
  String get shell_demo_role => 'Demo role';

  @override
  String get shell_online => 'Online';

  @override
  String get shell_offline => 'Offline';

  @override
  String get mfa_title => 'Two-step verification';

  @override
  String get mfa_hint => 'Enter the 6-digit code from your authenticator app.';

  @override
  String get mfa_code_label => 'Verification code';

  @override
  String get mfa_verify => 'Verify';

  @override
  String get mfa_invalid => 'Invalid code. Try again.';

  @override
  String get mfa_note_demo => 'Demo build: any 6-digit code is accepted.';

  @override
  String get err403_title => 'Access denied';

  @override
  String get err403_message => 'You do not have permission to view this page.';

  @override
  String get err404_title => 'Page not found';

  @override
  String get err404_message =>
      'The page you are looking for does not exist or was moved.';

  @override
  String get err_back_home => 'Back to home';

  @override
  String get dash_title => 'Dashboard';

  @override
  String get dash_kpi_requested => 'Requested';

  @override
  String get dash_kpi_loaded => 'Loaded';

  @override
  String get dash_kpi_delivered => 'Delivered';

  @override
  String get dash_kpi_pending => 'Pending';

  @override
  String get dash_orders_by_status => 'Orders by status';

  @override
  String get dash_drivers => 'Drivers';

  @override
  String get dash_vehicles => 'Vehicles';

  @override
  String get dash_late_orders => 'Late orders';

  @override
  String get dash_alerts => 'Alerts';

  @override
  String get dash_reload => 'Reload required';

  @override
  String get dash_process_title => 'How it works';

  @override
  String get dash_step1 => 'Login';

  @override
  String get dash_step2 => 'Create Sales Order';

  @override
  String get dash_step3 => 'Assign & Dispatch';

  @override
  String get dash_step4 => 'Live Operations';

  @override
  String get dash_step5 => 'Delivery Monitoring';

  @override
  String get dash_step6 => 'Reports & Analytics';

  @override
  String get dash_step7 => 'Reconcile & Close';

  @override
  String get dash_step8 => 'Admin & Setup';

  @override
  String get tower_title => 'Control Tower';

  @override
  String get tower_live => 'Live';

  @override
  String get tower_board => 'Operations board';

  @override
  String get tower_alerts => 'Alerts';

  @override
  String get tower_reload => 'Reload required';

  @override
  String get mst_search => 'Search';

  @override
  String get mst_all => 'All';

  @override
  String get mst_active => 'Active';

  @override
  String get mst_inactive => 'Inactive';

  @override
  String get mst_create => 'Create';

  @override
  String get mst_edit => 'Edit';

  @override
  String get mst_save => 'Save';

  @override
  String get mst_name_en => 'Name (English)';

  @override
  String get mst_name_ar => 'Name (Arabic)';

  @override
  String get mst_phone => 'Phone';

  @override
  String get mst_contact => 'Contact';

  @override
  String get mst_status => 'Status';

  @override
  String get mst_capacity => 'Capacity';

  @override
  String get mst_onboard => 'On board';

  @override
  String get mst_docs_ok => 'Documents valid';

  @override
  String get mst_docs_expiring => 'Documents expiring';

  @override
  String get mst_empty_title => 'Nothing here yet';

  @override
  String get mst_empty_message => 'Items you create will appear in this list.';

  @override
  String get mst_error_title => 'Something went wrong';

  @override
  String get mst_retry => 'Retry';

  @override
  String get cust_sites_tab => 'Sites';

  @override
  String get cust_orders_hint => 'Orders for this customer appear here.';

  @override
  String get site_geofence => 'Geofence';

  @override
  String get site_gate_hours => 'Gate hours';

  @override
  String get site_lat => 'Latitude';

  @override
  String get site_lng => 'Longitude';

  @override
  String get drv_licence => 'Licence';

  @override
  String get drv_calendar_title => 'Schedule';

  @override
  String get drv_commitments => 'Commitments';

  @override
  String get veh_balance => 'Balance';

  @override
  String get veh_calendar_title => 'Schedule';

  @override
  String get veh_defect_block => 'Blocked: critical defect reported.';

  @override
  String get cal_today => 'Today';

  @override
  String get cal_commitment_days => 'Commitment days';

  @override
  String get depot_hours => 'Working hours';

  @override
  String get depot_products => 'Products';

  @override
  String get prod_unit => 'Unit';

  @override
  String get prod_active => 'Active';

  @override
  String list_rows(int count) {
    return '$count rows';
  }

  @override
  String get role_admin => 'Administrator';

  @override
  String get role_sales => 'Sales';

  @override
  String get role_dispatcher => 'Dispatcher';

  @override
  String get role_fleet => 'Fleet Controller';

  @override
  String get role_driver => 'Driver';

  @override
  String get role_supervisor => 'Supervisor';

  @override
  String get role_finance => 'Finance';

  @override
  String get role_customer => 'Customer';

  @override
  String get st_order_draft => 'Draft';

  @override
  String get st_order_confirmed => 'Confirmed';

  @override
  String get st_order_on_hold => 'On hold';

  @override
  String get st_order_unassigned => 'Unassigned';

  @override
  String get st_order_assigned => 'Assigned';

  @override
  String get st_order_in_progress => 'In progress';

  @override
  String get st_order_completed => 'Completed';

  @override
  String get st_order_partial => 'Partial';

  @override
  String get st_order_failed => 'Failed';

  @override
  String get st_order_cancelled => 'Cancelled';

  @override
  String get st_trip_planned => 'Planned';

  @override
  String get st_trip_assigned => 'Assigned';

  @override
  String get st_trip_accepted => 'Accepted';

  @override
  String get st_trip_started => 'Started';

  @override
  String get st_trip_at_loading => 'At loading';

  @override
  String get st_trip_loaded => 'Loaded';

  @override
  String get st_trip_delivering => 'Delivering';

  @override
  String get st_trip_paused => 'Paused';

  @override
  String get st_trip_breakdown => 'Breakdown';

  @override
  String get st_trip_completed => 'Completed';

  @override
  String get st_trip_closed => 'Closed';

  @override
  String get st_task_pending => 'Pending';

  @override
  String get st_task_accepted => 'Accepted';

  @override
  String get st_task_en_route => 'En route';

  @override
  String get st_task_arrived => 'Arrived';

  @override
  String get st_task_started => 'Started';

  @override
  String get st_task_completed => 'Completed';

  @override
  String get st_task_skipped => 'Skipped';

  @override
  String get st_task_failed => 'Failed';

  @override
  String get st_task_cancelled => 'Cancelled';

  @override
  String get st_vehicle_available => 'Available';

  @override
  String get st_vehicle_reserved => 'Reserved';

  @override
  String get st_vehicle_loading => 'Loading';

  @override
  String get st_vehicle_in_transit => 'In transit';

  @override
  String get st_vehicle_at_customer => 'At customer';

  @override
  String get st_vehicle_on_break => 'On break';

  @override
  String get st_vehicle_breakdown => 'Breakdown';

  @override
  String get st_vehicle_maintenance => 'Maintenance';

  @override
  String get st_vehicle_out_of_service => 'Out of service';

  @override
  String get st_driver_offline => 'Offline';

  @override
  String get st_driver_available => 'Available';

  @override
  String get st_driver_assigned => 'Assigned';

  @override
  String get st_driver_driving => 'Driving';

  @override
  String get st_driver_working => 'Working';

  @override
  String get st_driver_waiting => 'Waiting';

  @override
  String get st_driver_on_break => 'On break';

  @override
  String get st_driver_breakdown => 'Breakdown';

  @override
  String get st_driver_completed_day => 'Day completed';

  @override
  String get st_cust_active => 'Active';

  @override
  String get st_cust_credit_hold => 'Credit hold';

  @override
  String get st_cust_inactive => 'Inactive';

  @override
  String get st_sev_critical => 'Critical';

  @override
  String get st_sev_high => 'High';

  @override
  String get st_sev_medium => 'Medium';

  @override
  String get st_sev_low => 'Low';

  @override
  String get st_sev_info => 'Info';

  @override
  String get st_duty_on => 'On duty';

  @override
  String get st_duty_off => 'Off duty';

  @override
  String get st_duty_suspended => 'Suspended';

  @override
  String get st_duty_leave => 'On leave';

  @override
  String get st_live_active => 'Active';

  @override
  String get st_live_loading => 'Loading';

  @override
  String get st_live_unloading => 'Unloading';

  @override
  String get st_live_waiting => 'Waiting';

  @override
  String get st_live_completed => 'Completed';

  @override
  String get st_live_critical => 'Critical';

  @override
  String get st_live_offline => 'Offline';

  @override
  String dash_greeting_morning(String name) {
    return 'Good morning, $name';
  }

  @override
  String dash_greeting_afternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String dash_greeting_evening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get seg_loading_now => 'Loading now';

  @override
  String get seg_in_transit => 'In transit';

  @override
  String get seg_arriving_soon => 'Arriving soon';

  @override
  String get seg_upcoming => 'Upcoming';

  @override
  String get seg_needs_attention => 'Needs attention';

  @override
  String get fleet_today => 'Your fleet today';

  @override
  String get map_show_all => 'Show all';

  @override
  String get kpi_trend_up => 'up from yesterday';

  @override
  String get kpi_trend_down => 'down from yesterday';

  @override
  String get menu_title => 'Menu';

  @override
  String get menu_control_tower => 'Control Tower';

  @override
  String get menu_depots => 'Depots';

  @override
  String get menu_products => 'Products';

  @override
  String get menu_drivers => 'Drivers';

  @override
  String get menu_design => 'UI catalogue';

  @override
  String get menu_theme => 'Theme';

  @override
  String get menu_language => 'Language';

  @override
  String get menu_demo_role => 'Demo role';

  @override
  String get menu_sign_out => 'Sign out';

  @override
  String get menu_profile => 'Profile';

  @override
  String get search_order => 'Order';

  @override
  String get search_driver => 'Driver';

  @override
  String get search_vehicle => 'Vehicle';

  @override
  String get search_customer => 'Customer';

  @override
  String get detail_edit => 'Edit';

  @override
  String get detail_assign => 'Assign';

  @override
  String get detail_block => 'Block';

  @override
  String get detail_overview => 'Overview';

  @override
  String get detail_location => 'Where it is';

  @override
  String get detail_availability => 'Availability';

  @override
  String get detail_documents => 'Documents';

  @override
  String get detail_activity => 'Activity';

  @override
  String get detail_show_all => 'Show all';

  @override
  String get detail_photos => 'Show all photos';

  @override
  String get login_welcome => 'Welcome to TankerTrack';

  @override
  String get login_demo_accounts => 'Demo accounts';

  @override
  String get tab_today => 'Today';

  @override
  String get tab_tasks => 'Tasks';

  @override
  String get tab_messages => 'Messages';

  @override
  String get tab_profile => 'Profile';

  @override
  String get today_next_up => 'Next up';

  @override
  String get tab_fleet => 'Fleet';

  @override
  String get inc_breakdown => 'Breakdown';

  @override
  String get inc_accident => 'Accident';

  @override
  String get inc_spill => 'Spill';

  @override
  String get inc_customer_unavailable => 'Customer unavailable';

  @override
  String get inc_meter_issue => 'Meter issue';

  @override
  String get inc_traffic => 'Traffic delay';

  @override
  String get inc_access_denied => 'Access denied';

  @override
  String get inc_gps_issue => 'GPS issue';

  @override
  String get ntf_assigned => 'Order assigned';

  @override
  String get ntf_late_eta => 'Late ETA risk';

  @override
  String get ntf_geofence => 'Geofence event';

  @override
  String get ntf_variance => 'Quantity variance';

  @override
  String get ntf_deviation => 'Route deviation';

  @override
  String get ntf_doc_expiry => 'Document expiring';

  @override
  String get ntf_gps_stale => 'GPS stale';

  @override
  String get nav_today => 'Today';

  @override
  String get nav_orders => 'Orders';

  @override
  String get nav_dispatch => 'Dispatch';

  @override
  String get nav_live => 'Live';

  @override
  String get nav_fleet => 'Fleet & people';

  @override
  String get nav_more => 'More';

  @override
  String get cmd_search_hint =>
      'Search orders, trips, drivers, vehiclesÃ¢â‚¬Â¦';

  @override
  String get cmd_no_results => 'No matches';

  @override
  String get idle_title => 'Session expiring';

  @override
  String idle_message(String seconds) {
    return 'You will be signed out in ${seconds}s for security.';
  }

  @override
  String get idle_stay => 'Stay signed in';

  @override
  String get idle_signout => 'Sign out now';

  @override
  String get menu_about => 'About';

  @override
  String get about_title => 'About TankerTrack';

  @override
  String get about_photos => 'Photo credits';

  @override
  String get auth_forgot_title => 'Forgot password';

  @override
  String get auth_forgot_hint =>
      'Enter your work email to receive a reset link.';

  @override
  String get auth_forgot_send => 'Send reset link';

  @override
  String get auth_forgot_sent => 'Reset link sent. Check your inbox.';

  @override
  String get auth_otp_title => 'Verify it is you';

  @override
  String get auth_otp_hint => 'Enter the 6-digit code we sent.';

  @override
  String get auth_otp_verify => 'Verify';

  @override
  String get auth_otp_resend => 'Resend code';

  @override
  String get auth_otp_invalid => 'Wrong code. Try again.';

  @override
  String get auth_role_title => 'Choose your role';

  @override
  String get auth_role_hint => 'You will see the workspace for this role.';

  @override
  String dash_sentence(String active, String delayed) {
    return '$active deliveries active, $delayed delayed.';
  }

  @override
  String get dash_more_numbers => 'More numbers';

  @override
  String get dash_needs_attention => 'Needs attention';

  @override
  String get dash_latest_activity => 'Latest activity';

  @override
  String get dash_view => 'View';

  @override
  String get dash_remaining => 'Remaining';

  @override
  String get dash_eta => 'ETA';

  @override
  String get dash_distance => 'Distance';

  @override
  String get dash_telemetry_note => 'tank telemetry';

  @override
  String get list_cards => 'Cards';

  @override
  String get list_list => 'List';

  @override
  String get sheet_open_full => 'Open full page';

  @override
  String get dr_verify_title => 'Verify your account';

  @override
  String get dr_verify_hint => 'Enter your driver ID and PIN.';

  @override
  String dr_good_morning(String name) {
    return 'Good morning, $name';
  }

  @override
  String get dr_confirm_vehicle => 'Confirm vehicle & start shift';

  @override
  String get dr_odometer => 'Odometer reading';

  @override
  String get dr_odometer_error => 'Reading cannot be less than yesterday.';

  @override
  String get dr_location_consent => 'Allow location during shift';

  @override
  String get dr_start_shift => 'Start shift';

  @override
  String get dr_ready_online => 'Ready to start Ã¢â‚¬â€ Online';

  @override
  String get demo_reset => 'Reset demo';

  @override
  String get demo_state_empty => 'Empty';

  @override
  String get demo_state_loading => 'Loading';

  @override
  String get demo_state_error => 'Error';

  @override
  String get demo_state_success => 'Success';

  @override
  String get demo_screen_state => 'Screen state';

  @override
  String get state_empty_title => 'Nothing here';

  @override
  String get state_loading_title => 'LoadingÃ¢â‚¬Â¦';

  @override
  String get state_error_title => 'Something went wrong';

  @override
  String get state_success_title => 'All good';

  @override
  String get bo01_empty => 'TODO bo01_empty';

  @override
  String get bo01_loading => 'TODO bo01_loading';

  @override
  String get bo01_error => 'TODO bo01_error';

  @override
  String get bo01_success => 'TODO bo01_success';

  @override
  String get bo02_empty => 'TODO bo02_empty';

  @override
  String get bo02_loading => 'TODO bo02_loading';

  @override
  String get bo02_error => 'TODO bo02_error';

  @override
  String get bo02_success => 'TODO bo02_success';

  @override
  String get bo03_empty => 'TODO bo03_empty';

  @override
  String get bo03_loading => 'TODO bo03_loading';

  @override
  String get bo03_error => 'TODO bo03_error';

  @override
  String get bo03_success => 'TODO bo03_success';

  @override
  String get bo04_empty => 'TODO bo04_empty';

  @override
  String get bo04_loading => 'TODO bo04_loading';

  @override
  String get bo04_error => 'TODO bo04_error';

  @override
  String get bo04_success => 'TODO bo04_success';

  @override
  String get bo05_empty => 'TODO bo05_empty';

  @override
  String get bo05_loading => 'TODO bo05_loading';

  @override
  String get bo05_error => 'TODO bo05_error';

  @override
  String get bo05_success => 'TODO bo05_success';

  @override
  String get bo15_empty => 'TODO bo15_empty';

  @override
  String get bo15_loading => 'TODO bo15_loading';

  @override
  String get bo15_error => 'TODO bo15_error';

  @override
  String get bo15_success => 'TODO bo15_success';

  @override
  String get bo16_empty => 'TODO bo16_empty';

  @override
  String get bo16_loading => 'TODO bo16_loading';

  @override
  String get bo16_error => 'TODO bo16_error';

  @override
  String get bo16_success => 'TODO bo16_success';

  @override
  String get bo17_empty => 'TODO bo17_empty';

  @override
  String get bo17_loading => 'TODO bo17_loading';

  @override
  String get bo17_error => 'TODO bo17_error';

  @override
  String get bo17_success => 'TODO bo17_success';

  @override
  String get bo18_empty => 'TODO bo18_empty';

  @override
  String get bo18_loading => 'TODO bo18_loading';

  @override
  String get bo18_error => 'TODO bo18_error';

  @override
  String get bo18_success => 'TODO bo18_success';

  @override
  String get bo26_empty => 'TODO bo26_empty';

  @override
  String get bo26_loading => 'TODO bo26_loading';

  @override
  String get bo26_error => 'TODO bo26_error';

  @override
  String get bo26_success => 'TODO bo26_success';

  @override
  String get dr02_empty => 'TODO dr02_empty';

  @override
  String get dr02_loading => 'TODO dr02_loading';

  @override
  String get dr02_error => 'TODO dr02_error';

  @override
  String get dr02_success => 'TODO dr02_success';

  @override
  String get dr03_empty => 'TODO dr03_empty';

  @override
  String get dr03_loading => 'TODO dr03_loading';

  @override
  String get dr03_error => 'TODO dr03_error';

  @override
  String get dr03_success => 'TODO dr03_success';

  @override
  String get ill_tanker => 'Tanker truck';

  @override
  String get ill_depot => 'Fuel depot';

  @override
  String get ill_driver => 'Driver';

  @override
  String get ill_breakdown => 'Breakdown';

  @override
  String get ill_empty_map => 'Map';

  @override
  String get ill_empty_tasks => 'Tasks';

  @override
  String get ill_no_results => 'No results';

  @override
  String get ill_error => 'Error';

  @override
  String get ill_offline => 'Offline';

  @override
  String get ill_no_notifications => 'Notifications';

  @override
  String get ill_forbidden => 'Restricted';

  @override
  String get ill_not_found => 'Not found';
}
