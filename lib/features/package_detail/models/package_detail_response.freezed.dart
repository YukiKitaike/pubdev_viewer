// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageDetailResponse {

 String get name; PackageDetailVersion get latest; List<PackageDetailVersion> get versions; String? get advisoriesUpdated;
/// Create a copy of PackageDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageDetailResponseCopyWith<PackageDetailResponse> get copyWith => _$PackageDetailResponseCopyWithImpl<PackageDetailResponse>(this as PackageDetailResponse, _$identity);

  /// Serializes this PackageDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageDetailResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.latest, latest) || other.latest == latest)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.advisoriesUpdated, advisoriesUpdated) || other.advisoriesUpdated == advisoriesUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,latest,const DeepCollectionEquality().hash(versions),advisoriesUpdated);

@override
String toString() {
  return 'PackageDetailResponse(name: $name, latest: $latest, versions: $versions, advisoriesUpdated: $advisoriesUpdated)';
}


}

/// @nodoc
abstract mixin class $PackageDetailResponseCopyWith<$Res>  {
  factory $PackageDetailResponseCopyWith(PackageDetailResponse value, $Res Function(PackageDetailResponse) _then) = _$PackageDetailResponseCopyWithImpl;
@useResult
$Res call({
 String name, PackageDetailVersion latest, List<PackageDetailVersion> versions, String? advisoriesUpdated
});


$PackageDetailVersionCopyWith<$Res> get latest;

}
/// @nodoc
class _$PackageDetailResponseCopyWithImpl<$Res>
    implements $PackageDetailResponseCopyWith<$Res> {
  _$PackageDetailResponseCopyWithImpl(this._self, this._then);

  final PackageDetailResponse _self;
  final $Res Function(PackageDetailResponse) _then;

/// Create a copy of PackageDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? latest = null,Object? versions = null,Object? advisoriesUpdated = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as PackageDetailVersion,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<PackageDetailVersion>,advisoriesUpdated: freezed == advisoriesUpdated ? _self.advisoriesUpdated : advisoriesUpdated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PackageDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageDetailVersionCopyWith<$Res> get latest {
  
  return $PackageDetailVersionCopyWith<$Res>(_self.latest, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackageDetailResponse].
extension PackageDetailResponsePatterns on PackageDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _PackageDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PackageDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  PackageDetailVersion latest,  List<PackageDetailVersion> versions,  String? advisoriesUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageDetailResponse() when $default != null:
return $default(_that.name,_that.latest,_that.versions,_that.advisoriesUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  PackageDetailVersion latest,  List<PackageDetailVersion> versions,  String? advisoriesUpdated)  $default,) {final _that = this;
switch (_that) {
case _PackageDetailResponse():
return $default(_that.name,_that.latest,_that.versions,_that.advisoriesUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  PackageDetailVersion latest,  List<PackageDetailVersion> versions,  String? advisoriesUpdated)?  $default,) {final _that = this;
switch (_that) {
case _PackageDetailResponse() when $default != null:
return $default(_that.name,_that.latest,_that.versions,_that.advisoriesUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageDetailResponse implements PackageDetailResponse {
  const _PackageDetailResponse({required this.name, required this.latest, required final  List<PackageDetailVersion> versions, this.advisoriesUpdated}): _versions = versions;
  factory _PackageDetailResponse.fromJson(Map<String, dynamic> json) => _$PackageDetailResponseFromJson(json);

@override final  String name;
@override final  PackageDetailVersion latest;
 final  List<PackageDetailVersion> _versions;
@override List<PackageDetailVersion> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}

@override final  String? advisoriesUpdated;

/// Create a copy of PackageDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageDetailResponseCopyWith<_PackageDetailResponse> get copyWith => __$PackageDetailResponseCopyWithImpl<_PackageDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageDetailResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.latest, latest) || other.latest == latest)&&const DeepCollectionEquality().equals(other._versions, _versions)&&(identical(other.advisoriesUpdated, advisoriesUpdated) || other.advisoriesUpdated == advisoriesUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,latest,const DeepCollectionEquality().hash(_versions),advisoriesUpdated);

@override
String toString() {
  return 'PackageDetailResponse(name: $name, latest: $latest, versions: $versions, advisoriesUpdated: $advisoriesUpdated)';
}


}

/// @nodoc
abstract mixin class _$PackageDetailResponseCopyWith<$Res> implements $PackageDetailResponseCopyWith<$Res> {
  factory _$PackageDetailResponseCopyWith(_PackageDetailResponse value, $Res Function(_PackageDetailResponse) _then) = __$PackageDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 String name, PackageDetailVersion latest, List<PackageDetailVersion> versions, String? advisoriesUpdated
});


@override $PackageDetailVersionCopyWith<$Res> get latest;

}
/// @nodoc
class __$PackageDetailResponseCopyWithImpl<$Res>
    implements _$PackageDetailResponseCopyWith<$Res> {
  __$PackageDetailResponseCopyWithImpl(this._self, this._then);

  final _PackageDetailResponse _self;
  final $Res Function(_PackageDetailResponse) _then;

/// Create a copy of PackageDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? latest = null,Object? versions = null,Object? advisoriesUpdated = freezed,}) {
  return _then(_PackageDetailResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as PackageDetailVersion,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<PackageDetailVersion>,advisoriesUpdated: freezed == advisoriesUpdated ? _self.advisoriesUpdated : advisoriesUpdated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PackageDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageDetailVersionCopyWith<$Res> get latest {
  
  return $PackageDetailVersionCopyWith<$Res>(_self.latest, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}

// dart format on
