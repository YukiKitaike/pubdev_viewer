// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageListResponse {

@JsonKey(name: 'next_url') String? get nextUrl; List<PackageListItem> get packages;
/// Create a copy of PackageListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageListResponseCopyWith<PackageListResponse> get copyWith => _$PackageListResponseCopyWithImpl<PackageListResponse>(this as PackageListResponse, _$identity);

  /// Serializes this PackageListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageListResponse&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl)&&const DeepCollectionEquality().equals(other.packages, packages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextUrl,const DeepCollectionEquality().hash(packages));

@override
String toString() {
  return 'PackageListResponse(nextUrl: $nextUrl, packages: $packages)';
}


}

/// @nodoc
abstract mixin class $PackageListResponseCopyWith<$Res>  {
  factory $PackageListResponseCopyWith(PackageListResponse value, $Res Function(PackageListResponse) _then) = _$PackageListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'next_url') String? nextUrl, List<PackageListItem> packages
});




}
/// @nodoc
class _$PackageListResponseCopyWithImpl<$Res>
    implements $PackageListResponseCopyWith<$Res> {
  _$PackageListResponseCopyWithImpl(this._self, this._then);

  final PackageListResponse _self;
  final $Res Function(PackageListResponse) _then;

/// Create a copy of PackageListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextUrl = freezed,Object? packages = null,}) {
  return _then(_self.copyWith(
nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,packages: null == packages ? _self.packages : packages // ignore: cast_nullable_to_non_nullable
as List<PackageListItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageListResponse].
extension PackageListResponsePatterns on PackageListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PackageListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PackageListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_url')  String? nextUrl,  List<PackageListItem> packages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageListResponse() when $default != null:
return $default(_that.nextUrl,_that.packages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_url')  String? nextUrl,  List<PackageListItem> packages)  $default,) {final _that = this;
switch (_that) {
case _PackageListResponse():
return $default(_that.nextUrl,_that.packages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'next_url')  String? nextUrl,  List<PackageListItem> packages)?  $default,) {final _that = this;
switch (_that) {
case _PackageListResponse() when $default != null:
return $default(_that.nextUrl,_that.packages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageListResponse implements PackageListResponse {
  const _PackageListResponse({@JsonKey(name: 'next_url') this.nextUrl, required final  List<PackageListItem> packages}): _packages = packages;
  factory _PackageListResponse.fromJson(Map<String, dynamic> json) => _$PackageListResponseFromJson(json);

@override@JsonKey(name: 'next_url') final  String? nextUrl;
 final  List<PackageListItem> _packages;
@override List<PackageListItem> get packages {
  if (_packages is EqualUnmodifiableListView) return _packages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packages);
}


/// Create a copy of PackageListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageListResponseCopyWith<_PackageListResponse> get copyWith => __$PackageListResponseCopyWithImpl<_PackageListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageListResponse&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl)&&const DeepCollectionEquality().equals(other._packages, _packages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextUrl,const DeepCollectionEquality().hash(_packages));

@override
String toString() {
  return 'PackageListResponse(nextUrl: $nextUrl, packages: $packages)';
}


}

/// @nodoc
abstract mixin class _$PackageListResponseCopyWith<$Res> implements $PackageListResponseCopyWith<$Res> {
  factory _$PackageListResponseCopyWith(_PackageListResponse value, $Res Function(_PackageListResponse) _then) = __$PackageListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'next_url') String? nextUrl, List<PackageListItem> packages
});




}
/// @nodoc
class __$PackageListResponseCopyWithImpl<$Res>
    implements _$PackageListResponseCopyWith<$Res> {
  __$PackageListResponseCopyWithImpl(this._self, this._then);

  final _PackageListResponse _self;
  final $Res Function(_PackageListResponse) _then;

/// Create a copy of PackageListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextUrl = freezed,Object? packages = null,}) {
  return _then(_PackageListResponse(
nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,packages: null == packages ? _self._packages : packages // ignore: cast_nullable_to_non_nullable
as List<PackageListItem>,
  ));
}


}

// dart format on
