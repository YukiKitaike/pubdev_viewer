// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_list_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageListVersion {

 String get version; Pubspec get pubspec; String get archiveUrl; String get packageUrl; String get url;
/// Create a copy of PackageListVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageListVersionCopyWith<PackageListVersion> get copyWith => _$PackageListVersionCopyWithImpl<PackageListVersion>(this as PackageListVersion, _$identity);

  /// Serializes this PackageListVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageListVersion&&(identical(other.version, version) || other.version == version)&&(identical(other.pubspec, pubspec) || other.pubspec == pubspec)&&(identical(other.archiveUrl, archiveUrl) || other.archiveUrl == archiveUrl)&&(identical(other.packageUrl, packageUrl) || other.packageUrl == packageUrl)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,pubspec,archiveUrl,packageUrl,url);

@override
String toString() {
  return 'PackageListVersion(version: $version, pubspec: $pubspec, archiveUrl: $archiveUrl, packageUrl: $packageUrl, url: $url)';
}


}

/// @nodoc
abstract mixin class $PackageListVersionCopyWith<$Res>  {
  factory $PackageListVersionCopyWith(PackageListVersion value, $Res Function(PackageListVersion) _then) = _$PackageListVersionCopyWithImpl;
@useResult
$Res call({
 String version, Pubspec pubspec, String archiveUrl, String packageUrl, String url
});


$PubspecCopyWith<$Res> get pubspec;

}
/// @nodoc
class _$PackageListVersionCopyWithImpl<$Res>
    implements $PackageListVersionCopyWith<$Res> {
  _$PackageListVersionCopyWithImpl(this._self, this._then);

  final PackageListVersion _self;
  final $Res Function(PackageListVersion) _then;

/// Create a copy of PackageListVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? pubspec = null,Object? archiveUrl = null,Object? packageUrl = null,Object? url = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,pubspec: null == pubspec ? _self.pubspec : pubspec // ignore: cast_nullable_to_non_nullable
as Pubspec,archiveUrl: null == archiveUrl ? _self.archiveUrl : archiveUrl // ignore: cast_nullable_to_non_nullable
as String,packageUrl: null == packageUrl ? _self.packageUrl : packageUrl // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PackageListVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PubspecCopyWith<$Res> get pubspec {
  
  return $PubspecCopyWith<$Res>(_self.pubspec, (value) {
    return _then(_self.copyWith(pubspec: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackageListVersion].
extension PackageListVersionPatterns on PackageListVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageListVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageListVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageListVersion value)  $default,){
final _that = this;
switch (_that) {
case _PackageListVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageListVersion value)?  $default,){
final _that = this;
switch (_that) {
case _PackageListVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  Pubspec pubspec,  String archiveUrl,  String packageUrl,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageListVersion() when $default != null:
return $default(_that.version,_that.pubspec,_that.archiveUrl,_that.packageUrl,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  Pubspec pubspec,  String archiveUrl,  String packageUrl,  String url)  $default,) {final _that = this;
switch (_that) {
case _PackageListVersion():
return $default(_that.version,_that.pubspec,_that.archiveUrl,_that.packageUrl,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  Pubspec pubspec,  String archiveUrl,  String packageUrl,  String url)?  $default,) {final _that = this;
switch (_that) {
case _PackageListVersion() when $default != null:
return $default(_that.version,_that.pubspec,_that.archiveUrl,_that.packageUrl,_that.url);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PackageListVersion implements PackageListVersion {
  const _PackageListVersion({required this.version, required this.pubspec, required this.archiveUrl, required this.packageUrl, required this.url});
  factory _PackageListVersion.fromJson(Map<String, dynamic> json) => _$PackageListVersionFromJson(json);

@override final  String version;
@override final  Pubspec pubspec;
@override final  String archiveUrl;
@override final  String packageUrl;
@override final  String url;

/// Create a copy of PackageListVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageListVersionCopyWith<_PackageListVersion> get copyWith => __$PackageListVersionCopyWithImpl<_PackageListVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageListVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageListVersion&&(identical(other.version, version) || other.version == version)&&(identical(other.pubspec, pubspec) || other.pubspec == pubspec)&&(identical(other.archiveUrl, archiveUrl) || other.archiveUrl == archiveUrl)&&(identical(other.packageUrl, packageUrl) || other.packageUrl == packageUrl)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,pubspec,archiveUrl,packageUrl,url);

@override
String toString() {
  return 'PackageListVersion(version: $version, pubspec: $pubspec, archiveUrl: $archiveUrl, packageUrl: $packageUrl, url: $url)';
}


}

/// @nodoc
abstract mixin class _$PackageListVersionCopyWith<$Res> implements $PackageListVersionCopyWith<$Res> {
  factory _$PackageListVersionCopyWith(_PackageListVersion value, $Res Function(_PackageListVersion) _then) = __$PackageListVersionCopyWithImpl;
@override @useResult
$Res call({
 String version, Pubspec pubspec, String archiveUrl, String packageUrl, String url
});


@override $PubspecCopyWith<$Res> get pubspec;

}
/// @nodoc
class __$PackageListVersionCopyWithImpl<$Res>
    implements _$PackageListVersionCopyWith<$Res> {
  __$PackageListVersionCopyWithImpl(this._self, this._then);

  final _PackageListVersion _self;
  final $Res Function(_PackageListVersion) _then;

/// Create a copy of PackageListVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? pubspec = null,Object? archiveUrl = null,Object? packageUrl = null,Object? url = null,}) {
  return _then(_PackageListVersion(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,pubspec: null == pubspec ? _self.pubspec : pubspec // ignore: cast_nullable_to_non_nullable
as Pubspec,archiveUrl: null == archiveUrl ? _self.archiveUrl : archiveUrl // ignore: cast_nullable_to_non_nullable
as String,packageUrl: null == packageUrl ? _self.packageUrl : packageUrl // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PackageListVersion
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
