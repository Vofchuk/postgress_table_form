// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'column_definition_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ColumnDefinitionModel _$ColumnDefinitionModelFromJson(
    Map<String, dynamic> json) {
  return _ColumnDefinitionModel.fromJson(json);
}

/// @nodoc
mixin _$ColumnDefinitionModel {
  @JsonKey(name: 'column_name')
  String get columnName => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_type')
  @PostgresDataTypeConverter()
  PostgresDataType get dataType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_nullable')
  String get isNullable => throw _privateConstructorUsedError;
  @JsonKey(name: 'column_default')
  dynamic get columnDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'enum_options')
  List<String> get enumOptions => throw _privateConstructorUsedError;

  /// Serializes this ColumnDefinitionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ColumnDefinitionModelCopyWith<ColumnDefinitionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColumnDefinitionModelCopyWith<$Res> {
  factory $ColumnDefinitionModelCopyWith(ColumnDefinitionModel value,
          $Res Function(ColumnDefinitionModel) then) =
      _$ColumnDefinitionModelCopyWithImpl<$Res, ColumnDefinitionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'column_name') String columnName,
      @JsonKey(name: 'data_type')
      @PostgresDataTypeConverter()
      PostgresDataType dataType,
      @JsonKey(name: 'is_nullable') String isNullable,
      @JsonKey(name: 'column_default') dynamic columnDefault,
      @JsonKey(name: 'enum_options') List<String> enumOptions});
}

/// @nodoc
class _$ColumnDefinitionModelCopyWithImpl<$Res,
        $Val extends ColumnDefinitionModel>
    implements $ColumnDefinitionModelCopyWith<$Res> {
  _$ColumnDefinitionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? columnName = null,
    Object? dataType = null,
    Object? isNullable = null,
    Object? columnDefault = freezed,
    Object? enumOptions = null,
  }) {
    return _then(_value.copyWith(
      columnName: null == columnName
          ? _value.columnName
          : columnName // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as PostgresDataType,
      isNullable: null == isNullable
          ? _value.isNullable
          : isNullable // ignore: cast_nullable_to_non_nullable
              as String,
      columnDefault: freezed == columnDefault
          ? _value.columnDefault
          : columnDefault // ignore: cast_nullable_to_non_nullable
              as dynamic,
      enumOptions: null == enumOptions
          ? _value.enumOptions
          : enumOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ColumnDefinitionModelImplCopyWith<$Res>
    implements $ColumnDefinitionModelCopyWith<$Res> {
  factory _$$ColumnDefinitionModelImplCopyWith(
          _$ColumnDefinitionModelImpl value,
          $Res Function(_$ColumnDefinitionModelImpl) then) =
      __$$ColumnDefinitionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'column_name') String columnName,
      @JsonKey(name: 'data_type')
      @PostgresDataTypeConverter()
      PostgresDataType dataType,
      @JsonKey(name: 'is_nullable') String isNullable,
      @JsonKey(name: 'column_default') dynamic columnDefault,
      @JsonKey(name: 'enum_options') List<String> enumOptions});
}

/// @nodoc
class __$$ColumnDefinitionModelImplCopyWithImpl<$Res>
    extends _$ColumnDefinitionModelCopyWithImpl<$Res,
        _$ColumnDefinitionModelImpl>
    implements _$$ColumnDefinitionModelImplCopyWith<$Res> {
  __$$ColumnDefinitionModelImplCopyWithImpl(_$ColumnDefinitionModelImpl _value,
      $Res Function(_$ColumnDefinitionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? columnName = null,
    Object? dataType = null,
    Object? isNullable = null,
    Object? columnDefault = freezed,
    Object? enumOptions = null,
  }) {
    return _then(_$ColumnDefinitionModelImpl(
      columnName: null == columnName
          ? _value.columnName
          : columnName // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as PostgresDataType,
      isNullable: null == isNullable
          ? _value.isNullable
          : isNullable // ignore: cast_nullable_to_non_nullable
              as String,
      columnDefault: freezed == columnDefault
          ? _value.columnDefault
          : columnDefault // ignore: cast_nullable_to_non_nullable
              as dynamic,
      enumOptions: null == enumOptions
          ? _value._enumOptions
          : enumOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColumnDefinitionModelImpl extends _ColumnDefinitionModel {
  const _$ColumnDefinitionModelImpl(
      {@JsonKey(name: 'column_name') required this.columnName,
      @JsonKey(name: 'data_type')
      @PostgresDataTypeConverter()
      required this.dataType,
      @JsonKey(name: 'is_nullable') required this.isNullable,
      @JsonKey(name: 'column_default') this.columnDefault,
      @JsonKey(name: 'enum_options') final List<String> enumOptions = const []})
      : _enumOptions = enumOptions,
        super._();

  factory _$ColumnDefinitionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColumnDefinitionModelImplFromJson(json);

  @override
  @JsonKey(name: 'column_name')
  final String columnName;
  @override
  @JsonKey(name: 'data_type')
  @PostgresDataTypeConverter()
  final PostgresDataType dataType;
  @override
  @JsonKey(name: 'is_nullable')
  final String isNullable;
  @override
  @JsonKey(name: 'column_default')
  final dynamic columnDefault;
  final List<String> _enumOptions;
  @override
  @JsonKey(name: 'enum_options')
  List<String> get enumOptions {
    if (_enumOptions is EqualUnmodifiableListView) return _enumOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enumOptions);
  }

  @override
  String toString() {
    return 'ColumnDefinitionModel(columnName: $columnName, dataType: $dataType, isNullable: $isNullable, columnDefault: $columnDefault, enumOptions: $enumOptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColumnDefinitionModelImpl &&
            (identical(other.columnName, columnName) ||
                other.columnName == columnName) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.isNullable, isNullable) ||
                other.isNullable == isNullable) &&
            const DeepCollectionEquality()
                .equals(other.columnDefault, columnDefault) &&
            const DeepCollectionEquality()
                .equals(other._enumOptions, _enumOptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      columnName,
      dataType,
      isNullable,
      const DeepCollectionEquality().hash(columnDefault),
      const DeepCollectionEquality().hash(_enumOptions));

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ColumnDefinitionModelImplCopyWith<_$ColumnDefinitionModelImpl>
      get copyWith => __$$ColumnDefinitionModelImplCopyWithImpl<
          _$ColumnDefinitionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ColumnDefinitionModelImplToJson(
      this,
    );
  }
}

abstract class _ColumnDefinitionModel extends ColumnDefinitionModel {
  const factory _ColumnDefinitionModel(
          {@JsonKey(name: 'column_name') required final String columnName,
          @JsonKey(name: 'data_type')
          @PostgresDataTypeConverter()
          required final PostgresDataType dataType,
          @JsonKey(name: 'is_nullable') required final String isNullable,
          @JsonKey(name: 'column_default') final dynamic columnDefault,
          @JsonKey(name: 'enum_options') final List<String> enumOptions}) =
      _$ColumnDefinitionModelImpl;
  const _ColumnDefinitionModel._() : super._();

  factory _ColumnDefinitionModel.fromJson(Map<String, dynamic> json) =
      _$ColumnDefinitionModelImpl.fromJson;

  @override
  @JsonKey(name: 'column_name')
  String get columnName;
  @override
  @JsonKey(name: 'data_type')
  @PostgresDataTypeConverter()
  PostgresDataType get dataType;
  @override
  @JsonKey(name: 'is_nullable')
  String get isNullable;
  @override
  @JsonKey(name: 'column_default')
  dynamic get columnDefault;
  @override
  @JsonKey(name: 'enum_options')
  List<String> get enumOptions;

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColumnDefinitionModelImplCopyWith<_$ColumnDefinitionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
