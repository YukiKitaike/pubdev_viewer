// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_detail_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageDetailVersion {

 String get version; Pubspec get pubspec; String get archiveUrl; String get archiveSha256;@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601) DateTime get published;
/// Create a copy of PackageDetailVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageDetailVersionCopyWith<PackageDetailVersion> get copyWith => _$PackageDetailVersionCopyWithImpl<PackageDetailVersion>(this as PackageDetailVersion, _$identity);

  /// Serializes this PackageDetailVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageDetailVersion&&(identical(other.version, version) || other.version == version)&&(identical(other.pubspec, pubspec) || other.pubspec == pubspec)&&(identical(other.archiveUrl, archiveUrl) || other.archiveUrl == archiveUrl)&&(identical(other.archiveSha256, archiveSha256) || other.archiveSha256 == archiveSha256)&&(identical(other.published, published) || other.published == published));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,pubspec,archiveUrl,archiveSha256,published);

@override
String toString() {
  return 'PackageDetailVersion(version: $version, pubspec: $pubspec, archiveUrl: $archiveUrl, archiveSha256: $archiveSha256, published: $published)';
}


}

/// @nodoc
abstract mixin class $PackageDetailVersionCopyWith<$Res>  {
  factory $PackageDetailVersionCopyWith(PackageDetailVersion value, $Res Function(PackageDetailVersion) _then) = _$PackageDetailVersionCopyWithImpl;
@useResult
$Res call({
 String version, Pubspec pubspec, String archiveUrl, String archiveSha256,@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601) DateTime published
});


$PubspecCopyWith<$Res> get pubspec;

}
/// @nodoc
class _$PackageDetailVersionCopyWithImpl<$Res>
    implements $PackageDetailVersionCopyWith<$Res> {
  _$PackageDetailVersionCopyWithImpl(this._self, this._then);

  final PackageDetailVersion _self;
  final $Res Function(PackageDetailVersion) _then;

/// Create a copy of PackageDetailVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? pubspec = null,Object? archiveUrl = null,Object? archiveSha256 = null,Object? published = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,pubspec: null == pubspec ? _self.pubspec : pubspec // ignore: cast_nullable_to_non_nullable
as Pubspec,archiveUrl: null == archiveUrl ? _self.archiveUrl : archiveUrl // ignore: cast_nullable_to_non_nullable
as String,archiveSha256: null == archiveSha256 ? _self.archiveSha256 : archiveSha256 // ignore: cast_nullable_to_non_nullable
as String,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PackageDetailVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PubspecCopyWith<$Res> get pubspec {
  
  return $PubspecCopyWith<$Res>(_self.pubspec, (value) {
    return _then(_self.copyWith(pubspec: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackageDetailVersion].
extension PackageDetailVersionPatterns on PackageDetailVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageDetailVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageDetailVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageDetailVersion value)  $default,){
final _that = this;
switch (_that) {
case _PackageDetailVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageDetailVersion value)?  $default,){
final _that = this;
switch (_that) {
case _PackageDetailVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  Pubspec pubspec,  String archiveUrl,  String archiveSha256, @JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)  DateTime published)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageDetailVersion() when $default != null:
return $default(_that.version,_that.pubspec,_that.archiveUrl,_that.archiveSha256,_that.published);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  Pubspec pubspec,  String archiveUrl,  String archiveSha256, @JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)  DateTime published)  $default,) {final _that = this;
switch (_that) {
case _PackageDetailVersion():
return $default(_that.version,_that.pubspec,_that.archiveUrl,_that.archiveSha256,_that.published);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  Pubspec pubspec,  String archiveUrl,  String archiveSha256, @JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)  DateTime published)?  $default,) {final _that = this;
switch (_that) {
case _PackageDetailVersion() when $default != null:
return $default(_that.version,_that.pubspec,_that.archiveUrl,_that.archiveSha256,_that.published);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PackageDetailVersion implements PackageDetailVersion {
  const _PackageDetailVersion({required this.version, required this.pubspec, required this.archiveUrl, required this.archiveSha256, @JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601) required this.published});
  factory _PackageDetailVersion.fromJson(Map<String, dynamic> json) => _$PackageDetailVersionFromJson(json);

@override final  String version;
@override final  Pubspec pubspec;
@override final  String archiveUrl;
@override final  String archiveSha256;
@override@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601) final  DateTime published;

/// Create a copy of PackageDetailVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageDetailVersionCopyWith<_PackageDetailVersion> get copyWith => __$PackageDetailVersionCopyWithImpl<_PackageDetailVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageDetailVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageDetailVersion&&(identical(other.version, version) || other.version == version)&&(identical(other.pubspec, pubspec) || other.pubspec == pubspec)&&(identical(other.archiveUrl, archiveUrl) || other.archiveUrl == archiveUrl)&&(identical(other.archiveSha256, archiveSha256) || other.archiveSha256 == archiveSha256)&&(identical(other.published, published) || other.published == published));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,pubspec,archiveUrl,archiveSha256,published);

@override
String toString() {
  return 'PackageDetailVersion(version: $version, pubspec: $pubspec, archiveUrl: $archiveUrl, archiveSha256: $archiveSha256, published: $published)';
}


}

/// @nodoc
abstract mixin class _$PackageDetailVersionCopyWith<$Res> implements $PackageDetailVersionCopyWith<$Res> {
  factory _$PackageDetailVersionCopyWith(_PackageDetailVersion value, $Res Function(_PackageDetailVersion) _then) = __$PackageDetailVersionCopyWithImpl;
@override @useResult
$Res call({
 String version, Pubspec pubspec, String archiveUrl, String archiveSha256,@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601) DateTime published
});


@override $PubspecCopyWith<$Res> get pubspec;

}
/// @nodoc
class __$PackageDetailVersionCopyWithImpl<$Res>
    implements _$PackageDetailVersionCopyWith<$Res> {
  __$PackageDetailVersionCopyWithImpl(this._self, this._then);

  final _PackageDetailVersion _self;
  final $Res Function(_PackageDetailVersion) _then;

/// Create a copy of PackageDetailVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? pubspec = null,Object? archiveUrl = null,Object? archiveSha256 = null,Object? published = null,}) {
  return _then(_PackageDetailVersion(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,pubspec: null == pubspec ? _self.pubspec : pubspec // ignore: cast_nullable_to_non_nullable
as Pubspec,archiveUrl: null == archiveUrl ? _self.archiveUrl : archiveUrl // ignore: cast_nullable_to_non_nullable
as String,archiveSha256: null == archiveSha256 ? _self.archiveSha256 : archiveSha256 // ignore: cast_nullable_to_non_nullable
as String,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PackageDetailVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PubspecCopyWith<$Res> get pubspec {
  
  return $PubspecCopyWith<$Res>(_self.pubspec, (value) {
    return _then(_self.copyWith(pubspec: value));
  });
}
}

// dart format on
