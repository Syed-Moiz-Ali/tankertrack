// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Customer {

@JsonKey(name: 'customer_id') String get id; String get code;@JsonKey(name: 'name_en') String get nameEn;@JsonKey(name: 'name_ar') String get nameAr; String get contact; String get phone; String get status;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,nameEn,nameAr,contact,phone,status);

@override
String toString() {
  return 'Customer(id: $id, code: $code, nameEn: $nameEn, nameAr: $nameAr, contact: $contact, phone: $phone, status: $status)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'customer_id') String id, String code,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, String contact, String phone, String status
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? nameEn = null,Object? nameAr = null,Object? contact = null,Object? phone = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String id,  String code, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String contact,  String phone,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.code,_that.nameEn,_that.nameAr,_that.contact,_that.phone,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String id,  String code, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String contact,  String phone,  String status)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.code,_that.nameEn,_that.nameAr,_that.contact,_that.phone,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'customer_id')  String id,  String code, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String contact,  String phone,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.code,_that.nameEn,_that.nameAr,_that.contact,_that.phone,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer extends Customer {
  const _Customer({@JsonKey(name: 'customer_id') required this.id, required this.code, @JsonKey(name: 'name_en') required this.nameEn, @JsonKey(name: 'name_ar') required this.nameAr, required this.contact, required this.phone, required this.status}): super._();
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override@JsonKey(name: 'customer_id') final  String id;
@override final  String code;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override final  String contact;
@override final  String phone;
@override final  String status;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,nameEn,nameAr,contact,phone,status);

@override
String toString() {
  return 'Customer(id: $id, code: $code, nameEn: $nameEn, nameAr: $nameAr, contact: $contact, phone: $phone, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'customer_id') String id, String code,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, String contact, String phone, String status
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? nameEn = null,Object? nameAr = null,Object? contact = null,Object? phone = null,Object? status = null,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeliverySite {

@JsonKey(name: 'site_id') String get id;@JsonKey(name: 'customer_id') String get customerId;@JsonKey(name: 'name_en') String get nameEn;@JsonKey(name: 'name_ar') String get nameAr; double get lat; double get lng;@JsonKey(name: 'geofence_m') int get geofenceM;@JsonKey(name: 'gate_hours') String get gateHours;
/// Create a copy of DeliverySite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliverySiteCopyWith<DeliverySite> get copyWith => _$DeliverySiteCopyWithImpl<DeliverySite>(this as DeliverySite, _$identity);

  /// Serializes this DeliverySite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliverySite&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.geofenceM, geofenceM) || other.geofenceM == geofenceM)&&(identical(other.gateHours, gateHours) || other.gateHours == gateHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,nameEn,nameAr,lat,lng,geofenceM,gateHours);

@override
String toString() {
  return 'DeliverySite(id: $id, customerId: $customerId, nameEn: $nameEn, nameAr: $nameAr, lat: $lat, lng: $lng, geofenceM: $geofenceM, gateHours: $gateHours)';
}


}

/// @nodoc
abstract mixin class $DeliverySiteCopyWith<$Res>  {
  factory $DeliverySiteCopyWith(DeliverySite value, $Res Function(DeliverySite) _then) = _$DeliverySiteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'site_id') String id,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, double lat, double lng,@JsonKey(name: 'geofence_m') int geofenceM,@JsonKey(name: 'gate_hours') String gateHours
});




}
/// @nodoc
class _$DeliverySiteCopyWithImpl<$Res>
    implements $DeliverySiteCopyWith<$Res> {
  _$DeliverySiteCopyWithImpl(this._self, this._then);

  final DeliverySite _self;
  final $Res Function(DeliverySite) _then;

/// Create a copy of DeliverySite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? nameEn = null,Object? nameAr = null,Object? lat = null,Object? lng = null,Object? geofenceM = null,Object? gateHours = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,geofenceM: null == geofenceM ? _self.geofenceM : geofenceM // ignore: cast_nullable_to_non_nullable
as int,gateHours: null == gateHours ? _self.gateHours : gateHours // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliverySite].
extension DeliverySitePatterns on DeliverySite {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliverySite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliverySite() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliverySite value)  $default,){
final _that = this;
switch (_that) {
case _DeliverySite():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliverySite value)?  $default,){
final _that = this;
switch (_that) {
case _DeliverySite() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'site_id')  String id, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  double lat,  double lng, @JsonKey(name: 'geofence_m')  int geofenceM, @JsonKey(name: 'gate_hours')  String gateHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliverySite() when $default != null:
return $default(_that.id,_that.customerId,_that.nameEn,_that.nameAr,_that.lat,_that.lng,_that.geofenceM,_that.gateHours);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'site_id')  String id, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  double lat,  double lng, @JsonKey(name: 'geofence_m')  int geofenceM, @JsonKey(name: 'gate_hours')  String gateHours)  $default,) {final _that = this;
switch (_that) {
case _DeliverySite():
return $default(_that.id,_that.customerId,_that.nameEn,_that.nameAr,_that.lat,_that.lng,_that.geofenceM,_that.gateHours);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'site_id')  String id, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  double lat,  double lng, @JsonKey(name: 'geofence_m')  int geofenceM, @JsonKey(name: 'gate_hours')  String gateHours)?  $default,) {final _that = this;
switch (_that) {
case _DeliverySite() when $default != null:
return $default(_that.id,_that.customerId,_that.nameEn,_that.nameAr,_that.lat,_that.lng,_that.geofenceM,_that.gateHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliverySite extends DeliverySite {
  const _DeliverySite({@JsonKey(name: 'site_id') required this.id, @JsonKey(name: 'customer_id') required this.customerId, @JsonKey(name: 'name_en') required this.nameEn, @JsonKey(name: 'name_ar') required this.nameAr, required this.lat, required this.lng, @JsonKey(name: 'geofence_m') required this.geofenceM, @JsonKey(name: 'gate_hours') required this.gateHours}): super._();
  factory _DeliverySite.fromJson(Map<String, dynamic> json) => _$DeliverySiteFromJson(json);

@override@JsonKey(name: 'site_id') final  String id;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override final  double lat;
@override final  double lng;
@override@JsonKey(name: 'geofence_m') final  int geofenceM;
@override@JsonKey(name: 'gate_hours') final  String gateHours;

/// Create a copy of DeliverySite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliverySiteCopyWith<_DeliverySite> get copyWith => __$DeliverySiteCopyWithImpl<_DeliverySite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliverySiteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliverySite&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.geofenceM, geofenceM) || other.geofenceM == geofenceM)&&(identical(other.gateHours, gateHours) || other.gateHours == gateHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,nameEn,nameAr,lat,lng,geofenceM,gateHours);

@override
String toString() {
  return 'DeliverySite(id: $id, customerId: $customerId, nameEn: $nameEn, nameAr: $nameAr, lat: $lat, lng: $lng, geofenceM: $geofenceM, gateHours: $gateHours)';
}


}

/// @nodoc
abstract mixin class _$DeliverySiteCopyWith<$Res> implements $DeliverySiteCopyWith<$Res> {
  factory _$DeliverySiteCopyWith(_DeliverySite value, $Res Function(_DeliverySite) _then) = __$DeliverySiteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'site_id') String id,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, double lat, double lng,@JsonKey(name: 'geofence_m') int geofenceM,@JsonKey(name: 'gate_hours') String gateHours
});




}
/// @nodoc
class __$DeliverySiteCopyWithImpl<$Res>
    implements _$DeliverySiteCopyWith<$Res> {
  __$DeliverySiteCopyWithImpl(this._self, this._then);

  final _DeliverySite _self;
  final $Res Function(_DeliverySite) _then;

/// Create a copy of DeliverySite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? nameEn = null,Object? nameAr = null,Object? lat = null,Object? lng = null,Object? geofenceM = null,Object? gateHours = null,}) {
  return _then(_DeliverySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,geofenceM: null == geofenceM ? _self.geofenceM : geofenceM // ignore: cast_nullable_to_non_nullable
as int,gateHours: null == gateHours ? _self.gateHours : gateHours // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Depot {

@JsonKey(name: 'source_id') String get id;@JsonKey(name: 'name_en') String get nameEn;@JsonKey(name: 'name_ar') String get nameAr; double get lat; double get lng;@JsonKey(name: 'geofence_m') int get geofenceM; String get hours; List<String> get products;
/// Create a copy of Depot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepotCopyWith<Depot> get copyWith => _$DepotCopyWithImpl<Depot>(this as Depot, _$identity);

  /// Serializes this Depot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Depot&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.geofenceM, geofenceM) || other.geofenceM == geofenceM)&&(identical(other.hours, hours) || other.hours == hours)&&const DeepCollectionEquality().equals(other.products, products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameAr,lat,lng,geofenceM,hours,const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'Depot(id: $id, nameEn: $nameEn, nameAr: $nameAr, lat: $lat, lng: $lng, geofenceM: $geofenceM, hours: $hours, products: $products)';
}


}

/// @nodoc
abstract mixin class $DepotCopyWith<$Res>  {
  factory $DepotCopyWith(Depot value, $Res Function(Depot) _then) = _$DepotCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'source_id') String id,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, double lat, double lng,@JsonKey(name: 'geofence_m') int geofenceM, String hours, List<String> products
});




}
/// @nodoc
class _$DepotCopyWithImpl<$Res>
    implements $DepotCopyWith<$Res> {
  _$DepotCopyWithImpl(this._self, this._then);

  final Depot _self;
  final $Res Function(Depot) _then;

/// Create a copy of Depot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameEn = null,Object? nameAr = null,Object? lat = null,Object? lng = null,Object? geofenceM = null,Object? hours = null,Object? products = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,geofenceM: null == geofenceM ? _self.geofenceM : geofenceM // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Depot].
extension DepotPatterns on Depot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Depot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Depot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Depot value)  $default,){
final _that = this;
switch (_that) {
case _Depot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Depot value)?  $default,){
final _that = this;
switch (_that) {
case _Depot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  double lat,  double lng, @JsonKey(name: 'geofence_m')  int geofenceM,  String hours,  List<String> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Depot() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameAr,_that.lat,_that.lng,_that.geofenceM,_that.hours,_that.products);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  double lat,  double lng, @JsonKey(name: 'geofence_m')  int geofenceM,  String hours,  List<String> products)  $default,) {final _that = this;
switch (_that) {
case _Depot():
return $default(_that.id,_that.nameEn,_that.nameAr,_that.lat,_that.lng,_that.geofenceM,_that.hours,_that.products);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'source_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  double lat,  double lng, @JsonKey(name: 'geofence_m')  int geofenceM,  String hours,  List<String> products)?  $default,) {final _that = this;
switch (_that) {
case _Depot() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameAr,_that.lat,_that.lng,_that.geofenceM,_that.hours,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Depot extends Depot {
  const _Depot({@JsonKey(name: 'source_id') required this.id, @JsonKey(name: 'name_en') required this.nameEn, @JsonKey(name: 'name_ar') required this.nameAr, required this.lat, required this.lng, @JsonKey(name: 'geofence_m') required this.geofenceM, required this.hours, final  List<String> products = const <String>[]}): _products = products,super._();
  factory _Depot.fromJson(Map<String, dynamic> json) => _$DepotFromJson(json);

@override@JsonKey(name: 'source_id') final  String id;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override final  double lat;
@override final  double lng;
@override@JsonKey(name: 'geofence_m') final  int geofenceM;
@override final  String hours;
 final  List<String> _products;
@override@JsonKey() List<String> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of Depot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepotCopyWith<_Depot> get copyWith => __$DepotCopyWithImpl<_Depot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Depot&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.geofenceM, geofenceM) || other.geofenceM == geofenceM)&&(identical(other.hours, hours) || other.hours == hours)&&const DeepCollectionEquality().equals(other._products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameAr,lat,lng,geofenceM,hours,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'Depot(id: $id, nameEn: $nameEn, nameAr: $nameAr, lat: $lat, lng: $lng, geofenceM: $geofenceM, hours: $hours, products: $products)';
}


}

/// @nodoc
abstract mixin class _$DepotCopyWith<$Res> implements $DepotCopyWith<$Res> {
  factory _$DepotCopyWith(_Depot value, $Res Function(_Depot) _then) = __$DepotCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'source_id') String id,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, double lat, double lng,@JsonKey(name: 'geofence_m') int geofenceM, String hours, List<String> products
});




}
/// @nodoc
class __$DepotCopyWithImpl<$Res>
    implements _$DepotCopyWith<$Res> {
  __$DepotCopyWithImpl(this._self, this._then);

  final _Depot _self;
  final $Res Function(_Depot) _then;

/// Create a copy of Depot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameEn = null,Object? nameAr = null,Object? lat = null,Object? lng = null,Object? geofenceM = null,Object? hours = null,Object? products = null,}) {
  return _then(_Depot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,geofenceM: null == geofenceM ? _self.geofenceM : geofenceM // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$Product {

@JsonKey(name: 'product_id') String get id;@JsonKey(name: 'name_en') String get nameEn;@JsonKey(name: 'name_ar') String get nameAr; String get unit; bool get active;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameAr,unit,active);

@override
String toString() {
  return 'Product(id: $id, nameEn: $nameEn, nameAr: $nameAr, unit: $unit, active: $active)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String id,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, String unit, bool active
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameEn = null,Object? nameAr = null,Object? unit = null,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String unit,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameAr,_that.unit,_that.active);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String unit,  bool active)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.nameEn,_that.nameAr,_that.unit,_that.active);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String unit,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameAr,_that.unit,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({@JsonKey(name: 'product_id') required this.id, @JsonKey(name: 'name_en') required this.nameEn, @JsonKey(name: 'name_ar') required this.nameAr, required this.unit, required this.active}): super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override@JsonKey(name: 'product_id') final  String id;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override final  String unit;
@override final  bool active;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameAr,unit,active);

@override
String toString() {
  return 'Product(id: $id, nameEn: $nameEn, nameAr: $nameAr, unit: $unit, active: $active)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String id,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, String unit, bool active
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameEn = null,Object? nameAr = null,Object? unit = null,Object? active = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DriverInfo {

@JsonKey(name: 'driver_id') String get id;@JsonKey(name: 'name_en') String get nameEn;@JsonKey(name: 'name_ar') String get nameAr; String get phone; String get status;@JsonKey(name: 'licence_expiry_days') int get licenceExpiryDays;
/// Create a copy of DriverInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverInfoCopyWith<DriverInfo> get copyWith => _$DriverInfoCopyWithImpl<DriverInfo>(this as DriverInfo, _$identity);

  /// Serializes this DriverInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status)&&(identical(other.licenceExpiryDays, licenceExpiryDays) || other.licenceExpiryDays == licenceExpiryDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameAr,phone,status,licenceExpiryDays);

@override
String toString() {
  return 'DriverInfo(id: $id, nameEn: $nameEn, nameAr: $nameAr, phone: $phone, status: $status, licenceExpiryDays: $licenceExpiryDays)';
}


}

/// @nodoc
abstract mixin class $DriverInfoCopyWith<$Res>  {
  factory $DriverInfoCopyWith(DriverInfo value, $Res Function(DriverInfo) _then) = _$DriverInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'driver_id') String id,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, String phone, String status,@JsonKey(name: 'licence_expiry_days') int licenceExpiryDays
});




}
/// @nodoc
class _$DriverInfoCopyWithImpl<$Res>
    implements $DriverInfoCopyWith<$Res> {
  _$DriverInfoCopyWithImpl(this._self, this._then);

  final DriverInfo _self;
  final $Res Function(DriverInfo) _then;

/// Create a copy of DriverInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameEn = null,Object? nameAr = null,Object? phone = null,Object? status = null,Object? licenceExpiryDays = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,licenceExpiryDays: null == licenceExpiryDays ? _self.licenceExpiryDays : licenceExpiryDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverInfo].
extension DriverInfoPatterns on DriverInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverInfo value)  $default,){
final _that = this;
switch (_that) {
case _DriverInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DriverInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'driver_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String phone,  String status, @JsonKey(name: 'licence_expiry_days')  int licenceExpiryDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverInfo() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameAr,_that.phone,_that.status,_that.licenceExpiryDays);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'driver_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String phone,  String status, @JsonKey(name: 'licence_expiry_days')  int licenceExpiryDays)  $default,) {final _that = this;
switch (_that) {
case _DriverInfo():
return $default(_that.id,_that.nameEn,_that.nameAr,_that.phone,_that.status,_that.licenceExpiryDays);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'driver_id')  String id, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'name_ar')  String nameAr,  String phone,  String status, @JsonKey(name: 'licence_expiry_days')  int licenceExpiryDays)?  $default,) {final _that = this;
switch (_that) {
case _DriverInfo() when $default != null:
return $default(_that.id,_that.nameEn,_that.nameAr,_that.phone,_that.status,_that.licenceExpiryDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverInfo extends DriverInfo {
  const _DriverInfo({@JsonKey(name: 'driver_id') required this.id, @JsonKey(name: 'name_en') required this.nameEn, @JsonKey(name: 'name_ar') required this.nameAr, required this.phone, required this.status, @JsonKey(name: 'licence_expiry_days') required this.licenceExpiryDays}): super._();
  factory _DriverInfo.fromJson(Map<String, dynamic> json) => _$DriverInfoFromJson(json);

@override@JsonKey(name: 'driver_id') final  String id;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override final  String phone;
@override final  String status;
@override@JsonKey(name: 'licence_expiry_days') final  int licenceExpiryDays;

/// Create a copy of DriverInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverInfoCopyWith<_DriverInfo> get copyWith => __$DriverInfoCopyWithImpl<_DriverInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status)&&(identical(other.licenceExpiryDays, licenceExpiryDays) || other.licenceExpiryDays == licenceExpiryDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameEn,nameAr,phone,status,licenceExpiryDays);

@override
String toString() {
  return 'DriverInfo(id: $id, nameEn: $nameEn, nameAr: $nameAr, phone: $phone, status: $status, licenceExpiryDays: $licenceExpiryDays)';
}


}

/// @nodoc
abstract mixin class _$DriverInfoCopyWith<$Res> implements $DriverInfoCopyWith<$Res> {
  factory _$DriverInfoCopyWith(_DriverInfo value, $Res Function(_DriverInfo) _then) = __$DriverInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'driver_id') String id,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'name_ar') String nameAr, String phone, String status,@JsonKey(name: 'licence_expiry_days') int licenceExpiryDays
});




}
/// @nodoc
class __$DriverInfoCopyWithImpl<$Res>
    implements _$DriverInfoCopyWith<$Res> {
  __$DriverInfoCopyWithImpl(this._self, this._then);

  final _DriverInfo _self;
  final $Res Function(_DriverInfo) _then;

/// Create a copy of DriverInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameEn = null,Object? nameAr = null,Object? phone = null,Object? status = null,Object? licenceExpiryDays = null,}) {
  return _then(_DriverInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,licenceExpiryDays: null == licenceExpiryDays ? _self.licenceExpiryDays : licenceExpiryDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VehicleInfo {

@JsonKey(name: 'vehicle_id') String get id; String get registration;@JsonKey(name: 'capacity_tenths') int get capacityTenths;@JsonKey(name: 'on_board_tenths') int get onBoardTenths; String get status;@JsonKey(name: 'doc_expiry_days') int get docExpiryDays;@JsonKey(name: 'critical_defect') bool get criticalDefect; List<String> get compartments;
/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<VehicleInfo> get copyWith => _$VehicleInfoCopyWithImpl<VehicleInfo>(this as VehicleInfo, _$identity);

  /// Serializes this VehicleInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.capacityTenths, capacityTenths) || other.capacityTenths == capacityTenths)&&(identical(other.onBoardTenths, onBoardTenths) || other.onBoardTenths == onBoardTenths)&&(identical(other.status, status) || other.status == status)&&(identical(other.docExpiryDays, docExpiryDays) || other.docExpiryDays == docExpiryDays)&&(identical(other.criticalDefect, criticalDefect) || other.criticalDefect == criticalDefect)&&const DeepCollectionEquality().equals(other.compartments, compartments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,registration,capacityTenths,onBoardTenths,status,docExpiryDays,criticalDefect,const DeepCollectionEquality().hash(compartments));

@override
String toString() {
  return 'VehicleInfo(id: $id, registration: $registration, capacityTenths: $capacityTenths, onBoardTenths: $onBoardTenths, status: $status, docExpiryDays: $docExpiryDays, criticalDefect: $criticalDefect, compartments: $compartments)';
}


}

/// @nodoc
abstract mixin class $VehicleInfoCopyWith<$Res>  {
  factory $VehicleInfoCopyWith(VehicleInfo value, $Res Function(VehicleInfo) _then) = _$VehicleInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'vehicle_id') String id, String registration,@JsonKey(name: 'capacity_tenths') int capacityTenths,@JsonKey(name: 'on_board_tenths') int onBoardTenths, String status,@JsonKey(name: 'doc_expiry_days') int docExpiryDays,@JsonKey(name: 'critical_defect') bool criticalDefect, List<String> compartments
});




}
/// @nodoc
class _$VehicleInfoCopyWithImpl<$Res>
    implements $VehicleInfoCopyWith<$Res> {
  _$VehicleInfoCopyWithImpl(this._self, this._then);

  final VehicleInfo _self;
  final $Res Function(VehicleInfo) _then;

/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? registration = null,Object? capacityTenths = null,Object? onBoardTenths = null,Object? status = null,Object? docExpiryDays = null,Object? criticalDefect = null,Object? compartments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,capacityTenths: null == capacityTenths ? _self.capacityTenths : capacityTenths // ignore: cast_nullable_to_non_nullable
as int,onBoardTenths: null == onBoardTenths ? _self.onBoardTenths : onBoardTenths // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,docExpiryDays: null == docExpiryDays ? _self.docExpiryDays : docExpiryDays // ignore: cast_nullable_to_non_nullable
as int,criticalDefect: null == criticalDefect ? _self.criticalDefect : criticalDefect // ignore: cast_nullable_to_non_nullable
as bool,compartments: null == compartments ? _self.compartments : compartments // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleInfo].
extension VehicleInfoPatterns on VehicleInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleInfo value)  $default,){
final _that = this;
switch (_that) {
case _VehicleInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleInfo value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'vehicle_id')  String id,  String registration, @JsonKey(name: 'capacity_tenths')  int capacityTenths, @JsonKey(name: 'on_board_tenths')  int onBoardTenths,  String status, @JsonKey(name: 'doc_expiry_days')  int docExpiryDays, @JsonKey(name: 'critical_defect')  bool criticalDefect,  List<String> compartments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
return $default(_that.id,_that.registration,_that.capacityTenths,_that.onBoardTenths,_that.status,_that.docExpiryDays,_that.criticalDefect,_that.compartments);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'vehicle_id')  String id,  String registration, @JsonKey(name: 'capacity_tenths')  int capacityTenths, @JsonKey(name: 'on_board_tenths')  int onBoardTenths,  String status, @JsonKey(name: 'doc_expiry_days')  int docExpiryDays, @JsonKey(name: 'critical_defect')  bool criticalDefect,  List<String> compartments)  $default,) {final _that = this;
switch (_that) {
case _VehicleInfo():
return $default(_that.id,_that.registration,_that.capacityTenths,_that.onBoardTenths,_that.status,_that.docExpiryDays,_that.criticalDefect,_that.compartments);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'vehicle_id')  String id,  String registration, @JsonKey(name: 'capacity_tenths')  int capacityTenths, @JsonKey(name: 'on_board_tenths')  int onBoardTenths,  String status, @JsonKey(name: 'doc_expiry_days')  int docExpiryDays, @JsonKey(name: 'critical_defect')  bool criticalDefect,  List<String> compartments)?  $default,) {final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
return $default(_that.id,_that.registration,_that.capacityTenths,_that.onBoardTenths,_that.status,_that.docExpiryDays,_that.criticalDefect,_that.compartments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleInfo extends VehicleInfo {
  const _VehicleInfo({@JsonKey(name: 'vehicle_id') required this.id, required this.registration, @JsonKey(name: 'capacity_tenths') required this.capacityTenths, @JsonKey(name: 'on_board_tenths') required this.onBoardTenths, required this.status, @JsonKey(name: 'doc_expiry_days') required this.docExpiryDays, @JsonKey(name: 'critical_defect') required this.criticalDefect, final  List<String> compartments = const <String>[]}): _compartments = compartments,super._();
  factory _VehicleInfo.fromJson(Map<String, dynamic> json) => _$VehicleInfoFromJson(json);

@override@JsonKey(name: 'vehicle_id') final  String id;
@override final  String registration;
@override@JsonKey(name: 'capacity_tenths') final  int capacityTenths;
@override@JsonKey(name: 'on_board_tenths') final  int onBoardTenths;
@override final  String status;
@override@JsonKey(name: 'doc_expiry_days') final  int docExpiryDays;
@override@JsonKey(name: 'critical_defect') final  bool criticalDefect;
 final  List<String> _compartments;
@override@JsonKey() List<String> get compartments {
  if (_compartments is EqualUnmodifiableListView) return _compartments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_compartments);
}


/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleInfoCopyWith<_VehicleInfo> get copyWith => __$VehicleInfoCopyWithImpl<_VehicleInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.capacityTenths, capacityTenths) || other.capacityTenths == capacityTenths)&&(identical(other.onBoardTenths, onBoardTenths) || other.onBoardTenths == onBoardTenths)&&(identical(other.status, status) || other.status == status)&&(identical(other.docExpiryDays, docExpiryDays) || other.docExpiryDays == docExpiryDays)&&(identical(other.criticalDefect, criticalDefect) || other.criticalDefect == criticalDefect)&&const DeepCollectionEquality().equals(other._compartments, _compartments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,registration,capacityTenths,onBoardTenths,status,docExpiryDays,criticalDefect,const DeepCollectionEquality().hash(_compartments));

@override
String toString() {
  return 'VehicleInfo(id: $id, registration: $registration, capacityTenths: $capacityTenths, onBoardTenths: $onBoardTenths, status: $status, docExpiryDays: $docExpiryDays, criticalDefect: $criticalDefect, compartments: $compartments)';
}


}

/// @nodoc
abstract mixin class _$VehicleInfoCopyWith<$Res> implements $VehicleInfoCopyWith<$Res> {
  factory _$VehicleInfoCopyWith(_VehicleInfo value, $Res Function(_VehicleInfo) _then) = __$VehicleInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'vehicle_id') String id, String registration,@JsonKey(name: 'capacity_tenths') int capacityTenths,@JsonKey(name: 'on_board_tenths') int onBoardTenths, String status,@JsonKey(name: 'doc_expiry_days') int docExpiryDays,@JsonKey(name: 'critical_defect') bool criticalDefect, List<String> compartments
});




}
/// @nodoc
class __$VehicleInfoCopyWithImpl<$Res>
    implements _$VehicleInfoCopyWith<$Res> {
  __$VehicleInfoCopyWithImpl(this._self, this._then);

  final _VehicleInfo _self;
  final $Res Function(_VehicleInfo) _then;

/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? registration = null,Object? capacityTenths = null,Object? onBoardTenths = null,Object? status = null,Object? docExpiryDays = null,Object? criticalDefect = null,Object? compartments = null,}) {
  return _then(_VehicleInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,capacityTenths: null == capacityTenths ? _self.capacityTenths : capacityTenths // ignore: cast_nullable_to_non_nullable
as int,onBoardTenths: null == onBoardTenths ? _self.onBoardTenths : onBoardTenths // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,docExpiryDays: null == docExpiryDays ? _self.docExpiryDays : docExpiryDays // ignore: cast_nullable_to_non_nullable
as int,criticalDefect: null == criticalDefect ? _self.criticalDefect : criticalDefect // ignore: cast_nullable_to_non_nullable
as bool,compartments: null == compartments ? _self._compartments : compartments // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$OrderSummary {

@JsonKey(name: 'order_id') String get id;@JsonKey(name: 'site_id') String get siteId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'qty_tenths') int get qtyTenths; String get priority; String get window; String get status;@JsonKey(name: 'has_variance') bool get hasVariance;@JsonKey(name: 'po_ref') String? get poRef;
/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSummaryCopyWith<OrderSummary> get copyWith => _$OrderSummaryCopyWithImpl<OrderSummary>(this as OrderSummary, _$identity);

  /// Serializes this OrderSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.qtyTenths, qtyTenths) || other.qtyTenths == qtyTenths)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.window, window) || other.window == window)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasVariance, hasVariance) || other.hasVariance == hasVariance)&&(identical(other.poRef, poRef) || other.poRef == poRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,siteId,productId,qtyTenths,priority,window,status,hasVariance,poRef);

@override
String toString() {
  return 'OrderSummary(id: $id, siteId: $siteId, productId: $productId, qtyTenths: $qtyTenths, priority: $priority, window: $window, status: $status, hasVariance: $hasVariance, poRef: $poRef)';
}


}

/// @nodoc
abstract mixin class $OrderSummaryCopyWith<$Res>  {
  factory $OrderSummaryCopyWith(OrderSummary value, $Res Function(OrderSummary) _then) = _$OrderSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id') String id,@JsonKey(name: 'site_id') String siteId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'qty_tenths') int qtyTenths, String priority, String window, String status,@JsonKey(name: 'has_variance') bool hasVariance,@JsonKey(name: 'po_ref') String? poRef
});




}
/// @nodoc
class _$OrderSummaryCopyWithImpl<$Res>
    implements $OrderSummaryCopyWith<$Res> {
  _$OrderSummaryCopyWithImpl(this._self, this._then);

  final OrderSummary _self;
  final $Res Function(OrderSummary) _then;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? siteId = null,Object? productId = null,Object? qtyTenths = null,Object? priority = null,Object? window = null,Object? status = null,Object? hasVariance = null,Object? poRef = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,siteId: null == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,qtyTenths: null == qtyTenths ? _self.qtyTenths : qtyTenths // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,hasVariance: null == hasVariance ? _self.hasVariance : hasVariance // ignore: cast_nullable_to_non_nullable
as bool,poRef: freezed == poRef ? _self.poRef : poRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderSummary].
extension OrderSummaryPatterns on OrderSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSummary value)  $default,){
final _that = this;
switch (_that) {
case _OrderSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSummary value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String id, @JsonKey(name: 'site_id')  String siteId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'qty_tenths')  int qtyTenths,  String priority,  String window,  String status, @JsonKey(name: 'has_variance')  bool hasVariance, @JsonKey(name: 'po_ref')  String? poRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that.id,_that.siteId,_that.productId,_that.qtyTenths,_that.priority,_that.window,_that.status,_that.hasVariance,_that.poRef);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String id, @JsonKey(name: 'site_id')  String siteId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'qty_tenths')  int qtyTenths,  String priority,  String window,  String status, @JsonKey(name: 'has_variance')  bool hasVariance, @JsonKey(name: 'po_ref')  String? poRef)  $default,) {final _that = this;
switch (_that) {
case _OrderSummary():
return $default(_that.id,_that.siteId,_that.productId,_that.qtyTenths,_that.priority,_that.window,_that.status,_that.hasVariance,_that.poRef);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'order_id')  String id, @JsonKey(name: 'site_id')  String siteId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'qty_tenths')  int qtyTenths,  String priority,  String window,  String status, @JsonKey(name: 'has_variance')  bool hasVariance, @JsonKey(name: 'po_ref')  String? poRef)?  $default,) {final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that.id,_that.siteId,_that.productId,_that.qtyTenths,_that.priority,_that.window,_that.status,_that.hasVariance,_that.poRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSummary extends OrderSummary {
  const _OrderSummary({@JsonKey(name: 'order_id') required this.id, @JsonKey(name: 'site_id') required this.siteId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'qty_tenths') required this.qtyTenths, required this.priority, required this.window, required this.status, @JsonKey(name: 'has_variance') required this.hasVariance, @JsonKey(name: 'po_ref') this.poRef}): super._();
  factory _OrderSummary.fromJson(Map<String, dynamic> json) => _$OrderSummaryFromJson(json);

@override@JsonKey(name: 'order_id') final  String id;
@override@JsonKey(name: 'site_id') final  String siteId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'qty_tenths') final  int qtyTenths;
@override final  String priority;
@override final  String window;
@override final  String status;
@override@JsonKey(name: 'has_variance') final  bool hasVariance;
@override@JsonKey(name: 'po_ref') final  String? poRef;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryCopyWith<_OrderSummary> get copyWith => __$OrderSummaryCopyWithImpl<_OrderSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.qtyTenths, qtyTenths) || other.qtyTenths == qtyTenths)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.window, window) || other.window == window)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasVariance, hasVariance) || other.hasVariance == hasVariance)&&(identical(other.poRef, poRef) || other.poRef == poRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,siteId,productId,qtyTenths,priority,window,status,hasVariance,poRef);

@override
String toString() {
  return 'OrderSummary(id: $id, siteId: $siteId, productId: $productId, qtyTenths: $qtyTenths, priority: $priority, window: $window, status: $status, hasVariance: $hasVariance, poRef: $poRef)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryCopyWith<$Res> implements $OrderSummaryCopyWith<$Res> {
  factory _$OrderSummaryCopyWith(_OrderSummary value, $Res Function(_OrderSummary) _then) = __$OrderSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'order_id') String id,@JsonKey(name: 'site_id') String siteId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'qty_tenths') int qtyTenths, String priority, String window, String status,@JsonKey(name: 'has_variance') bool hasVariance,@JsonKey(name: 'po_ref') String? poRef
});




}
/// @nodoc
class __$OrderSummaryCopyWithImpl<$Res>
    implements _$OrderSummaryCopyWith<$Res> {
  __$OrderSummaryCopyWithImpl(this._self, this._then);

  final _OrderSummary _self;
  final $Res Function(_OrderSummary) _then;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? siteId = null,Object? productId = null,Object? qtyTenths = null,Object? priority = null,Object? window = null,Object? status = null,Object? hasVariance = null,Object? poRef = freezed,}) {
  return _then(_OrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,siteId: null == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,qtyTenths: null == qtyTenths ? _self.qtyTenths : qtyTenths // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,hasVariance: null == hasVariance ? _self.hasVariance : hasVariance // ignore: cast_nullable_to_non_nullable
as bool,poRef: freezed == poRef ? _self.poRef : poRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AlertItem {

@JsonKey(readValue: _alertReadId) String get id;@JsonKey(readValue: _alertReadType) String get type;@JsonKey(readValue: _alertReadSeverity) String get severity;@JsonKey(readValue: _alertReadTitleEn) String get titleEn;@JsonKey(readValue: _alertReadTitleAr) String get titleAr;@JsonKey(readValue: _alertReadAt) String get atIdentifier;
/// Create a copy of AlertItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertItemCopyWith<AlertItem> get copyWith => _$AlertItemCopyWithImpl<AlertItem>(this as AlertItem, _$identity);

  /// Serializes this AlertItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleAr, titleAr) || other.titleAr == titleAr)&&(identical(other.atIdentifier, atIdentifier) || other.atIdentifier == atIdentifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,severity,titleEn,titleAr,atIdentifier);

@override
String toString() {
  return 'AlertItem(id: $id, type: $type, severity: $severity, titleEn: $titleEn, titleAr: $titleAr, atIdentifier: $atIdentifier)';
}


}

/// @nodoc
abstract mixin class $AlertItemCopyWith<$Res>  {
  factory $AlertItemCopyWith(AlertItem value, $Res Function(AlertItem) _then) = _$AlertItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _alertReadId) String id,@JsonKey(readValue: _alertReadType) String type,@JsonKey(readValue: _alertReadSeverity) String severity,@JsonKey(readValue: _alertReadTitleEn) String titleEn,@JsonKey(readValue: _alertReadTitleAr) String titleAr,@JsonKey(readValue: _alertReadAt) String atIdentifier
});




}
/// @nodoc
class _$AlertItemCopyWithImpl<$Res>
    implements $AlertItemCopyWith<$Res> {
  _$AlertItemCopyWithImpl(this._self, this._then);

  final AlertItem _self;
  final $Res Function(AlertItem) _then;

/// Create a copy of AlertItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? severity = null,Object? titleEn = null,Object? titleAr = null,Object? atIdentifier = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,atIdentifier: null == atIdentifier ? _self.atIdentifier : atIdentifier // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertItem].
extension AlertItemPatterns on AlertItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertItem value)  $default,){
final _that = this;
switch (_that) {
case _AlertItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertItem value)?  $default,){
final _that = this;
switch (_that) {
case _AlertItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _alertReadId)  String id, @JsonKey(readValue: _alertReadType)  String type, @JsonKey(readValue: _alertReadSeverity)  String severity, @JsonKey(readValue: _alertReadTitleEn)  String titleEn, @JsonKey(readValue: _alertReadTitleAr)  String titleAr, @JsonKey(readValue: _alertReadAt)  String atIdentifier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertItem() when $default != null:
return $default(_that.id,_that.type,_that.severity,_that.titleEn,_that.titleAr,_that.atIdentifier);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _alertReadId)  String id, @JsonKey(readValue: _alertReadType)  String type, @JsonKey(readValue: _alertReadSeverity)  String severity, @JsonKey(readValue: _alertReadTitleEn)  String titleEn, @JsonKey(readValue: _alertReadTitleAr)  String titleAr, @JsonKey(readValue: _alertReadAt)  String atIdentifier)  $default,) {final _that = this;
switch (_that) {
case _AlertItem():
return $default(_that.id,_that.type,_that.severity,_that.titleEn,_that.titleAr,_that.atIdentifier);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _alertReadId)  String id, @JsonKey(readValue: _alertReadType)  String type, @JsonKey(readValue: _alertReadSeverity)  String severity, @JsonKey(readValue: _alertReadTitleEn)  String titleEn, @JsonKey(readValue: _alertReadTitleAr)  String titleAr, @JsonKey(readValue: _alertReadAt)  String atIdentifier)?  $default,) {final _that = this;
switch (_that) {
case _AlertItem() when $default != null:
return $default(_that.id,_that.type,_that.severity,_that.titleEn,_that.titleAr,_that.atIdentifier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertItem extends AlertItem {
  const _AlertItem({@JsonKey(readValue: _alertReadId) required this.id, @JsonKey(readValue: _alertReadType) required this.type, @JsonKey(readValue: _alertReadSeverity) required this.severity, @JsonKey(readValue: _alertReadTitleEn) required this.titleEn, @JsonKey(readValue: _alertReadTitleAr) required this.titleAr, @JsonKey(readValue: _alertReadAt) required this.atIdentifier}): super._();
  factory _AlertItem.fromJson(Map<String, dynamic> json) => _$AlertItemFromJson(json);

@override@JsonKey(readValue: _alertReadId) final  String id;
@override@JsonKey(readValue: _alertReadType) final  String type;
@override@JsonKey(readValue: _alertReadSeverity) final  String severity;
@override@JsonKey(readValue: _alertReadTitleEn) final  String titleEn;
@override@JsonKey(readValue: _alertReadTitleAr) final  String titleAr;
@override@JsonKey(readValue: _alertReadAt) final  String atIdentifier;

/// Create a copy of AlertItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertItemCopyWith<_AlertItem> get copyWith => __$AlertItemCopyWithImpl<_AlertItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleAr, titleAr) || other.titleAr == titleAr)&&(identical(other.atIdentifier, atIdentifier) || other.atIdentifier == atIdentifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,severity,titleEn,titleAr,atIdentifier);

@override
String toString() {
  return 'AlertItem(id: $id, type: $type, severity: $severity, titleEn: $titleEn, titleAr: $titleAr, atIdentifier: $atIdentifier)';
}


}

/// @nodoc
abstract mixin class _$AlertItemCopyWith<$Res> implements $AlertItemCopyWith<$Res> {
  factory _$AlertItemCopyWith(_AlertItem value, $Res Function(_AlertItem) _then) = __$AlertItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _alertReadId) String id,@JsonKey(readValue: _alertReadType) String type,@JsonKey(readValue: _alertReadSeverity) String severity,@JsonKey(readValue: _alertReadTitleEn) String titleEn,@JsonKey(readValue: _alertReadTitleAr) String titleAr,@JsonKey(readValue: _alertReadAt) String atIdentifier
});




}
/// @nodoc
class __$AlertItemCopyWithImpl<$Res>
    implements _$AlertItemCopyWith<$Res> {
  __$AlertItemCopyWithImpl(this._self, this._then);

  final _AlertItem _self;
  final $Res Function(_AlertItem) _then;

/// Create a copy of AlertItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? severity = null,Object? titleEn = null,Object? titleAr = null,Object? atIdentifier = null,}) {
  return _then(_AlertItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,atIdentifier: null == atIdentifier ? _self.atIdentifier : atIdentifier // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DashboardKpis {

 int get requestedTenths; int get loadedTenths; int get deliveredTenths; int get pendingTenths; Map<String, int> get ordersByStatus; int get driversAvailable; int get driversBusy; int get driversOffline; int get vehiclesFree; int get vehiclesAssigned; int get vehiclesBreakdown; int get vehiclesMaintenance; int get lateOrders; List<AlertItem> get alerts; List<String> get reloadRequired;
/// Create a copy of DashboardKpis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardKpisCopyWith<DashboardKpis> get copyWith => _$DashboardKpisCopyWithImpl<DashboardKpis>(this as DashboardKpis, _$identity);

  /// Serializes this DashboardKpis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardKpis&&(identical(other.requestedTenths, requestedTenths) || other.requestedTenths == requestedTenths)&&(identical(other.loadedTenths, loadedTenths) || other.loadedTenths == loadedTenths)&&(identical(other.deliveredTenths, deliveredTenths) || other.deliveredTenths == deliveredTenths)&&(identical(other.pendingTenths, pendingTenths) || other.pendingTenths == pendingTenths)&&const DeepCollectionEquality().equals(other.ordersByStatus, ordersByStatus)&&(identical(other.driversAvailable, driversAvailable) || other.driversAvailable == driversAvailable)&&(identical(other.driversBusy, driversBusy) || other.driversBusy == driversBusy)&&(identical(other.driversOffline, driversOffline) || other.driversOffline == driversOffline)&&(identical(other.vehiclesFree, vehiclesFree) || other.vehiclesFree == vehiclesFree)&&(identical(other.vehiclesAssigned, vehiclesAssigned) || other.vehiclesAssigned == vehiclesAssigned)&&(identical(other.vehiclesBreakdown, vehiclesBreakdown) || other.vehiclesBreakdown == vehiclesBreakdown)&&(identical(other.vehiclesMaintenance, vehiclesMaintenance) || other.vehiclesMaintenance == vehiclesMaintenance)&&(identical(other.lateOrders, lateOrders) || other.lateOrders == lateOrders)&&const DeepCollectionEquality().equals(other.alerts, alerts)&&const DeepCollectionEquality().equals(other.reloadRequired, reloadRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestedTenths,loadedTenths,deliveredTenths,pendingTenths,const DeepCollectionEquality().hash(ordersByStatus),driversAvailable,driversBusy,driversOffline,vehiclesFree,vehiclesAssigned,vehiclesBreakdown,vehiclesMaintenance,lateOrders,const DeepCollectionEquality().hash(alerts),const DeepCollectionEquality().hash(reloadRequired));

@override
String toString() {
  return 'DashboardKpis(requestedTenths: $requestedTenths, loadedTenths: $loadedTenths, deliveredTenths: $deliveredTenths, pendingTenths: $pendingTenths, ordersByStatus: $ordersByStatus, driversAvailable: $driversAvailable, driversBusy: $driversBusy, driversOffline: $driversOffline, vehiclesFree: $vehiclesFree, vehiclesAssigned: $vehiclesAssigned, vehiclesBreakdown: $vehiclesBreakdown, vehiclesMaintenance: $vehiclesMaintenance, lateOrders: $lateOrders, alerts: $alerts, reloadRequired: $reloadRequired)';
}


}

/// @nodoc
abstract mixin class $DashboardKpisCopyWith<$Res>  {
  factory $DashboardKpisCopyWith(DashboardKpis value, $Res Function(DashboardKpis) _then) = _$DashboardKpisCopyWithImpl;
@useResult
$Res call({
 int requestedTenths, int loadedTenths, int deliveredTenths, int pendingTenths, Map<String, int> ordersByStatus, int driversAvailable, int driversBusy, int driversOffline, int vehiclesFree, int vehiclesAssigned, int vehiclesBreakdown, int vehiclesMaintenance, int lateOrders, List<AlertItem> alerts, List<String> reloadRequired
});




}
/// @nodoc
class _$DashboardKpisCopyWithImpl<$Res>
    implements $DashboardKpisCopyWith<$Res> {
  _$DashboardKpisCopyWithImpl(this._self, this._then);

  final DashboardKpis _self;
  final $Res Function(DashboardKpis) _then;

/// Create a copy of DashboardKpis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestedTenths = null,Object? loadedTenths = null,Object? deliveredTenths = null,Object? pendingTenths = null,Object? ordersByStatus = null,Object? driversAvailable = null,Object? driversBusy = null,Object? driversOffline = null,Object? vehiclesFree = null,Object? vehiclesAssigned = null,Object? vehiclesBreakdown = null,Object? vehiclesMaintenance = null,Object? lateOrders = null,Object? alerts = null,Object? reloadRequired = null,}) {
  return _then(_self.copyWith(
requestedTenths: null == requestedTenths ? _self.requestedTenths : requestedTenths // ignore: cast_nullable_to_non_nullable
as int,loadedTenths: null == loadedTenths ? _self.loadedTenths : loadedTenths // ignore: cast_nullable_to_non_nullable
as int,deliveredTenths: null == deliveredTenths ? _self.deliveredTenths : deliveredTenths // ignore: cast_nullable_to_non_nullable
as int,pendingTenths: null == pendingTenths ? _self.pendingTenths : pendingTenths // ignore: cast_nullable_to_non_nullable
as int,ordersByStatus: null == ordersByStatus ? _self.ordersByStatus : ordersByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, int>,driversAvailable: null == driversAvailable ? _self.driversAvailable : driversAvailable // ignore: cast_nullable_to_non_nullable
as int,driversBusy: null == driversBusy ? _self.driversBusy : driversBusy // ignore: cast_nullable_to_non_nullable
as int,driversOffline: null == driversOffline ? _self.driversOffline : driversOffline // ignore: cast_nullable_to_non_nullable
as int,vehiclesFree: null == vehiclesFree ? _self.vehiclesFree : vehiclesFree // ignore: cast_nullable_to_non_nullable
as int,vehiclesAssigned: null == vehiclesAssigned ? _self.vehiclesAssigned : vehiclesAssigned // ignore: cast_nullable_to_non_nullable
as int,vehiclesBreakdown: null == vehiclesBreakdown ? _self.vehiclesBreakdown : vehiclesBreakdown // ignore: cast_nullable_to_non_nullable
as int,vehiclesMaintenance: null == vehiclesMaintenance ? _self.vehiclesMaintenance : vehiclesMaintenance // ignore: cast_nullable_to_non_nullable
as int,lateOrders: null == lateOrders ? _self.lateOrders : lateOrders // ignore: cast_nullable_to_non_nullable
as int,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<AlertItem>,reloadRequired: null == reloadRequired ? _self.reloadRequired : reloadRequired // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardKpis].
extension DashboardKpisPatterns on DashboardKpis {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardKpis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardKpis() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardKpis value)  $default,){
final _that = this;
switch (_that) {
case _DashboardKpis():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardKpis value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardKpis() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int requestedTenths,  int loadedTenths,  int deliveredTenths,  int pendingTenths,  Map<String, int> ordersByStatus,  int driversAvailable,  int driversBusy,  int driversOffline,  int vehiclesFree,  int vehiclesAssigned,  int vehiclesBreakdown,  int vehiclesMaintenance,  int lateOrders,  List<AlertItem> alerts,  List<String> reloadRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardKpis() when $default != null:
return $default(_that.requestedTenths,_that.loadedTenths,_that.deliveredTenths,_that.pendingTenths,_that.ordersByStatus,_that.driversAvailable,_that.driversBusy,_that.driversOffline,_that.vehiclesFree,_that.vehiclesAssigned,_that.vehiclesBreakdown,_that.vehiclesMaintenance,_that.lateOrders,_that.alerts,_that.reloadRequired);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int requestedTenths,  int loadedTenths,  int deliveredTenths,  int pendingTenths,  Map<String, int> ordersByStatus,  int driversAvailable,  int driversBusy,  int driversOffline,  int vehiclesFree,  int vehiclesAssigned,  int vehiclesBreakdown,  int vehiclesMaintenance,  int lateOrders,  List<AlertItem> alerts,  List<String> reloadRequired)  $default,) {final _that = this;
switch (_that) {
case _DashboardKpis():
return $default(_that.requestedTenths,_that.loadedTenths,_that.deliveredTenths,_that.pendingTenths,_that.ordersByStatus,_that.driversAvailable,_that.driversBusy,_that.driversOffline,_that.vehiclesFree,_that.vehiclesAssigned,_that.vehiclesBreakdown,_that.vehiclesMaintenance,_that.lateOrders,_that.alerts,_that.reloadRequired);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int requestedTenths,  int loadedTenths,  int deliveredTenths,  int pendingTenths,  Map<String, int> ordersByStatus,  int driversAvailable,  int driversBusy,  int driversOffline,  int vehiclesFree,  int vehiclesAssigned,  int vehiclesBreakdown,  int vehiclesMaintenance,  int lateOrders,  List<AlertItem> alerts,  List<String> reloadRequired)?  $default,) {final _that = this;
switch (_that) {
case _DashboardKpis() when $default != null:
return $default(_that.requestedTenths,_that.loadedTenths,_that.deliveredTenths,_that.pendingTenths,_that.ordersByStatus,_that.driversAvailable,_that.driversBusy,_that.driversOffline,_that.vehiclesFree,_that.vehiclesAssigned,_that.vehiclesBreakdown,_that.vehiclesMaintenance,_that.lateOrders,_that.alerts,_that.reloadRequired);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DashboardKpis extends DashboardKpis {
  const _DashboardKpis({required this.requestedTenths, required this.loadedTenths, required this.deliveredTenths, required this.pendingTenths, required final  Map<String, int> ordersByStatus, required this.driversAvailable, required this.driversBusy, required this.driversOffline, required this.vehiclesFree, required this.vehiclesAssigned, required this.vehiclesBreakdown, required this.vehiclesMaintenance, required this.lateOrders, required final  List<AlertItem> alerts, required final  List<String> reloadRequired}): _ordersByStatus = ordersByStatus,_alerts = alerts,_reloadRequired = reloadRequired,super._();
  factory _DashboardKpis.fromJson(Map<String, dynamic> json) => _$DashboardKpisFromJson(json);

@override final  int requestedTenths;
@override final  int loadedTenths;
@override final  int deliveredTenths;
@override final  int pendingTenths;
 final  Map<String, int> _ordersByStatus;
@override Map<String, int> get ordersByStatus {
  if (_ordersByStatus is EqualUnmodifiableMapView) return _ordersByStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ordersByStatus);
}

@override final  int driversAvailable;
@override final  int driversBusy;
@override final  int driversOffline;
@override final  int vehiclesFree;
@override final  int vehiclesAssigned;
@override final  int vehiclesBreakdown;
@override final  int vehiclesMaintenance;
@override final  int lateOrders;
 final  List<AlertItem> _alerts;
@override List<AlertItem> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

 final  List<String> _reloadRequired;
@override List<String> get reloadRequired {
  if (_reloadRequired is EqualUnmodifiableListView) return _reloadRequired;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reloadRequired);
}


/// Create a copy of DashboardKpis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardKpisCopyWith<_DashboardKpis> get copyWith => __$DashboardKpisCopyWithImpl<_DashboardKpis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardKpisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardKpis&&(identical(other.requestedTenths, requestedTenths) || other.requestedTenths == requestedTenths)&&(identical(other.loadedTenths, loadedTenths) || other.loadedTenths == loadedTenths)&&(identical(other.deliveredTenths, deliveredTenths) || other.deliveredTenths == deliveredTenths)&&(identical(other.pendingTenths, pendingTenths) || other.pendingTenths == pendingTenths)&&const DeepCollectionEquality().equals(other._ordersByStatus, _ordersByStatus)&&(identical(other.driversAvailable, driversAvailable) || other.driversAvailable == driversAvailable)&&(identical(other.driversBusy, driversBusy) || other.driversBusy == driversBusy)&&(identical(other.driversOffline, driversOffline) || other.driversOffline == driversOffline)&&(identical(other.vehiclesFree, vehiclesFree) || other.vehiclesFree == vehiclesFree)&&(identical(other.vehiclesAssigned, vehiclesAssigned) || other.vehiclesAssigned == vehiclesAssigned)&&(identical(other.vehiclesBreakdown, vehiclesBreakdown) || other.vehiclesBreakdown == vehiclesBreakdown)&&(identical(other.vehiclesMaintenance, vehiclesMaintenance) || other.vehiclesMaintenance == vehiclesMaintenance)&&(identical(other.lateOrders, lateOrders) || other.lateOrders == lateOrders)&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&const DeepCollectionEquality().equals(other._reloadRequired, _reloadRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestedTenths,loadedTenths,deliveredTenths,pendingTenths,const DeepCollectionEquality().hash(_ordersByStatus),driversAvailable,driversBusy,driversOffline,vehiclesFree,vehiclesAssigned,vehiclesBreakdown,vehiclesMaintenance,lateOrders,const DeepCollectionEquality().hash(_alerts),const DeepCollectionEquality().hash(_reloadRequired));

@override
String toString() {
  return 'DashboardKpis(requestedTenths: $requestedTenths, loadedTenths: $loadedTenths, deliveredTenths: $deliveredTenths, pendingTenths: $pendingTenths, ordersByStatus: $ordersByStatus, driversAvailable: $driversAvailable, driversBusy: $driversBusy, driversOffline: $driversOffline, vehiclesFree: $vehiclesFree, vehiclesAssigned: $vehiclesAssigned, vehiclesBreakdown: $vehiclesBreakdown, vehiclesMaintenance: $vehiclesMaintenance, lateOrders: $lateOrders, alerts: $alerts, reloadRequired: $reloadRequired)';
}


}

/// @nodoc
abstract mixin class _$DashboardKpisCopyWith<$Res> implements $DashboardKpisCopyWith<$Res> {
  factory _$DashboardKpisCopyWith(_DashboardKpis value, $Res Function(_DashboardKpis) _then) = __$DashboardKpisCopyWithImpl;
@override @useResult
$Res call({
 int requestedTenths, int loadedTenths, int deliveredTenths, int pendingTenths, Map<String, int> ordersByStatus, int driversAvailable, int driversBusy, int driversOffline, int vehiclesFree, int vehiclesAssigned, int vehiclesBreakdown, int vehiclesMaintenance, int lateOrders, List<AlertItem> alerts, List<String> reloadRequired
});




}
/// @nodoc
class __$DashboardKpisCopyWithImpl<$Res>
    implements _$DashboardKpisCopyWith<$Res> {
  __$DashboardKpisCopyWithImpl(this._self, this._then);

  final _DashboardKpis _self;
  final $Res Function(_DashboardKpis) _then;

/// Create a copy of DashboardKpis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestedTenths = null,Object? loadedTenths = null,Object? deliveredTenths = null,Object? pendingTenths = null,Object? ordersByStatus = null,Object? driversAvailable = null,Object? driversBusy = null,Object? driversOffline = null,Object? vehiclesFree = null,Object? vehiclesAssigned = null,Object? vehiclesBreakdown = null,Object? vehiclesMaintenance = null,Object? lateOrders = null,Object? alerts = null,Object? reloadRequired = null,}) {
  return _then(_DashboardKpis(
requestedTenths: null == requestedTenths ? _self.requestedTenths : requestedTenths // ignore: cast_nullable_to_non_nullable
as int,loadedTenths: null == loadedTenths ? _self.loadedTenths : loadedTenths // ignore: cast_nullable_to_non_nullable
as int,deliveredTenths: null == deliveredTenths ? _self.deliveredTenths : deliveredTenths // ignore: cast_nullable_to_non_nullable
as int,pendingTenths: null == pendingTenths ? _self.pendingTenths : pendingTenths // ignore: cast_nullable_to_non_nullable
as int,ordersByStatus: null == ordersByStatus ? _self._ordersByStatus : ordersByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, int>,driversAvailable: null == driversAvailable ? _self.driversAvailable : driversAvailable // ignore: cast_nullable_to_non_nullable
as int,driversBusy: null == driversBusy ? _self.driversBusy : driversBusy // ignore: cast_nullable_to_non_nullable
as int,driversOffline: null == driversOffline ? _self.driversOffline : driversOffline // ignore: cast_nullable_to_non_nullable
as int,vehiclesFree: null == vehiclesFree ? _self.vehiclesFree : vehiclesFree // ignore: cast_nullable_to_non_nullable
as int,vehiclesAssigned: null == vehiclesAssigned ? _self.vehiclesAssigned : vehiclesAssigned // ignore: cast_nullable_to_non_nullable
as int,vehiclesBreakdown: null == vehiclesBreakdown ? _self.vehiclesBreakdown : vehiclesBreakdown // ignore: cast_nullable_to_non_nullable
as int,vehiclesMaintenance: null == vehiclesMaintenance ? _self.vehiclesMaintenance : vehiclesMaintenance // ignore: cast_nullable_to_non_nullable
as int,lateOrders: null == lateOrders ? _self.lateOrders : lateOrders // ignore: cast_nullable_to_non_nullable
as int,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<AlertItem>,reloadRequired: null == reloadRequired ? _self._reloadRequired : reloadRequired // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
