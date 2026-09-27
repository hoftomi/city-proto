// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartyViewCWProxy {
  PartyView house(HouseRef house);

  PartyView program(String program);

  PartyView votes(int votes);

  PartyView seats(int seats);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartyView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartyView(...).copyWith(id: 12, name: "My name")
  /// ````
  PartyView call({HouseRef house, String program, int votes, int seats});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartyView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartyView.copyWith.fieldName(...)`
class _$PartyViewCWProxyImpl implements _$PartyViewCWProxy {
  const _$PartyViewCWProxyImpl(this._value);

  final PartyView _value;

  @override
  PartyView house(HouseRef house) => this(house: house);

  @override
  PartyView program(String program) => this(program: program);

  @override
  PartyView votes(int votes) => this(votes: votes);

  @override
  PartyView seats(int seats) => this(seats: seats);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartyView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartyView(...).copyWith(id: 12, name: "My name")
  /// ````
  PartyView call({
    Object? house = const $CopyWithPlaceholder(),
    Object? program = const $CopyWithPlaceholder(),
    Object? votes = const $CopyWithPlaceholder(),
    Object? seats = const $CopyWithPlaceholder(),
  }) {
    return PartyView(
      house: house == const $CopyWithPlaceholder()
          ? _value.house
          // ignore: cast_nullable_to_non_nullable
          : house as HouseRef,
      program: program == const $CopyWithPlaceholder()
          ? _value.program
          // ignore: cast_nullable_to_non_nullable
          : program as String,
      votes: votes == const $CopyWithPlaceholder()
          ? _value.votes
          // ignore: cast_nullable_to_non_nullable
          : votes as int,
      seats: seats == const $CopyWithPlaceholder()
          ? _value.seats
          // ignore: cast_nullable_to_non_nullable
          : seats as int,
    );
  }
}

extension $PartyViewCopyWith on PartyView {
  /// Returns a callable class that can be used as follows: `instanceOfPartyView.copyWith(...)` or like so:`instanceOfPartyView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartyViewCWProxy get copyWith => _$PartyViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyView _$PartyViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartyView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['house', 'program', 'votes', 'seats'],
      );
      final val = PartyView(
        house: $checkedConvert(
          'house',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        program: $checkedConvert('program', (v) => v as String),
        votes: $checkedConvert('votes', (v) => (v as num).toInt()),
        seats: $checkedConvert('seats', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PartyViewToJson(PartyView instance) => <String, dynamic>{
  'house': instance.house.toJson(),
  'program': instance.program,
  'votes': instance.votes,
  'seats': instance.seats,
};
