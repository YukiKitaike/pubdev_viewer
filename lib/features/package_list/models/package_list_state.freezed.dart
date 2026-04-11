// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PackageListState {

 List<PackageListItem> get packages; String? get nextUrl; bool get isLoadingMore; Object? get loadMoreError;
/// Create a copy of PackageListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageListStateCopyWith<PackageListState> get copyWith => _$PackageListStateCopyWithImpl<PackageListState>(this as PackageListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageListState&&const DeepCollectionEquality().equals(other.packages, packages)&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(packages),nextUrl,isLoadingMore,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'PackageListState(packages: $packages, nextUrl: $nextUrl, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $PackageListStateCopyWith<$Res>  {
  factory $PackageListStateCopyWith(PackageListState value, $Res Function(PackageListState) _then) = _$PackageListStateCopyWithImpl;
@useResult
$Res call({
 List<PackageListItem> packages, String? nextUrl, bool isLoadingMore, Object? loadMoreError
});




}
/// @nodoc
class _$PackageListStateCopyWithImpl<$Res>
    implements $PackageListStateCopyWith<$Res> {
  _$PackageListStateCopyWithImpl(this._self, this._then);

  final PackageListState _self;
  final $Res Function(PackageListState) _then;

/// Create a copy of PackageListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packages = null,Object? nextUrl = freezed,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
packages: null == packages ? _self.packages : packages // ignore: cast_nullable_to_non_nullable
as List<PackageListItem>,nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageListState].
extension PackageListStatePatterns on PackageListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageListState value)  $default,){
final _that = this;
switch (_that) {
case _PackageListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageListState value)?  $default,){
final _that = this;
switch (_that) {
case _PackageListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PackageListItem> packages,  String? nextUrl,  bool isLoadingMore,  Object? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageListState() when $default != null:
return $default(_that.packages,_that.nextUrl,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PackageListItem> packages,  String? nextUrl,  bool isLoadingMore,  Object? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _PackageListState():
return $default(_that.packages,_that.nextUrl,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PackageListItem> packages,  String? nextUrl,  bool isLoadingMore,  Object? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _PackageListState() when $default != null:
return $default(_that.packages,_that.nextUrl,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _PackageListState implements PackageListState {
  const _PackageListState({final  List<PackageListItem> packages = const [], this.nextUrl, this.isLoadingMore = false, this.loadMoreError}): _packages = packages;
  

 final  List<PackageListItem> _packages;
@override@JsonKey() List<PackageListItem> get packages {
  if (_packages is EqualUnmodifiableListView) return _packages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packages);
}

@override final  String? nextUrl;
@override@JsonKey() final  bool isLoadingMore;
@override final  Object? loadMoreError;

/// Create a copy of PackageListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageListStateCopyWith<_PackageListState> get copyWith => __$PackageListStateCopyWithImpl<_PackageListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageListState&&const DeepCollectionEquality().equals(other._packages, _packages)&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_packages),nextUrl,isLoadingMore,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'PackageListState(packages: $packages, nextUrl: $nextUrl, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$PackageListStateCopyWith<$Res> implements $PackageListStateCopyWith<$Res> {
  factory _$PackageListStateCopyWith(_PackageListState value, $Res Function(_PackageListState) _then) = __$PackageListStateCopyWithImpl;
@override @useResult
$Res call({
 List<PackageListItem> packages, String? nextUrl, bool isLoadingMore, Object? loadMoreError
});




}
/// @nodoc
class __$PackageListStateCopyWithImpl<$Res>
    implements _$PackageListStateCopyWith<$Res> {
  __$PackageListStateCopyWithImpl(this._self, this._then);

  final _PackageListState _self;
  final $Res Function(_PackageListState) _then;

/// Create a copy of PackageListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packages = null,Object? nextUrl = freezed,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_PackageListState(
packages: null == packages ? _self._packages : packages // ignore: cast_nullable_to_non_nullable
as List<PackageListItem>,nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}


}

// dart format on
