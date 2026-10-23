// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  driverId: json['driverId'] as String?,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'role': _$RoleEnumMap[instance.role]!,
  'driverId': instance.driverId,
};

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.sales: 'sales',
  Role.dispatcher: 'dispatcher',
  Role.fleetController: 'fleetController',
  Role.driver: 'driver',
  Role.supervisor: 'supervisor',
  Role.finance: 'finance',
  Role.customerStub: 'customerStub',
};
