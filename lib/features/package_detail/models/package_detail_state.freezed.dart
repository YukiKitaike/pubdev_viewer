// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PackageDetailState {

 PackageDetailResponse get detail; PackagePublisherResponse get publisher;
/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageDetailStateCopyWith<PackageDetailState> get copyWith => _$PackageDetailStateCopyWithImpl<PackageDetailState>(this as PackageDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageDetailState&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.publisher, publisher) || other.publisher == publisher));
}


@override
int get hashCode => Object.hash(runtimeType,detail,publisher);

@override
String toString() {
  return 'PackageDetailState(detail: $detail, publisher: $publisher)';
}


}

/// @nodoc
abstract mixin class $PackageDetailStateCopyWith<$Res>  {
  factory $PackageDetailStateCopyWith(PackageDetailState value, $Res Function(PackageDetailState) _then) = _$PackageDetailStateCopyWithImpl;
@useResult
$Res call({
 PackageDetailResponse detail, PackagePublisherResponse publisher
});


$PackageDetailResponseCopyWith<$Res> get detail;$PackagePublisherResponseCopyWith<$Res> get publisher;

}
/// @nodoc
class _$PackageDetailStateCopyWithImpl<$Res>
    implements $PackageDetailStateCopyWith<$Res> {
  _$PackageDetailStateCopyWithImpl(this._self, this._then);

  final PackageDetailState _self;
  final $Res Function(PackageDetailState) _then;

/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detail = null,Object? publisher = null,}) {
  return _then(_self.copyWith(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as PackageDetailResponse,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as PackagePublisherResponse,
  ));
}
/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageDetailResponseCopyWith<$Res> get detail {
  
  return $PackageDetailResponseCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackagePublisherResponseCopyWith<$Res> get publisher {
  
  return $PackagePublisherResponseCopyWith<$Res>(_self.publisher, (value) {
    return _then(_self.copyWith(publisher: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackageDetailState].
extension PackageDetailStatePatterns on PackageDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageDetailState value)  $default,){
final _that = this;
switch (_that) {
case _PackageDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _PackageDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PackageDetailResponse detail,  PackagePublisherResponse publisher)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageDetailState() when $default != null:
return $default(_that.detail,_that.publisher);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PackageDetailResponse detail,  PackagePublisherResponse publisher)  $default,) {final _that = this;
switch (_that) {
case _PackageDetailState():
return $default(_that.detail,_that.publisher);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PackageDetailResponse detail,  PackagePublisherResponse publisher)?  $default,) {final _that = this;
switch (_that) {
case _PackageDetailState() when $default != null:
return $default(_that.detail,_that.publisher);case _:
  return null;

}
}

}

/// @nodoc


class _PackageDetailState implements PackageDetailState {
  const _PackageDetailState({required this.detail, required this.publisher});
  

@override final  PackageDetailResponse detail;
@override final  PackagePublisherResponse publisher;

/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageDetailStateCopyWith<_PackageDetailState> get copyWith => __$PackageDetailStateCopyWithImpl<_PackageDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageDetailState&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.publisher, publisher) || other.publisher == publisher));
}


@override
int get hashCode => Object.hash(runtimeType,detail,publisher);

@override
String toString() {
  return 'PackageDetailState(detail: $detail, publisher: $publisher)';
}


}

/// @nodoc
abstract mixin class _$PackageDetailStateCopyWith<$Res> implements $PackageDetailStateCopyWith<$Res> {
  factory _$PackageDetailStateCopyWith(_PackageDetailState value, $Res Function(_PackageDetailState) _then) = __$PackageDetailStateCopyWithImpl;
@override @useResult
$Res call({
 PackageDetailResponse detail, PackagePublisherResponse publisher
});


@override $PackageDetailResponseCopyWith<$Res> get detail;@override $PackagePublisherResponseCopyWith<$Res> get publisher;

}
/// @nodoc
class __$PackageDetailStateCopyWithImpl<$Res>
    implements _$PackageDetailStateCopyWith<$Res> {
  __$PackageDetailStateCopyWithImpl(this._self, this._then);

  final _PackageDetailState _self;
  final $Res Function(_PackageDetailState) _then;

/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? detail = null,Object? publisher = null,}) {
  return _then(_PackageDetailState(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as PackageDetailResponse,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as PackagePublisherResponse,
  ));
}

/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackageDetailResponseCopyWith<$Res> get detail {
  
  return $PackageDetailResponseCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}/// Create a copy of PackageDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackagePublisherResponseCopyWith<$Res> get publisher {
  
  return $PackagePublisherResponseCopyWith<$Res>(_self.publisher, (value) {
    return _then(_self.copyWith(publisher: value));
  });
}
}

// dart format on
