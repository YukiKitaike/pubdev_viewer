// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageListItem {

 String get name; PackageListVersion get latest;
/// Create a copy of PackageListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageListItemCopyWith<PackageListItem> get copyWith => _$PackageListItemCopyWithImpl<PackageListItem>(this as PackageListItem, _$identity);

  /// Serializes this PackageListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageListItem&&(identical(other.name, name) || other.name == name)&&(identical(other.latest, latest) || other.latest == latest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,latest);

@override
String toString() {
  return 'PackageListItem(name: $name, latest: $latest)';
}


}

/// @nodoc
abstract mixin class $PackageListItemCopyWith<$Res>  {
  factory $PackageListItemCopyWith(PackageListItem value, $Res Function(PackageListItem) _then) = _$PackageListItemCopyWithImpl;
@useResult
$Res call({
 String name, PackageListVersion latest
});


$PackageListVersionCopyWith<$Res> get latest;

}
/// @nodoc
class _$PackageListItemCopyWithImpl<$Res>
    implements $PackageListItemCopyWith<$Res> {
  _$PackageListItemCopyWithImpl(this._self, this._then);

  final PackageListItem _self;
  final $Res Function(PackageListItem) _then;

/// Create a copy of PackageListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? latest = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as PackageListVersion,
  ));
}
/// Create a copy of PackageListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageListVersionCopyWith<$Res> get latest {
  
  return $PackageListVersionCopyWith<$Res>(_self.latest, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackageListItem].
extension PackageListItemPatterns on PackageListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageListItem value)  $default,){
final _that = this;
switch (_that) {
case _PackageListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageListItem value)?  $default,){
final _that = this;
switch (_that) {
case _PackageListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  PackageListVersion latest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageListItem() when $default != null:
return $default(_that.name,_that.latest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  PackageListVersion latest)  $default,) {final _that = this;
switch (_that) {
case _PackageListItem():
return $default(_that.name,_that.latest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  PackageListVersion latest)?  $default,) {final _that = this;
switch (_that) {
case _PackageListItem() when $default != null:
return $default(_that.name,_that.latest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageListItem implements PackageListItem {
  const _PackageListItem({required this.name, required this.latest});
  factory _PackageListItem.fromJson(Map<String, dynamic> json) => _$PackageListItemFromJson(json);

@override final  String name;
@override final  PackageListVersion latest;

/// Create a copy of PackageListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageListItemCopyWith<_PackageListItem> get copyWith => __$PackageListItemCopyWithImpl<_PackageListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageListItem&&(identical(other.name, name) || other.name == name)&&(identical(other.latest, latest) || other.latest == latest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,latest);

@override
String toString() {
  return 'PackageListItem(name: $name, latest: $latest)';
}


}

/// @nodoc
abstract mixin class _$PackageListItemCopyWith<$Res> implements $PackageListItemCopyWith<$Res> {
  factory _$PackageListItemCopyWith(_PackageListItem value, $Res Function(_PackageListItem) _then) = __$PackageListItemCopyWithImpl;
@override @useResult
$Res call({
 String name, PackageListVersion latest
});


@override $PackageListVersionCopyWith<$Res> get latest;

}
/// @nodoc
class __$PackageListItemCopyWithImpl<$Res>
    implements _$PackageListItemCopyWith<$Res> {
  __$PackageListItemCopyWithImpl(this._self, this._then);

  final _PackageListItem _self;
  final $Res Function(_PackageListItem) _then;

/// Create a copy of PackageListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? latest = null,}) {
  return _then(_PackageListItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as PackageListVersion,
  ));
}

/// Create a copy of PackageListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageListVersionCopyWith<$Res> get latest {
  
  return $PackageListVersionCopyWith<$Res>(_self.latest, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}

// dart format on
