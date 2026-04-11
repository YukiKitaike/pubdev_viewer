// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_publisher_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackagePublisherResponse {

 String? get publisherId;
/// Create a copy of PackagePublisherResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackagePublisherResponseCopyWith<PackagePublisherResponse> get copyWith => _$PackagePublisherResponseCopyWithImpl<PackagePublisherResponse>(this as PackagePublisherResponse, _$identity);

  /// Serializes this PackagePublisherResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackagePublisherResponse&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publisherId);

@override
String toString() {
  return 'PackagePublisherResponse(publisherId: $publisherId)';
}


}

/// @nodoc
abstract mixin class $PackagePublisherResponseCopyWith<$Res>  {
  factory $PackagePublisherResponseCopyWith(PackagePublisherResponse value, $Res Function(PackagePublisherResponse) _then) = _$PackagePublisherResponseCopyWithImpl;
@useResult
$Res call({
 String? publisherId
});




}
/// @nodoc
class _$PackagePublisherResponseCopyWithImpl<$Res>
    implements $PackagePublisherResponseCopyWith<$Res> {
  _$PackagePublisherResponseCopyWithImpl(this._self, this._then);

  final PackagePublisherResponse _self;
  final $Res Function(PackagePublisherResponse) _then;

/// Create a copy of PackagePublisherResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publisherId = freezed,}) {
  return _then(_self.copyWith(
publisherId: freezed == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PackagePublisherResponse].
extension PackagePublisherResponsePatterns on PackagePublisherResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackagePublisherResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackagePublisherResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackagePublisherResponse value)  $default,){
final _that = this;
switch (_that) {
case _PackagePublisherResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackagePublisherResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PackagePublisherResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publisherId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackagePublisherResponse() when $default != null:
return $default(_that.publisherId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publisherId)  $default,) {final _that = this;
switch (_that) {
case _PackagePublisherResponse():
return $default(_that.publisherId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publisherId)?  $default,) {final _that = this;
switch (_that) {
case _PackagePublisherResponse() when $default != null:
return $default(_that.publisherId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackagePublisherResponse implements PackagePublisherResponse {
  const _PackagePublisherResponse({this.publisherId});
  factory _PackagePublisherResponse.fromJson(Map<String, dynamic> json) => _$PackagePublisherResponseFromJson(json);

@override final  String? publisherId;

/// Create a copy of PackagePublisherResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackagePublisherResponseCopyWith<_PackagePublisherResponse> get copyWith => __$PackagePublisherResponseCopyWithImpl<_PackagePublisherResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackagePublisherResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackagePublisherResponse&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publisherId);

@override
String toString() {
  return 'PackagePublisherResponse(publisherId: $publisherId)';
}


}

/// @nodoc
abstract mixin class _$PackagePublisherResponseCopyWith<$Res> implements $PackagePublisherResponseCopyWith<$Res> {
  factory _$PackagePublisherResponseCopyWith(_PackagePublisherResponse value, $Res Function(_PackagePublisherResponse) _then) = __$PackagePublisherResponseCopyWithImpl;
@override @useResult
$Res call({
 String? publisherId
});




}
/// @nodoc
class __$PackagePublisherResponseCopyWithImpl<$Res>
    implements _$PackagePublisherResponseCopyWith<$Res> {
  __$PackagePublisherResponseCopyWithImpl(this._self, this._then);

  final _PackagePublisherResponse _self;
  final $Res Function(_PackagePublisherResponse) _then;

/// Create a copy of PackagePublisherResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publisherId = freezed,}) {
  return _then(_PackagePublisherResponse(
publisherId: freezed == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
