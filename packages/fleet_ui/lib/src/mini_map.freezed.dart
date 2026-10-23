// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapPosition {

 String get id; double get lat; double get lng; StatusStyle get style; String? get label;
/// Create a copy of MapPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPositionCopyWith<MapPosition> get copyWith => _$MapPositionCopyWithImpl<MapPosition>(this as MapPosition, _$identity);

  /// Serializes this MapPosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPosition&&(identical(other.id, id) || other.id == id)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.style, style) || other.style == style)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lat,lng,style,label);

@override
String toString() {
  return 'MapPosition(id: $id, lat: $lat, lng: $lng, style: $style, label: $label)';
}


}

/// @nodoc
abstract mixin class $MapPositionCopyWith<$Res>  {
  factory $MapPositionCopyWith(MapPosition value, $Res Function(MapPosition) _then) = _$MapPositionCopyWithImpl;
@useResult
$Res call({
 String id, double lat, double lng, StatusStyle style, String? label
});




}
/// @nodoc
class _$MapPositionCopyWithImpl<$Res>
    implements $MapPositionCopyWith<$Res> {
  _$MapPositionCopyWithImpl(this._self, this._then);

  final MapPosition _self;
  final $Res Function(MapPosition) _then;

/// Create a copy of MapPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lat = null,Object? lng = null,Object? style = null,Object? label = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as StatusStyle,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapPosition].
extension MapPositionPatterns on MapPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapPosition value)  $default,){
final _that = this;
switch (_that) {
case _MapPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapPosition value)?  $default,){
final _that = this;
switch (_that) {
case _MapPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double lat,  double lng,  StatusStyle style,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapPosition() when $default != null:
return $default(_that.id,_that.lat,_that.lng,_that.style,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double lat,  double lng,  StatusStyle style,  String? label)  $default,) {final _that = this;
switch (_that) {
case _MapPosition():
return $default(_that.id,_that.lat,_that.lng,_that.style,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double lat,  double lng,  StatusStyle style,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _MapPosition() when $default != null:
return $default(_that.id,_that.lat,_that.lng,_that.style,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapPosition implements MapPosition {
  const _MapPosition({required this.id, required this.lat, required this.lng, required this.style, this.label});
  factory _MapPosition.fromJson(Map<String, dynamic> json) => _$MapPositionFromJson(json);

@override final  String id;
@override final  double lat;
@override final  double lng;
@override final  StatusStyle style;
@override final  String? label;

/// Create a copy of MapPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapPositionCopyWith<_MapPosition> get copyWith => __$MapPositionCopyWithImpl<_MapPosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapPositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapPosition&&(identical(other.id, id) || other.id == id)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.style, style) || other.style == style)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lat,lng,style,label);

@override
String toString() {
  return 'MapPosition(id: $id, lat: $lat, lng: $lng, style: $style, label: $label)';
}


}

/// @nodoc
abstract mixin class _$MapPositionCopyWith<$Res> implements $MapPositionCopyWith<$Res> {
  factory _$MapPositionCopyWith(_MapPosition value, $Res Function(_MapPosition) _then) = __$MapPositionCopyWithImpl;
@override @useResult
$Res call({
 String id, double lat, double lng, StatusStyle style, String? label
});




}
/// @nodoc
class __$MapPositionCopyWithImpl<$Res>
    implements _$MapPositionCopyWith<$Res> {
  __$MapPositionCopyWithImpl(this._self, this._then);

  final _MapPosition _self;
  final $Res Function(_MapPosition) _then;

/// Create a copy of MapPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lat = null,Object? lng = null,Object? style = null,Object? label = freezed,}) {
  return _then(_MapPosition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as StatusStyle,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
