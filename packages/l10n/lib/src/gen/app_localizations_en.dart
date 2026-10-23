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
  String get shell_search_hint => 'Search orders, drivers, vehicles…';

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
}
