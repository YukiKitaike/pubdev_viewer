// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pubspec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pubspec {

 String get name; String get version; String get description; String? get homepage; String? get repository; String? get issueTracker; List<String>? get topics; Map<String, String>? get environment; Map<String, dynamic>? get dependencies; Map<String, dynamic>? get devDependencies;
/// Create a copy of Pubspec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PubspecCopyWith<Pubspec> get copyWith => _$PubspecCopyWithImpl<Pubspec>(this as Pubspec, _$identity);

  /// Serializes this Pubspec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pubspec&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.description, description) || other.description == description)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.repository, repository) || other.repository == repository)&&(identical(other.issueTracker, issueTracker) || other.issueTracker == issueTracker)&&const DeepCollectionEquality().equals(other.topics, topics)&&const DeepCollectionEquality().equals(other.environment, environment)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.devDependencies, devDependencies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,description,homepage,repository,issueTracker,const DeepCollectionEquality().hash(topics),const DeepCollectionEquality().hash(environment),const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(devDependencies));

@override
String toString() {
  return 'Pubspec(name: $name, version: $version, description: $description, homepage: $homepage, repository: $repository, issueTracker: $issueTracker, topics: $topics, environment: $environment, dependencies: $dependencies, devDependencies: $devDependencies)';
}


}

/// @nodoc
abstract mixin class $PubspecCopyWith<$Res>  {
  factory $PubspecCopyWith(Pubspec value, $Res Function(Pubspec) _then) = _$PubspecCopyWithImpl;
@useResult
$Res call({
 String name, String version, String description, String? homepage, String? repository, String? issueTracker, List<String>? topics, Map<String, String>? environment, Map<String, dynamic>? dependencies, Map<String, dynamic>? devDependencies
});




}
/// @nodoc
class _$PubspecCopyWithImpl<$Res>
    implements $PubspecCopyWith<$Res> {
  _$PubspecCopyWithImpl(this._self, this._then);

  final Pubspec _self;
  final $Res Function(Pubspec) _then;

/// Create a copy of Pubspec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? version = null,Object? description = null,Object? homepage = freezed,Object? repository = freezed,Object? issueTracker = freezed,Object? topics = freezed,Object? environment = freezed,Object? dependencies = freezed,Object? devDependencies = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,repository: freezed == repository ? _self.repository : repository // ignore: cast_nullable_to_non_nullable
as String?,issueTracker: freezed == issueTracker ? _self.issueTracker : issueTracker // ignore: cast_nullable_to_non_nullable
as String?,topics: freezed == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,dependencies: freezed == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,devDependencies: freezed == devDependencies ? _self.devDependencies : devDependencies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Pubspec].
extension PubspecPatterns on Pubspec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pubspec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pubspec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pubspec value)  $default,){
final _that = this;
switch (_that) {
case _Pubspec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pubspec value)?  $default,){
final _that = this;
switch (_that) {
case _Pubspec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String version,  String description,  String? homepage,  String? repository,  String? issueTracker,  List<String>? topics,  Map<String, String>? environment,  Map<String, dynamic>? dependencies,  Map<String, dynamic>? devDependencies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pubspec() when $default != null:
return $default(_that.name,_that.version,_that.description,_that.homepage,_that.repository,_that.issueTracker,_that.topics,_that.environment,_that.dependencies,_that.devDependencies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String version,  String description,  String? homepage,  String? repository,  String? issueTracker,  List<String>? topics,  Map<String, String>? environment,  Map<String, dynamic>? dependencies,  Map<String, dynamic>? devDependencies)  $default,) {final _that = this;
switch (_that) {
case _Pubspec():
return $default(_that.name,_that.version,_that.description,_that.homepage,_that.repository,_that.issueTracker,_that.topics,_that.environment,_that.dependencies,_that.devDependencies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String version,  String description,  String? homepage,  String? repository,  String? issueTracker,  List<String>? topics,  Map<String, String>? environment,  Map<String, dynamic>? dependencies,  Map<String, dynamic>? devDependencies)?  $default,) {final _that = this;
switch (_that) {
case _Pubspec() when $default != null:
return $default(_that.name,_that.version,_that.description,_that.homepage,_that.repository,_that.issueTracker,_that.topics,_that.environment,_that.dependencies,_that.devDependencies);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Pubspec implements Pubspec {
  const _Pubspec({required this.name, required this.version, required this.description, this.homepage, this.repository, this.issueTracker, final  List<String>? topics, final  Map<String, String>? environment, final  Map<String, dynamic>? dependencies, final  Map<String, dynamic>? devDependencies}): _topics = topics,_environment = environment,_dependencies = dependencies,_devDependencies = devDependencies;
  factory _Pubspec.fromJson(Map<String, dynamic> json) => _$PubspecFromJson(json);

@override final  String name;
@override final  String version;
@override final  String description;
@override final  String? homepage;
@override final  String? repository;
@override final  String? issueTracker;
 final  List<String>? _topics;
@override List<String>? get topics {
  final value = _topics;
  if (value == null) return null;
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, String>? _environment;
@override Map<String, String>? get environment {
  final value = _environment;
  if (value == null) return null;
  if (_environment is EqualUnmodifiableMapView) return _environment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _dependencies;
@override Map<String, dynamic>? get dependencies {
  final value = _dependencies;
  if (value == null) return null;
  if (_dependencies is EqualUnmodifiableMapView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _devDependencies;
@override Map<String, dynamic>? get devDependencies {
  final value = _devDependencies;
  if (value == null) return null;
  if (_devDependencies is EqualUnmodifiableMapView) return _devDependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Pubspec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PubspecCopyWith<_Pubspec> get copyWith => __$PubspecCopyWithImpl<_Pubspec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PubspecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pubspec&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.description, description) || other.description == description)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.repository, repository) || other.repository == repository)&&(identical(other.issueTracker, issueTracker) || other.issueTracker == issueTracker)&&const DeepCollectionEquality().equals(other._topics, _topics)&&const DeepCollectionEquality().equals(other._environment, _environment)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies)&&const DeepCollectionEquality().equals(other._devDependencies, _devDependencies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,description,homepage,repository,issueTracker,const DeepCollectionEquality().hash(_topics),const DeepCollectionEquality().hash(_environment),const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_devDependencies));

@override
String toString() {
  return 'Pubspec(name: $name, version: $version, description: $description, homepage: $homepage, repository: $repository, issueTracker: $issueTracker, topics: $topics, environment: $environment, dependencies: $dependencies, devDependencies: $devDependencies)';
}


}

/// @nodoc
abstract mixin class _$PubspecCopyWith<$Res> implements $PubspecCopyWith<$Res> {
  factory _$PubspecCopyWith(_Pubspec value, $Res Function(_Pubspec) _then) = __$PubspecCopyWithImpl;
@override @useResult
$Res call({
 String name, String version, String description, String? homepage, String? repository, String? issueTracker, List<String>? topics, Map<String, String>? environment, Map<String, dynamic>? dependencies, Map<String, dynamic>? devDependencies
});




}
/// @nodoc
class __$PubspecCopyWithImpl<$Res>
    implements _$PubspecCopyWith<$Res> {
  __$PubspecCopyWithImpl(this._self, this._then);

  final _Pubspec _self;
  final $Res Function(_Pubspec) _then;

/// Create a copy of Pubspec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? version = null,Object? description = null,Object? homepage = freezed,Object? repository = freezed,Object? issueTracker = freezed,Object? topics = freezed,Object? environment = freezed,Object? dependencies = freezed,Object? devDependencies = freezed,}) {
  return _then(_Pubspec(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,repository: freezed == repository ? _self.repository : repository // ignore: cast_nullable_to_non_nullable
as String?,issueTracker: freezed == issueTracker ? _self.issueTracker : issueTracker // ignore: cast_nullable_to_non_nullable
as String?,topics: freezed == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>?,environment: freezed == environment ? _self._environment : environment // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,dependencies: freezed == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,devDependencies: freezed == devDependencies ? _self._devDependencies : devDependencies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
