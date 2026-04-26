// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CatalogState {
  List<Product> get products => throw _privateConstructorUsedError;
  bool get isFetching => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogStateCopyWith<CatalogState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogStateCopyWith<$Res> {
  factory $CatalogStateCopyWith(
    CatalogState value,
    $Res Function(CatalogState) then,
  ) = _$CatalogStateCopyWithImpl<$Res, CatalogState>;
  @useResult
  $Res call({
    List<Product> products,
    bool isFetching,
    bool hasMore,
    String query,
    int skip,
  });
}

/// @nodoc
class _$CatalogStateCopyWithImpl<$Res, $Val extends CatalogState>
    implements $CatalogStateCopyWith<$Res> {
  _$CatalogStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? isFetching = null,
    Object? hasMore = null,
    Object? query = null,
    Object? skip = null,
  }) {
    return _then(
      _value.copyWith(
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<Product>,
            isFetching: null == isFetching
                ? _value.isFetching
                : isFetching // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            skip: null == skip
                ? _value.skip
                : skip // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogStateImplCopyWith<$Res>
    implements $CatalogStateCopyWith<$Res> {
  factory _$$CatalogStateImplCopyWith(
    _$CatalogStateImpl value,
    $Res Function(_$CatalogStateImpl) then,
  ) = __$$CatalogStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Product> products,
    bool isFetching,
    bool hasMore,
    String query,
    int skip,
  });
}

/// @nodoc
class __$$CatalogStateImplCopyWithImpl<$Res>
    extends _$CatalogStateCopyWithImpl<$Res, _$CatalogStateImpl>
    implements _$$CatalogStateImplCopyWith<$Res> {
  __$$CatalogStateImplCopyWithImpl(
    _$CatalogStateImpl _value,
    $Res Function(_$CatalogStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? isFetching = null,
    Object? hasMore = null,
    Object? query = null,
    Object? skip = null,
  }) {
    return _then(
      _$CatalogStateImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Product>,
        isFetching: null == isFetching
            ? _value.isFetching
            : isFetching // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CatalogStateImpl implements _CatalogState {
  const _$CatalogStateImpl({
    final List<Product> products = const [],
    this.isFetching = false,
    this.hasMore = true,
    this.query = '',
    this.skip = 0,
  }) : _products = products;

  final List<Product> _products;
  @override
  @JsonKey()
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  @JsonKey()
  final bool isFetching;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final String query;
  @override
  @JsonKey()
  final int skip;

  @override
  String toString() {
    return 'CatalogState(products: $products, isFetching: $isFetching, hasMore: $hasMore, query: $query, skip: $skip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogStateImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.isFetching, isFetching) ||
                other.isFetching == isFetching) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.skip, skip) || other.skip == skip));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    isFetching,
    hasMore,
    query,
    skip,
  );

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogStateImplCopyWith<_$CatalogStateImpl> get copyWith =>
      __$$CatalogStateImplCopyWithImpl<_$CatalogStateImpl>(this, _$identity);
}

abstract class _CatalogState implements CatalogState {
  const factory _CatalogState({
    final List<Product> products,
    final bool isFetching,
    final bool hasMore,
    final String query,
    final int skip,
  }) = _$CatalogStateImpl;

  @override
  List<Product> get products;
  @override
  bool get isFetching;
  @override
  bool get hasMore;
  @override
  String get query;
  @override
  int get skip;

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogStateImplCopyWith<_$CatalogStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
