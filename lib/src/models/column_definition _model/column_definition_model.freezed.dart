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

ForeignKeyModel _$ForeignKeyModelFromJson(Map<String, dynamic> json) {
  return _ForeignKeyModel.fromJson(json);
}

/// @nodoc
mixin _$ForeignKeyModel {
  @JsonKey(name: 'referenced_schema')
  String get referencedSchema => throw _privateConstructorUsedError;
  @JsonKey(name: 'referenced_table')
  String get referencedTable => throw _privateConstructorUsedError;
  @JsonKey(name: 'referenced_column')
  String get referencedColumn => throw _privateConstructorUsedError;

  /// Serializes this ForeignKeyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForeignKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForeignKeyModelCopyWith<ForeignKeyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForeignKeyModelCopyWith<$Res> {
  factory $ForeignKeyModelCopyWith(
          ForeignKeyModel value, $Res Function(ForeignKeyModel) then) =
      _$ForeignKeyModelCopyWithImpl<$Res, ForeignKeyModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'referenced_schema') String referencedSchema,
      @JsonKey(name: 'referenced_table') String referencedTable,
      @JsonKey(name: 'referenced_column') String referencedColumn});
}

/// @nodoc
class _$ForeignKeyModelCopyWithImpl<$Res, $Val extends ForeignKeyModel>
    implements $ForeignKeyModelCopyWith<$Res> {
  _$ForeignKeyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForeignKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referencedSchema = null,
    Object? referencedTable = null,
    Object? referencedColumn = null,
  }) {
    return _then(_value.copyWith(
      referencedSchema: null == referencedSchema
          ? _value.referencedSchema
          : referencedSchema // ignore: cast_nullable_to_non_nullable
              as String,
      referencedTable: null == referencedTable
          ? _value.referencedTable
          : referencedTable // ignore: cast_nullable_to_non_nullable
              as String,
      referencedColumn: null == referencedColumn
          ? _value.referencedColumn
          : referencedColumn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForeignKeyModelImplCopyWith<$Res>
    implements $ForeignKeyModelCopyWith<$Res> {
  factory _$$ForeignKeyModelImplCopyWith(_$ForeignKeyModelImpl value,
          $Res Function(_$ForeignKeyModelImpl) then) =
      __$$ForeignKeyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'referenced_schema') String referencedSchema,
      @JsonKey(name: 'referenced_table') String referencedTable,
      @JsonKey(name: 'referenced_column') String referencedColumn});
}

/// @nodoc
class __$$ForeignKeyModelImplCopyWithImpl<$Res>
    extends _$ForeignKeyModelCopyWithImpl<$Res, _$ForeignKeyModelImpl>
    implements _$$ForeignKeyModelImplCopyWith<$Res> {
  __$$ForeignKeyModelImplCopyWithImpl(
      _$ForeignKeyModelImpl _value, $Res Function(_$ForeignKeyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForeignKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referencedSchema = null,
    Object? referencedTable = null,
    Object? referencedColumn = null,
  }) {
    return _then(_$ForeignKeyModelImpl(
      referencedSchema: null == referencedSchema
          ? _value.referencedSchema
          : referencedSchema // ignore: cast_nullable_to_non_nullable
              as String,
      referencedTable: null == referencedTable
          ? _value.referencedTable
          : referencedTable // ignore: cast_nullable_to_non_nullable
              as String,
      referencedColumn: null == referencedColumn
          ? _value.referencedColumn
          : referencedColumn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForeignKeyModelImpl extends _ForeignKeyModel {
  const _$ForeignKeyModelImpl(
      {@JsonKey(name: 'referenced_schema') required this.referencedSchema,
      @JsonKey(name: 'referenced_table') required this.referencedTable,
      @JsonKey(name: 'referenced_column') required this.referencedColumn})
      : super._();

  factory _$ForeignKeyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForeignKeyModelImplFromJson(json);

  @override
  @JsonKey(name: 'referenced_schema')
  final String referencedSchema;
  @override
  @JsonKey(name: 'referenced_table')
  final String referencedTable;
  @override
  @JsonKey(name: 'referenced_column')
  final String referencedColumn;

  @override
  String toString() {
    return 'ForeignKeyModel(referencedSchema: $referencedSchema, referencedTable: $referencedTable, referencedColumn: $referencedColumn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForeignKeyModelImpl &&
            (identical(other.referencedSchema, referencedSchema) ||
                other.referencedSchema == referencedSchema) &&
            (identical(other.referencedTable, referencedTable) ||
                other.referencedTable == referencedTable) &&
            (identical(other.referencedColumn, referencedColumn) ||
                other.referencedColumn == referencedColumn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, referencedSchema, referencedTable, referencedColumn);

  /// Create a copy of ForeignKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForeignKeyModelImplCopyWith<_$ForeignKeyModelImpl> get copyWith =>
      __$$ForeignKeyModelImplCopyWithImpl<_$ForeignKeyModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForeignKeyModelImplToJson(
      this,
    );
  }
}

abstract class _ForeignKeyModel extends ForeignKeyModel {
  const factory _ForeignKeyModel(
      {@JsonKey(name: 'referenced_schema')
      required final String referencedSchema,
      @JsonKey(name: 'referenced_table') required final String referencedTable,
      @JsonKey(name: 'referenced_column')
      required final String referencedColumn}) = _$ForeignKeyModelImpl;
  const _ForeignKeyModel._() : super._();

  factory _ForeignKeyModel.fromJson(Map<String, dynamic> json) =
      _$ForeignKeyModelImpl.fromJson;

  @override
  @JsonKey(name: 'referenced_schema')
  String get referencedSchema;
  @override
  @JsonKey(name: 'referenced_table')
  String get referencedTable;
  @override
  @JsonKey(name: 'referenced_column')
  String get referencedColumn;

  /// Create a copy of ForeignKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForeignKeyModelImplCopyWith<_$ForeignKeyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ColumnDefinitionModel _$ColumnDefinitionModelFromJson(
    Map<String, dynamic> json) {
  return _ColumnDefinitionModel.fromJson(json);
}

/// @nodoc
mixin _$ColumnDefinitionModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'column_name')
  String get columnName => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_type')
  @PostgresDataTypeConverter()
  PostgresDataType get dataType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_nullable')
  @YesNoBooleanConverter()
  bool get isNullable => throw _privateConstructorUsedError;
  @JsonKey(name: 'column_default')
  dynamic get columnDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_maximum_length')
  int? get characterMaximumLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_identity')
  @YesNoBooleanConverter()
  bool get isIdentity => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_updatable')
  @YesNoBooleanConverter()
  bool get isUpdatable => throw _privateConstructorUsedError;
  @JsonKey(name: 'enum_options')
  List<String> get enumOptions => throw _privateConstructorUsedError;
  @JsonKey(name: 'foreign_key')
  ForeignKeyModel? get foreignKey => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'column_name') String columnName,
      @JsonKey(name: 'data_type')
      @PostgresDataTypeConverter()
      PostgresDataType dataType,
      @JsonKey(name: 'is_nullable') @YesNoBooleanConverter() bool isNullable,
      @JsonKey(name: 'column_default') dynamic columnDefault,
      @JsonKey(name: 'character_maximum_length') int? characterMaximumLength,
      @JsonKey(name: 'is_identity') @YesNoBooleanConverter() bool isIdentity,
      @JsonKey(name: 'is_updatable') @YesNoBooleanConverter() bool isUpdatable,
      @JsonKey(name: 'enum_options') List<String> enumOptions,
      @JsonKey(name: 'foreign_key') ForeignKeyModel? foreignKey});

  $ForeignKeyModelCopyWith<$Res>? get foreignKey;
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
    Object? tableName = freezed,
    Object? columnName = null,
    Object? dataType = null,
    Object? isNullable = null,
    Object? columnDefault = freezed,
    Object? characterMaximumLength = freezed,
    Object? isIdentity = null,
    Object? isUpdatable = null,
    Object? enumOptions = null,
    Object? foreignKey = freezed,
  }) {
    return _then(_value.copyWith(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as bool,
      columnDefault: freezed == columnDefault
          ? _value.columnDefault
          : columnDefault // ignore: cast_nullable_to_non_nullable
              as dynamic,
      characterMaximumLength: freezed == characterMaximumLength
          ? _value.characterMaximumLength
          : characterMaximumLength // ignore: cast_nullable_to_non_nullable
              as int?,
      isIdentity: null == isIdentity
          ? _value.isIdentity
          : isIdentity // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdatable: null == isUpdatable
          ? _value.isUpdatable
          : isUpdatable // ignore: cast_nullable_to_non_nullable
              as bool,
      enumOptions: null == enumOptions
          ? _value.enumOptions
          : enumOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      foreignKey: freezed == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as ForeignKeyModel?,
    ) as $Val);
  }

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ForeignKeyModelCopyWith<$Res>? get foreignKey {
    if (_value.foreignKey == null) {
      return null;
    }

    return $ForeignKeyModelCopyWith<$Res>(_value.foreignKey!, (value) {
      return _then(_value.copyWith(foreignKey: value) as $Val);
    });
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
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'column_name') String columnName,
      @JsonKey(name: 'data_type')
      @PostgresDataTypeConverter()
      PostgresDataType dataType,
      @JsonKey(name: 'is_nullable') @YesNoBooleanConverter() bool isNullable,
      @JsonKey(name: 'column_default') dynamic columnDefault,
      @JsonKey(name: 'character_maximum_length') int? characterMaximumLength,
      @JsonKey(name: 'is_identity') @YesNoBooleanConverter() bool isIdentity,
      @JsonKey(name: 'is_updatable') @YesNoBooleanConverter() bool isUpdatable,
      @JsonKey(name: 'enum_options') List<String> enumOptions,
      @JsonKey(name: 'foreign_key') ForeignKeyModel? foreignKey});

  @override
  $ForeignKeyModelCopyWith<$Res>? get foreignKey;
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
    Object? tableName = freezed,
    Object? columnName = null,
    Object? dataType = null,
    Object? isNullable = null,
    Object? columnDefault = freezed,
    Object? characterMaximumLength = freezed,
    Object? isIdentity = null,
    Object? isUpdatable = null,
    Object? enumOptions = null,
    Object? foreignKey = freezed,
  }) {
    return _then(_$ColumnDefinitionModelImpl(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as bool,
      columnDefault: freezed == columnDefault
          ? _value.columnDefault
          : columnDefault // ignore: cast_nullable_to_non_nullable
              as dynamic,
      characterMaximumLength: freezed == characterMaximumLength
          ? _value.characterMaximumLength
          : characterMaximumLength // ignore: cast_nullable_to_non_nullable
              as int?,
      isIdentity: null == isIdentity
          ? _value.isIdentity
          : isIdentity // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdatable: null == isUpdatable
          ? _value.isUpdatable
          : isUpdatable // ignore: cast_nullable_to_non_nullable
              as bool,
      enumOptions: null == enumOptions
          ? _value._enumOptions
          : enumOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      foreignKey: freezed == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as ForeignKeyModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColumnDefinitionModelImpl extends _ColumnDefinitionModel {
  const _$ColumnDefinitionModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'column_name') required this.columnName,
      @JsonKey(name: 'data_type')
      @PostgresDataTypeConverter()
      required this.dataType,
      @JsonKey(name: 'is_nullable')
      @YesNoBooleanConverter()
      this.isNullable = false,
      @JsonKey(name: 'column_default') this.columnDefault,
      @JsonKey(name: 'character_maximum_length') this.characterMaximumLength,
      @JsonKey(name: 'is_identity')
      @YesNoBooleanConverter()
      this.isIdentity = false,
      @JsonKey(name: 'is_updatable')
      @YesNoBooleanConverter()
      this.isUpdatable = true,
      @JsonKey(name: 'enum_options') final List<String> enumOptions = const [],
      @JsonKey(name: 'foreign_key') this.foreignKey})
      : _enumOptions = enumOptions,
        super._();

  factory _$ColumnDefinitionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColumnDefinitionModelImplFromJson(json);

  @override
  @JsonKey(name: 'table_name')
  final String? tableName;
  @override
  @JsonKey(name: 'column_name')
  final String columnName;
  @override
  @JsonKey(name: 'data_type')
  @PostgresDataTypeConverter()
  final PostgresDataType dataType;
  @override
  @JsonKey(name: 'is_nullable')
  @YesNoBooleanConverter()
  final bool isNullable;
  @override
  @JsonKey(name: 'column_default')
  final dynamic columnDefault;
  @override
  @JsonKey(name: 'character_maximum_length')
  final int? characterMaximumLength;
  @override
  @JsonKey(name: 'is_identity')
  @YesNoBooleanConverter()
  final bool isIdentity;
  @override
  @JsonKey(name: 'is_updatable')
  @YesNoBooleanConverter()
  final bool isUpdatable;
  final List<String> _enumOptions;
  @override
  @JsonKey(name: 'enum_options')
  List<String> get enumOptions {
    if (_enumOptions is EqualUnmodifiableListView) return _enumOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enumOptions);
  }

  @override
  @JsonKey(name: 'foreign_key')
  final ForeignKeyModel? foreignKey;

  @override
  String toString() {
    return 'ColumnDefinitionModel(tableName: $tableName, columnName: $columnName, dataType: $dataType, isNullable: $isNullable, columnDefault: $columnDefault, characterMaximumLength: $characterMaximumLength, isIdentity: $isIdentity, isUpdatable: $isUpdatable, enumOptions: $enumOptions, foreignKey: $foreignKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColumnDefinitionModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.columnName, columnName) ||
                other.columnName == columnName) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.isNullable, isNullable) ||
                other.isNullable == isNullable) &&
            const DeepCollectionEquality()
                .equals(other.columnDefault, columnDefault) &&
            (identical(other.characterMaximumLength, characterMaximumLength) ||
                other.characterMaximumLength == characterMaximumLength) &&
            (identical(other.isIdentity, isIdentity) ||
                other.isIdentity == isIdentity) &&
            (identical(other.isUpdatable, isUpdatable) ||
                other.isUpdatable == isUpdatable) &&
            const DeepCollectionEquality()
                .equals(other._enumOptions, _enumOptions) &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tableName,
      columnName,
      dataType,
      isNullable,
      const DeepCollectionEquality().hash(columnDefault),
      characterMaximumLength,
      isIdentity,
      isUpdatable,
      const DeepCollectionEquality().hash(_enumOptions),
      foreignKey);

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
          {@JsonKey(name: 'table_name') final String? tableName,
          @JsonKey(name: 'column_name') required final String columnName,
          @JsonKey(name: 'data_type')
          @PostgresDataTypeConverter()
          required final PostgresDataType dataType,
          @JsonKey(name: 'is_nullable')
          @YesNoBooleanConverter()
          final bool isNullable,
          @JsonKey(name: 'column_default') final dynamic columnDefault,
          @JsonKey(name: 'character_maximum_length')
          final int? characterMaximumLength,
          @JsonKey(name: 'is_identity')
          @YesNoBooleanConverter()
          final bool isIdentity,
          @JsonKey(name: 'is_updatable')
          @YesNoBooleanConverter()
          final bool isUpdatable,
          @JsonKey(name: 'enum_options') final List<String> enumOptions,
          @JsonKey(name: 'foreign_key') final ForeignKeyModel? foreignKey}) =
      _$ColumnDefinitionModelImpl;
  const _ColumnDefinitionModel._() : super._();

  factory _ColumnDefinitionModel.fromJson(Map<String, dynamic> json) =
      _$ColumnDefinitionModelImpl.fromJson;

  @override
  @JsonKey(name: 'table_name')
  String? get tableName;
  @override
  @JsonKey(name: 'column_name')
  String get columnName;
  @override
  @JsonKey(name: 'data_type')
  @PostgresDataTypeConverter()
  PostgresDataType get dataType;
  @override
  @JsonKey(name: 'is_nullable')
  @YesNoBooleanConverter()
  bool get isNullable;
  @override
  @JsonKey(name: 'column_default')
  dynamic get columnDefault;
  @override
  @JsonKey(name: 'character_maximum_length')
  int? get characterMaximumLength;
  @override
  @JsonKey(name: 'is_identity')
  @YesNoBooleanConverter()
  bool get isIdentity;
  @override
  @JsonKey(name: 'is_updatable')
  @YesNoBooleanConverter()
  bool get isUpdatable;
  @override
  @JsonKey(name: 'enum_options')
  List<String> get enumOptions;
  @override
  @JsonKey(name: 'foreign_key')
  ForeignKeyModel? get foreignKey;

  /// Create a copy of ColumnDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColumnDefinitionModelImplCopyWith<_$ColumnDefinitionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
