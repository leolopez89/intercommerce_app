// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductDetailState {
  Product? get product => throw _privateConstructorUsedError;
  bool get isFetching => throw _privateConstructorUsedError;

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductDetailStateCopyWith<ProductDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailStateCopyWith<$Res> {
  factory $ProductDetailStateCopyWith(
    ProductDetailState value,
    $Res Function(ProductDetailState) then,
  ) = _$ProductDetailStateCopyWithImpl<$Res, ProductDetailState>;
  @useResult
  $Res call({Product? product, bool isFetching});
}

/// @nodoc
class _$ProductDetailStateCopyWithImpl<$Res, $Val extends ProductDetailState>
    implements $ProductDetailStateCopyWith<$Res> {
  _$ProductDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = freezed, Object? isFetching = null}) {
    return _then(
      _value.copyWith(
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Product?,
            isFetching: null == isFetching
                ? _value.isFetching
                : isFetching // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductDetailStateImplCopyWith<$Res>
    implements $ProductDetailStateCopyWith<$Res> {
  factory _$$ProductDetailStateImplCopyWith(
    _$ProductDetailStateImpl value,
    $Res Function(_$ProductDetailStateImpl) then,
  ) = __$$ProductDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Product? product, bool isFetching});
}

/// @nodoc
class __$$ProductDetailStateImplCopyWithImpl<$Res>
    extends _$ProductDetailStateCopyWithImpl<$Res, _$ProductDetailStateImpl>
    implements _$$ProductDetailStateImplCopyWith<$Res> {
  __$$ProductDetailStateImplCopyWithImpl(
    _$ProductDetailStateImpl _value,
    $Res Function(_$ProductDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = freezed, Object? isFetching = null}) {
    return _then(
      _$ProductDetailStateImpl(
        product: freezed == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product?,
        isFetching: null == isFetching
            ? _value.isFetching
            : isFetching // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ProductDetailStateImpl implements _ProductDetailState {
  const _$ProductDetailStateImpl({
    this.product = null,
    this.isFetching = false,
  });

  @override
  @JsonKey()
  final Product? product;
  @override
  @JsonKey()
  final bool isFetching;

  @override
  String toString() {
    return 'ProductDetailState(product: $product, isFetching: $isFetching)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailStateImpl &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.isFetching, isFetching) ||
                other.isFetching == isFetching));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product, isFetching);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailStateImplCopyWith<_$ProductDetailStateImpl> get copyWith =>
      __$$ProductDetailStateImplCopyWithImpl<_$ProductDetailStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ProductDetailState implements ProductDetailState {
  const factory _ProductDetailState({
    final Product? product,
    final bool isFetching,
  }) = _$ProductDetailStateImpl;

  @override
  Product? get product;
  @override
  bool get isFetching;

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailStateImplCopyWith<_$ProductDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
