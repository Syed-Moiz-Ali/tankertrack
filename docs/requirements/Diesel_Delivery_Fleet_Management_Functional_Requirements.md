# **DIESEL DELIVERY, LOADING & FLEET TRACKING SYSTEM** 

## **Functional Requirements Specification (FRS)** 

Back Office Web Portal + Driver Mobile Application + GPS Fleet Tracking 

|**Document Item**|**Details**|
|---|---|
|Purpose|Define the complete business process, modules, screens, data,<br>controls, integrations, reports and audit trail required to manage<br>diesel loading, transportation and customer delivery operations.|
|Primary Users|Back Office / Sales / Dispatcher / Operations / Fleet Controller /<br>Driver / Supervisor / Finance / Management / System<br>Administrator|
|Operating Unit|Imperial Gallons (IG) as the primary requested quantity unit;<br>system should allow configurable conversion to litres if required.|
|Channels|Responsive back-office web portal; Android/iOS driver mobile<br>application; optional management mobile dashboard.|
|Core Objective|Know what must be delivered, by whom, in which vehicle, from<br>which loading point, to which customer, how much was<br>loaded/unloaded, and exactly where and when each event<br>occurred.|



## **1. Executive Summary** 

The proposed solution is a dispatch, fleet tracking and diesel delivery execution platform. A back-office user receives a customer request and creates a Sales Order / Delivery Order. The order is assigned to a driver and vehicle. The driver receives the assigned work on the mobile app, starts the day, travels to the loading source, records loading, proceeds to the customer, records arrival and unloading, captures proof of delivery, and continues to the next task. Throughout the day, GPS location, journey status, stops, breaks, inspections, breakdowns, route deviations and timestamps are retained to create a complete operational audit trail. 

The system must support 50-100+ orders per day and multiple drivers/vehicles operating simultaneously. Dispatchers must be able to monitor capacity, availability, task progress, delayed orders and live driver positions from one control screen. 

## **2. End-to-End Business Flow** 

|**Step**|**Stage**|**System Requirement**|
|---|---|---|
|1|Customer inquiry / sales request received|Back office records customer, delivery<br>site, product, quantity in IG, requested<br>date/time and commercial/reference<br>details.|
|2|Sales Order created|System generates unique order number<br>and validates required data.|
|3|Planning & assignment|Dispatcher selects source/loading point,|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Step**|**Stage**|**System Requirement**|
|---|---|---|
|||driver, vehicle and planned sequence.<br>Vehicle capacity and driver/vehicle<br>availability are checked.|
|4|Driver notified|Driver receives push notification and sees<br>the assigned daily task list.|
|5|Driver starts day|Driver performs pre-trip inspection,<br>confirms vehicle/odometer/fuel status and<br>starts duty.|
|6|Travel to loading point|GPS trip begins. ETA, distance and route<br>are visible to back office.|
|7|Loading|Driver arrives, checks in, records actual<br>loaded quantity, loading meter/ticket<br>details, photos/documents and departure<br>time.|
|8|Travel to customer|System tracks vehicle live, ETA, stops,<br>route deviations and status.|
|9|Customer arrival & unloading|Driver records arrival, unloading start/end,<br>actual delivered quantity, delivery<br>evidence, customer<br>acknowledgment/signature and any<br>variance.|
|10|Next task / reload|Driver proceeds to next customer if<br>sufficient loaded stock exists, or returns to<br>a loading point for the next load, according<br>to dispatch plan.|
|11|Exception handling|Break, lunch, inspection, waiting, queue,<br>breakdown, road closure, customer<br>unavailable, partial/rejected delivery and<br>other events are logged.|
|12|Day closure|Driver ends duty. System summarizes<br>total distance, driving, working, idle, break,<br>loading/unloading time, quantities and<br>completed/pending tasks.|



## **3. Solution Components** 

|**Component**|**Purpose**|
|---|---|
|Back Office Web Portal|Order entry, dispatch planning, live operations, driver/vehicle<br>management, maps, quantity control, exceptions, approvals and<br>reporting.|
|Driver Mobile Application|Simple task execution interface with daily jobs, navigation, event<br>buttons, inspections, loading/unloading capture, proof of delivery<br>and incident reporting.|
|GPS / Telematics Layer|Continuous or configurable location updates, trip paths,<br>geofences, speed, stops, route deviation and ETA.|
|Notification Service|Push/SMS/email alerts for assignment, delay, arrival, completion,<br>exceptions, breakdown and reassignment.|
|Reporting & Audit Database|Immutable timestamps, user actions, quantities,<br>photos/documents, GPS trails and operational KPI reporting.|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Component**|**Purpose**|
|---|---|
|Integration Layer / API|Google Maps or equivalent, ERP/accounting, customer master,<br>telematics provider, fuel meter/IoT, SMS/email and optional e-<br>invoicing.|



## **4. User Roles & Permissions** 

|**Role**|**Typical Access**|
|---|---|
|System Administrator|Users, roles, configuration, master data, integrations, security<br>and audit settings.|
|Sales / Customer Service|Create/edit customer inquiries and Sales Orders; view order<br>status.|
|Dispatcher / Operations|Assign/reassign drivers and vehicles, optimize sequence,<br>manage live board, exceptions and ETA.|
|Fleet Controller|Vehicle availability, inspection, breakdown, maintenance and<br>utilization.|
|Driver|Only own assigned/current tasks and permitted data capture; no<br>commercial editing.|
|Supervisor / Manager|Operational dashboard, approvals, overrides, KPI and audit<br>reports.|
|Finance / Accounts|Completed delivery quantities, invoice-ready data, customer<br>references and reconciliation; restricted operational editing.|
|Customer Portal User (Optional)|View own order, ETA, POD and delivery status only.|



## **5. Back Office Modules** 

|**Module**|**Key Functions**|
|---|---|
|Dashboard / Control Tower|Today orders by status; total requested/loaded/delivered/pending<br>IG; drivers available/busy/offline; vehicles<br>free/assigned/breakdown/maintenance; late orders; map of all<br>live vehicles; alerts; reload requirements.|
|Customer Master|Customer account, contacts, billing/delivery addresses, GPS<br>coordinates, site instructions, working hours, credit/hold status,<br>preferred product and geofence.|
|Delivery Site Master|Multiple sites per customer; site contact; access notes; gate<br>timing; unloading point coordinates; tank details; delivery<br>restrictions.|
|Product / Diesel Master|Product code/name, unit, density/conversion if used, safety notes<br>and active/inactive control.|
|Sales Order / Delivery Order|Create single or bulk orders, required quantity, product, delivery<br>site, date/time window, priority, source, PO/reference, notes and<br>status.|
|Dispatch Planning Board|Unassigned and assigned jobs; drag/drop assignment; route<br>sequence; capacity check; time-window check; conflict warnings;<br>driver/vehicle workload.|
|Driver Management|Profile, licence/permit, mobile, shift, status, availability,|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Module**|**Key Functions**|
|---|---|
||competency/expiry, current task and history.|
|Vehicle / Tanker Management|Registration, tanker capacity, compartments if applicable,<br>permitted products, documents/expiry, odometer, current<br>quantity/on-board balance, availability and maintenance status.|
|Loading Point / Depot Master|Depot/supplier/site, coordinates, contact, operating hours,<br>queue/slot details, allowed products, geofence.|
|Live Fleet Tracking|All active drivers/vehicles on map with status, route, last update,<br>speed if available, current task, ETA, loaded quantity and alert<br>state.|
|Trip / Journey Management|Actual route, event timeline, driving time, waiting time,<br>loading/unloading time, stops, break, idle, deviation and trip<br>closure.|
|Quantity & Inventory-on-Vehicle|Planned load, actual loaded, quantity delivered per order,<br>remaining on-board quantity, returns, variance and reconciliation.|
|Inspection & Compliance|Pre-trip/post-trip checklist, tanker/vehicle checks, PPE/safety<br>checks, defects, photos, approval and blocking defects.|
|Exception & Incident Management|Breakdown, accident, customer unavailable, rejected delivery,<br>access denied, meter issue, shortage/excess, spill, traffic delay,<br>route closure, mobile/GPS issue.|
|Notifications & Escalations|Assignment, late departure, ETA risk, geofence arrival/departure,<br>excessive stop, route deviation, breakdown, order completion<br>and overdue tasks.|
|Proof of Delivery Repository|Customer signature/name, photos, documents, delivery<br>ticket/meter reading, coordinates and timestamps.|
|Reports & Analytics|Order, quantity, driver, vehicle, trip, utilization, delay, exception,<br>POD, geofence and reconciliation reports.|
|Configuration & Security|Statuses, reason codes, shift rules, GPS intervals, geofence<br>radius, tolerances, approval limits, user rights and API<br>configuration.|



## **6. Sales Order / Delivery Order Data Requirements** 

|**Data Group**|**Fields / Information**|
|---|---|
|Order Identity|Sales Order No.; inquiry/reference no.; customer PO; creation<br>date/time; created by; branch/company.|
|Customer|Customer code/name; billing customer if different; contact<br>person; phone.|
|Delivery Site|Site name/address; latitude/longitude; geofence; site contact;<br>access instructions; operating hours.|
|Delivery Requirement|Requested delivery date; time window; priority; product/diesel<br>grade; requested quantity (IG); notes.|
|Loading Requirement|Planned loading point/depot; loading slot/time if applicable;<br>source reference.|
|Assignment|Assigned driver; vehicle/tanker; assistant/helper if applicable;<br>planned sequence/run number.|
|Commercial / Reference|Rate/price optional; tax; contract no.; project/site code; cost|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Data Group**|**Fields / Information**|
|---|---|
||centre; ERP reference.|
|Status|Draft; confirmed; unassigned; assigned; accepted; en route to<br>loading; loading; loaded; en route customer; arrived; unloading;<br>completed; partial; failed; cancelled; on hold.|
|Actuals|Actual load, actual delivery, balance/return, loading ticket, meter<br>readings, completion/POD and variance reason.|



## **7. Dispatch Planning & Assignment Logic** 

- An order should not be dispatchable without mandatory customer/site coordinates, product, quantity and delivery date/time. 

- System must show available drivers and vehicles for the requested period and prevent double-booking unless supervisor override is used. 

- Vehicle/tanker capacity must be compared against planned loading quantity. If one load serves multiple customers, cumulative delivery quantity must not exceed available on-board quantity. 

- A dispatcher must be able to group multiple Sales Orders into a Trip / Run, define the loading point and delivery sequence, then assign the run to one driver and vehicle. 

- An order may be reassigned before or during execution. The reason, old assignment, new assignment, user and timestamp must be audited. 

- Dispatch board should highlight conflicts: capacity shortage, overlapping driver tasks, vehicle maintenance/block, expired documents, late ETA, delivery time-window conflict and incomplete mandatory inspection. 

- Optional optimization can suggest the best delivery sequence using source/customer geography, time windows, vehicle quantity, priority and current driver location. 

## **8. Driver Mobile Application** 

### **8.1 Design Principle** 

The driver application should be intentionally simple: large buttons, minimum typing, clear task status, offline resilience, navigation integration and guided step-by-step execution. The driver should normally interact with one current task at a time while still seeing the full planned day. 

### **8.2 Driver Home / Day Dashboard** 

|**Widget / Section**|**Required Information**|
|---|---|
|Day Summary|Date, shift, driver, vehicle, number of assigned jobs, completed,<br>pending, cancelled/failed.|
|Quantity Summary|Planned to load, actual loaded, delivered, remaining on vehicle<br>and returned quantity in IG.|
|Current Task|Next action, customer/loading point, quantity, distance, ETA,<br>priority and one-tap navigation.|
|Task List|Sequence, order no., type (Load / Deliver / Return), location,<br>quantity, status and target time.|
|Duty Controls|Start Day / End Day; Break; Lunch; Breakdown; Inspection;<br>Emergency / Incident.|
|Connectivity / GPS|Online/offline indicator, GPS status, last synchronization time.|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

### **8.3 Driver Day Workflow** 

1. Sign in securely (PIN/password/biometric depending policy). 

2. Confirm assigned vehicle and shift. 

3. Complete mandatory pre-trip inspection; defects are recorded with photo and severity. 

4. Tap Start Day. System records time and GPS position. 

5. Open first task and tap Start Journey. Navigation opens and tracking begins. 

6. On entering loading-point geofence, app may auto-suggest Arrived; driver confirms. 

7. Record loading start, actual loaded quantity, meter/ticket number, before/after meter if used, photo and loading completion. 

8. Tap Depart Loading Point. On-board balance updates. 

9. Navigate to customer. Back office sees live location and ETA. 

10. On customer arrival, record Arrived, then Start Unloading. 

11. Record actual quantity delivered, meter/ticket readings, delivery outcome and customer POD. 

12. Tap Complete Delivery. System recalculates remaining loaded quantity. 

13. Proceed to next delivery or reload task based on the planned sequence. 

14. Use Break/Lunch/Waiting/Breakdown/Incident buttons whenever applicable; reason and timestamps are captured. 

15. After final task, complete post-trip checks if required and tap End Day. 

## **9. Loading Transaction** 

|**Field / Event**|**Requirement**|
|---|---|
|Arrival at source|GPS, geofence result, timestamp, odometer (manual or<br>telematics), source/depot.|
|Loading start/end|Separate timestamps to calculate loading duration.|
|Product|Must match order/run; supervisor override for substitution.|
|Planned quantity|Quantity expected to load in IG.|
|Actual loaded quantity|Mandatory numeric field in IG; tolerance rules configurable.|
|Meter / ticket data|Loading ticket no.; meter start/end; supplier/reference document<br>as applicable.|
|Evidence|Photo(s) of ticket/meter/vehicle where required.|
|On-board balance|System adds actual load to current vehicle quantity.|
|Variance|Difference between planned and actual; reason mandatory<br>outside tolerance.|
|Departure|Timestamp, GPS, next destination and ETA.|



## **10. Customer Delivery / Unloading Transaction** 

|**Field / Event**|**Requirement**|
|---|---|
|Arrival|GPS coordinates, timestamp, geofence status, customer/site.|
|Waiting|Optional automatic or manual waiting start if unloading cannot<br>start immediately.|
|Unloading start/end|Separate timestamps for service-time calculation.|
|Planned delivery|Requested/allocated IG for the Sales Order.|
|Actual delivery|Mandatory delivered IG. Must not exceed available on-board|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Field / Event**|**Requirement**|
|---|---|
||quantity without override.|
|Meter readings|Before/after or delivery meter values if used.|
|POD|Customer receiver name, signature, optional OTP, photo,<br>delivery note/ticket and timestamp.|
|Result|Full delivery, partial delivery, rejected, customer unavailable,<br>access denied or other configured outcome.|
|Variance|Short/excess quantity and reason; supervisor approval above<br>threshold.|
|Balance|System deducts actual delivery from on-board quantity.|
|Departure|GPS/time and next task.|



## **11. Live GPS Tracking & Map Requirements** 

- Back office must display all active drivers/vehicles on one map with vehicle/driver identifier, current status, current order/run, destination, last GPS time and current on-board quantity. 

- GPS points should be captured at a configurable interval while on duty/trip (for example more frequently when moving and less frequently when stationary) to balance tracking quality and mobile battery/data usage. 

- Trip history must show the breadcrumb route, start/end, stops, duration, distance and event markers. 

- Geofences should be maintained for depots/loading points and customer sites so the system can detect arrival/departure and compare manual events with actual location. 

- ETA and route should use Google Maps Platform or an equivalent mapping/routing service. Back office should see expected arrival time and delay against required time window. 

- Route deviation, prolonged unauthorized stop, loss of GPS, excessive idle and overdue arrival should generate configurable alerts. 

- Location history should be captured only according to company policy and applicable privacy/employment requirements; driver app should clearly show when duty tracking is active. 

## **12. Driver Status, Stops & Time Classification** 

|**Status / Event**|**How It Should Work**|
|---|---|
|Available|Driver logged in/on roster but not assigned or ready for dispatch.|
|Assigned|Has future/current tasks but journey not started.|
|Driving to Loading|GPS trip between current position and source.|
|Waiting at Loading|At source but loading not started; queue/wait reason.|
|Loading|Actual loading operation in progress.|
|Driving to Customer|Loaded and moving to delivery location.|
|Waiting at Customer|Arrived but unloading not started.|
|Unloading|Delivery transfer in progress.|
|Break|Short rest; driver selects reason if required.|
|Lunch|Meal break with start/end time.|
|Inspection|Vehicle/safety inspection activity.|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Status / Event**|**How It Should Work**|
|---|---|
|Breakdown|Vehicle disabled; capture severity, location, notes/photo and<br>assistance status.|
|Incident / Emergency|Accident, spill, safety event, police/authority stop or other<br>incident.|
|Offline / No GPS|Device or connectivity issue; app queues events for<br>synchronization.|
|Day Completed|Driver ended shift/duty.|



## **13. Vehicle & Driver Availability Management** 

The system should maintain a time-based availability calendar rather than only a simple free/busy flag. This allows the dispatcher to see current and future commitments. 

|**Entity**|**Required Availability Information**|
|---|---|
|Driver|On duty/off duty, shift, leave, break, busy until, current location,<br>assigned run, licence/permit expiry, suspended/unavailable<br>reason.|
|Vehicle|Free/assigned/in trip, estimated free time, location, tanker<br>capacity, current on-board quantity, maintenance, breakdown,<br>inspection block, registration/permit/insurance expiry.|
|Loading Point|Open/closed, product availability if tracked, operating hours,<br>queue/slot status.|



## **14. Quantity Control & Reconciliation** 

Quantity reconciliation is a core financial and operational control. Every movement should be traceable using a simple vehicle balance ledger. 

|**Transaction**|**Effect on Vehicle Balance**|
|---|---|
|Opening / Carry Forward|Opening on-board quantity if the tanker starts the day with<br>product.|
|Load|Increase by actual loaded quantity.|
|Delivery / Unload|Decrease by actual delivered quantity.|
|Return to Depot|Decrease by quantity returned from vehicle and recorded at<br>depot.|
|Transfer Between Vehicles|Decrease from source vehicle and increase destination vehicle,<br>subject to authorization.|
|Adjustment|Controlled supervisor-only transaction with mandatory reason<br>and audit trail.|



Recommended reconciliation formula: Opening Quantity + Total Loaded - Total Delivered - Total Returned +/- Authorized Adjustments = Closing On-Board Quantity. The system should flag any physical/meter discrepancy outside configured tolerance. 

Diesel Delivery & Fleet Management System - Functional Requirements Specification 

## **15. Inspection & Safety Module** 

- Configurable pre-trip and post-trip checklists by vehicle type. 

- Examples: tyres, lights, brakes, leaks, hoses, valves, tanker integrity, fire extinguisher, spill kit, PPE, documents, reverse alarm, mirrors/camera and emergency equipment. 

- Each item can be Pass / Fail / N/A with remarks and photo. 

- Critical failure can automatically block vehicle dispatch until supervisor clearance. 

- Defect becomes an action item with responsible person, target date, repair status and closure evidence. 

- Inspection record stores driver, vehicle, odometer, GPS, date/time and digital acknowledgment. 

## **16. Breakdown / Incident Workflow** 

16. Driver taps Breakdown or Incident and selects category/severity. 

17. App automatically records GPS, current task, vehicle, time and remaining quantity. 

18. Driver enters short description and can add photos/video/document. 

19. Back office receives immediate alert and sees incident on map. 

20. Dispatcher may pause affected orders, assign replacement vehicle/driver or create rescue/transfer operation. 

21. All affected customer ETAs are recalculated and delays are recorded. 

22. Incident is closed only after resolution details, time and authorized user are recorded. 

## **17. Order and Trip Status Model** 

|**Object**|**Suggested Statuses**|
|---|---|
|Sales Order|Draft, Confirmed, On Hold, Unassigned, Assigned, In Progress,<br>Completed, Partial, Failed, Cancelled.|
|Trip / Run|Planned, Assigned, Accepted, Started, At Loading, Loaded,<br>Delivering, Paused, Breakdown, Completed, Closed.|
|Task|Pending, Accepted, En Route, Arrived, Started, Completed,<br>Skipped, Failed, Cancelled.|
|Vehicle|Available, Reserved, Loading, In Transit, At Customer, Break,<br>Breakdown, Maintenance, Out of Service.|
|Driver|Offline, Available, Assigned, Driving, Working, Waiting, Break,<br>Breakdown/Incident, Completed Day.|



## **18. Notifications & Alerts** 

|**Trigger**|**Recipients / Action**|
|---|---|
|Order assigned/reassigned|Driver push notification; dispatcher confirmation.|
|Driver accepts/rejects assignment|Dispatcher alert. Rejection reason required if enabled.|
|Late start / late ETA|Dispatcher/supervisor; optional customer notification.|
|Arrival at source/customer geofence|Automatic event/update; optional notification.|
|Loading/unloading completed|Back office status update; next task activated.|
|Quantity variance|Supervisor approval alert if above tolerance.|
|Breakdown / emergency|Immediate operations/supervisor alert with live location.|
|Unauthorized/prolonged stop|Dispatcher alert.|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Trigger**|**Recipients / Action**|
|---|---|
|Route deviation|Dispatcher alert based on configurable distance/time.|
|Vehicle/driver document expiry|Advance reminder to fleet/admin.|
|GPS offline / stale|Operations alert after configured threshold.|



## **19. Dashboards & Reports** 

|**Report**|**Contents**|
|---|---|
|Daily Operations Dashboard|Orders planned/completed/pending/failed, requested vs delivered<br>IG, live drivers, available vehicles, late tasks and active<br>exceptions.|
|Driver Daily Activity|Start/end day, all tasks, route, distance, driving time, working<br>time, waiting, breaks, lunch, idle, breakdown and event timeline.|
|Vehicle Utilization|Working hours, trips, distance, quantity carried/delivered, idle,<br>downtime and utilization percentage.|
|Order Fulfilment|Customer/order, requested vs delivered, planned vs actual time,<br>POD, variance and reason.|
|Loading Report|By source, date, driver, vehicle, product, planned/actual IG, ticket<br>and variance.|
|Delivery Report|By customer/site/order/driver/vehicle, actual IG, arrival, unloading<br>duration and result.|
|Quantity Reconciliation|Opening, loaded, delivered, returned, adjusted and closing<br>quantity by vehicle/day/run.|
|Delay & Waiting Analysis|Loading queue, customer waiting, traffic delay, average service<br>time and late deliveries.|
|Break / Stop Report|All non-driving stops with location, start/end, duration and reason.|
|Breakdown / Incident Report|Type, vehicle, location, downtime, affected orders, resolution and<br>cost fields if used.|
|Route & GPS History|Map replay/breadcrumb, deviations, stop points, missing GPS<br>periods and distance.|
|Inspection Compliance|Completed/missed inspections, defects, critical failures and<br>closures.|
|POD Report|Completed delivery evidence with signatures, photos and ticket<br>references.|
|Exception Audit|Overrides, manual quantity adjustments, task skips,<br>reassignments and reason/user/timestamp.|



## **20. Recommended Management KPIs** 

- On-time delivery percentage. 

- Average depot/loading waiting time. 

- Average customer unloading/service time. 

- Driver productive time vs driving/waiting/break/idle time. 

- Vehicle utilization and downtime. 

- IG requested vs loaded vs delivered vs returned. 

Diesel Delivery & Fleet Management System - Functional Requirements Specification 

- Quantity variance percentage and number of tolerance exceptions. 

- Deliveries per driver/vehicle/day. 

- Kilometres per delivered IG or per trip where useful. 

- Orders requiring reassignment, partial delivery or failure. 

- Breakdown frequency and downtime. 

- GPS tracking completeness / stale-location incidents. 

## **21. Data Model - Core Entities** 

|**Entity**<br>Customer|**Key Data**<br>customer_id, account code, name, contacts, billing data, status|
|---|---|
|Delivery Site|site_id, customer_id, address, coordinates, geofence, contact,<br>instructions, operating hours|
|Product|product_id, diesel grade, unit, conversion/density/configuration|
|Sales Order|order_id, customer/site, product, qty, requested date/time,<br>priority, status, references|
|Trip / Run|trip_id, date, driver, vehicle, loading point, planned/actual<br>sequence, status|
|Task|task_id, trip_id, type Load/Deliver/Return/etc., linked order,<br>sequence, location, status|
|Driver|driver_id, identity, licence, shift, contact, status, compliance dates|
|Vehicle|vehicle_id, registration, tanker capacity, compartments, status,<br>compliance, odometer|
|Loading Point|source_id, address, coordinates, geofence, products, operating<br>times|
|Load Transaction|source, product, planned/actual quantity, ticket/meter,<br>timestamps, evidence|
|Delivery Transaction|order, planned/actual quantity, meter, POD, timestamps,<br>variance/outcome|
|Vehicle Quantity Ledger|vehicle, transaction type, quantity in/out, running balance,<br>reference|
|GPS Point|driver/vehicle, latitude, longitude, accuracy, speed/heading if<br>available, timestamp|
|Journey Event|event type, task/trip, GPS, start/end, reason, user/source|
|Inspection|checklist, result, defects, photos, vehicle, driver, time/location|
|Incident|category, severity, details, GPS, task, vehicle, resolution and<br>downtime|
|Attachment / POD|file, type, order/task, captured by, time, GPS|
|Notification|type, recipient, sent/read time, status|
|Audit Log|entity, action, old/new values, user/device, time, IP/device<br>metadata where applicable|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

## **22. Screen Inventory** 

|**Platform**|**Screen / Page**|
|---|---|
|Back Office|Login / MFA; Executive Dashboard; Operations Control Tower;<br>Live Fleet Map; Sales Order List/Create/Edit/View; Dispatch<br>Planning Board; Trip/Run Detail; Driver List/Profile/Calendar;<br>Vehicle List/Profile/Calendar; Customer/Site Master; Loading<br>Point Master; Product Master; Inspection/Defect Board;<br>Incident/Breakdown Board; Quantity Reconciliation; POD Viewer;<br>Reports; Notifications; User/Roles; Configuration; Audit Log.|
|Driver App|Login; Vehicle Confirmation; Start Day; Pre-Trip Inspection;<br>Today Dashboard; Task List; Task Detail; Navigation; Arrived;<br>Loading Form; Unloading Form; POD Capture;<br>Break/Lunch/Waiting; Breakdown/Incident; Photo/Document<br>Capture; Messages/Notifications; Day Summary; End Day/Post-<br>Trip Inspection.|



## **23. Business Rules & Controls** 

- Unique order, trip, task and transaction numbers. 

- Mandatory audit trail for create/edit/assign/reassign/cancel/override/quantity adjustment. 

- No delivery completion without actual quantity and POD fields defined by company policy. 

- No load/delivery quantity exceeding configured capacity/balance without supervisor override. 

- Quantity tolerance percentage/absolute IG configurable by transaction type. 

- Cannot assign vehicle marked maintenance/out-of-service/breakdown or with a critical open inspection defect. 

- Cannot assign driver marked off duty/suspended or with expired mandatory credential unless authorized override is permitted. 

- Critical fields locked after trip closure; amendment uses controlled revision/approval rather than silent editing. 

- GPS and mobile event timestamps stored server-side where possible to reduce manipulation. 

- Offline events retain original device capture time and upload/synchronization time. 

- All photos/POD should store source task/order, capture time and coordinates where permitted. 

- Back office manual status changes require reason code and audit entry. 

## **24. Offline & Mobile Reliability** 

- Driver must be able to view already-synchronized daily jobs when mobile data is temporarily unavailable. 

- Critical actions such as arrival, load, unload, POD and breaks should queue locally and synchronize when connectivity returns. 

- App must prevent duplicate transaction creation after retry/synchronization. 

- GPS tracking should resume automatically after connectivity/GPS recovery and clearly flag gaps. 

- Photos/documents may upload in background after the core transaction is saved if bandwidth is poor. 

- Driver should see clear indicators for Pending Sync, Synced and Sync Failed. 

## **25. Integration Requirements** 

|**Integration**|**Purpose**|
|---|---|
|Google Maps Platform / Equivalent|Map display, geocoding, directions, route, distance and ETA.|
|Push Notifications|Firebase/APNs or equivalent for driver notifications.|
|ERP / Accounting System|Customer/order import, invoice-ready completed quantity, billing<br>references and status synchronization.|
|Telematics / GPS Provider (Optional)|Use vehicle-installed tracker data instead of or alongside mobile|



Diesel Delivery & Fleet Management System - Functional Requirements Specification 

|**Integration**|**Purpose**|
|---|---|
||GPS; speed, odometer, ignition and trip data.|
|Fuel Meter / IoT (Optional)|Automatically import loading/unloading meter values to reduce<br>manual entry.|
|SMS / Email|Customer/dispatcher alerts and POD delivery.|
|Document Storage|Secure storage for tickets, POD, photos, inspection and incident<br>evidence.|
|Identity / SSO (Optional)|Corporate authentication for office users.|



## **26. Security, Audit & Governance** 

- Role-based access control with least-privilege permissions. 

- MFA recommended for back-office administrative and supervisor accounts. 

- Encrypted network communication and encrypted sensitive data at rest. 

- Device/session control for driver logins and forced logout/disable for lost devices. 

- Complete audit log of user actions and changes to operational/quantity records. 

- Data retention rules for GPS, POD, photos and audit history configurable according to company/legal requirements. 

- Location access must be used only for operational purposes, with documented employee privacy policy and dutytracking rules. 

- Regular backups, disaster recovery and health monitoring of mobile/API/GPS services. 

## **27. Performance & Non-Functional Requirements** 

|**Area**|**Requirement**|
|---|---|
|Scale|Designed for at least 100+ orders/day initially with architecture<br>capable of substantially higher volumes and concurrent fleets.|
|Back Office Responsiveness|Operational screens should load/filter quickly; live map updates<br>without full page refresh.|
|Mobile UX|Core task actions should require minimal taps and support large<br>touch targets.|
|Availability|Business-critical cloud deployment with monitoring and backup;<br>target SLA to be agreed.|
|Synchronization|Near-real-time status and location updates subject to<br>connectivity.|
|Traceability|Every operational event linked to driver, vehicle, trip/task, order,<br>GPS and timestamp where applicable.|
|Exports|Excel/PDF/CSV exports for operational and finance reports as<br>required.|
|Localization|Support configurable timezone, date formats and potentially<br>English/Arabic UI if required.|



## **28. Suggested Phase 1 (MVP)** 

- Customer, site, product, driver, vehicle and loading-point masters. 

- Sales Order creation/import and status management. 

Diesel Delivery & Fleet Management System - Functional Requirements Specification 

- Dispatch assignment of driver + vehicle + loading point + delivery sequence. 

- Driver app: start/end day, task list, navigation, loading, unloading, POD, break/lunch, breakdown and inspection. 

- Live GPS tracking/map and basic ETA. 

- Quantity on vehicle reconciliation. 

- Notifications and critical delay/breakdown alerts. 

- Daily operations, driver activity, delivery, loading and quantity reports. 

- Role security and audit log. 

## **29. Suggested Phase 2 Enhancements** 

- Automated route optimization and dynamic dispatch/resequencing. 

- Customer live ETA/tracking link and customer portal. 

- Telematics integration, ignition/odometer/speed data and advanced driver behaviour. 

- Fuel meter/IoT integration for automatic quantities. 

- Advanced compartment/tanker inventory management. 

- Predictive ETA and loading/customer service-time analytics. 

- Maintenance planning, workshop module and tyre/service records. 

- Automated invoicing/ERP/e-invoicing integration after successful POD. 

- Advanced management BI and profitability by customer/order/route/vehicle. 

## **30. Example Driver Daily Timeline** 

|**Time**|**Event**|**System Capture**|
|---|---|---|
|06:50|Driver logs in / confirms tanker|Login, driver, vehicle, GPS.|
|07:00|Pre-trip inspection / Start Day|Checklist, defects, GPS, duty start.|
|07:05|Journey to Depot A|Route, distance, ETA, GPS trail.|
|07:35|Arrive Depot A|Geofence arrival, waiting time.|
|07:45-08:05|Load 4,000 IG|Loading times, ticket/meter, actual IG,<br>photo.|
|08:10|Depart to Customer 1|On-board 4,000 IG, GPS/ETA.|
|08:50-09:10|Unload 1,500 IG|POD, delivered IG, on-board balance<br>2,500 IG.|
|09:15-10:00|Customer 2 travel/delivery|Route and second delivery transaction.|
|10:05-10:20|Break|Break start/end, GPS, duration.|
|10:20 onward|Continue delivery / reload cycle|All subsequent tasks and balances.|
|17:30|Post-trip / End Day|Closing quantity, distance, time analysis,<br>open exceptions.|



## **31. Acceptance Criteria - Core System** 

- Back office can create a Sales Order and assign it to an available driver and vehicle. 

- Driver receives the job and can execute the complete load-to-delivery workflow from the phone. 

- Operations can see active drivers/vehicles and their latest location on a common live map. 

- Every task records planned and actual timestamps, quantities, GPS and responsible user. 

- System accurately maintains vehicle on-board diesel balance through multiple loads and deliveries. 

- Driver can record breaks, lunch, waiting, inspection, breakdown and incidents with exact duration and location. 

- Back office can reconstruct the complete day of any driver/vehicle using the journey timeline and map history. Diesel Delivery & Fleet Management System - Functional Requirements Specification 

- Completed delivery includes POD and is available for reporting/invoicing integration. 

- Exceptions and manual changes are auditable and cannot silently alter historical records. 

- Daily reports clearly reconcile planned vs actual order, timing and quantity performance. 

## **32. Key Decisions to Finalize Before Development** 

|**Decision**|**Why It Matters**|
|---|---|
|Is one Sales Order always one customer delivery?|Defines order/task model and partial/multi-drop behavior.|
|Can one tanker load serve multiple Sales Orders?|Determines vehicle balance and route/run design.|
|Does the tanker have compartments?|May require quantity tracking per compartment rather than only<br>total tanker balance.|
|What proves actual quantity - manual entry, meter, supplier<br>ticket, IoT?|Determines integration and fraud/error controls.|
|Required GPS tracking interval and whether tracking is allowed<br>only during duty|Affects battery/data, privacy and route accuracy.|
|Which ERP/accounting system is used?|Defines customer/order/invoice integration.|
|Is customer signature compulsory? OTP? Photo?|Defines POD workflow.|
|What quantity variance tolerance is acceptable?|Defines approvals and alerts.|
|Does dispatch need automatic route optimization in Phase 1?|Material effect on scope/cost.|
|Will drivers use company phones or personal devices?|Affects device management, permissions and support.|



## **33. Recommended Architecture (High Level)** 

A practical implementation is a cloud-hosted API and central relational database serving a responsive back-office web application and a native/cross-platform mobile application. A location service receives mobile or telematics GPS points and publishes live updates to the operations dashboard. Object storage retains POD images/tickets. A notification service sends assignment and exception alerts. Integration APIs exchange master/order/completion data with ERP/accounting systems. 

For operational integrity, order/quantity records, journey events and audit logs should be centrally stored with immutable historical references. GPS tracking and mobile synchronization should be designed as event-driven services so fleet tracking does not slow down normal order processing. 

## **34. Final Scope Statement** 

The target application is not only a delivery app. It is an integrated Diesel Dispatch, Fleet Execution, Quantity Reconciliation and Driver Tracking platform. Its key value is the ability to answer, at any time: What orders are pending? Which driver and tanker is assigned? Where are they now? What was loaded? What has been delivered? What remains on the vehicle? Why is a task delayed? What stops or incidents occurred? And what is the complete verifiable record of that driver/vehicle for the day? 

Diesel Delivery & Fleet Management System - Functional Requirements Specification 

