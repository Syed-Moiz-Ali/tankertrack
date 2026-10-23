// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapPosition _$MapPositionFromJson(Map<String, dynamic> json) => _MapPosition(
  id: json['id'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  style: $enumDecode(_$StatusStyleEnumMap, json['style']),
  label: json['label'] as String?,
);

Map<String, dynamic> _$MapPositionToJson(_MapPosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'style': _$StatusStyleEnumMap[instance.style]!,
      'label': instance.label,
    };

const _$StatusStyleEnumMap = {
  StatusStyle.completed: 'completed',
  StatusStyle.active: 'active',
  StatusStyle.loading: 'loading',
  StatusStyle.unloading: 'unloading',
  StatusStyle.waiting: 'waiting',
  StatusStyle.critical: 'critical',
  StatusStyle.offline: 'offline',
};
