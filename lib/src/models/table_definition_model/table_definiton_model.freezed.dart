// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_definiton_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TableDefinitionModel _$TableDefinitionModelFromJson(Map<String, dynamic> json) {
  return _TableDefinitionModel.fromJson(json);
}

/// @nodoc
mixin _$TableDefinitionModel {
// required String tableName,
  List<ColumnDefinitionModel> get columns => throw _privateConstructorUsedError;

  /// Serializes this TableDefinitionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TableDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableDefinitionModelCopyWith<TableDefinitionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableDefinitionModelCopyWith<$Res> {
  factory $TableDefinitionModelCopyWith(TableDefinitionModel value,
          $Res Function(TableDefinitionModel) then) =
      _$TableDefinitionModelCopyWithImpl<$Res, TableDefinitionModel>;
  @useResult
  $Res call({List<ColumnDefinitionModel> columns});
}

/// @nodoc
class _$TableDefinitionModelCopyWithImpl<$Res,
        $Val extends TableDefinitionModel>
    implements $TableDefinitionModelCopyWith<$Res> {
  _$TableDefinitionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TableDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? columns = null,
  }) {
    return _then(_value.copyWith(
      columns: null == columns
          ? _value.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as List<ColumnDefinitionModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TableDefinitionModelImplCopyWith<$Res>
    implements $TableDefinitionModelCopyWith<$Res> {
  factory _$$TableDefinitionModelImplCopyWith(_$TableDefinitionModelImpl value,
          $Res Function(_$TableDefinitionModelImpl) then) =
      __$$TableDefinitionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ColumnDefinitionModel> columns});
}

/// @nodoc
class __$$TableDefinitionModelImplCopyWithImpl<$Res>
    extends _$TableDefinitionModelCopyWithImpl<$Res, _$TableDefinitionModelImpl>
    implements _$$TableDefinitionModelImplCopyWith<$Res> {
  __$$TableDefinitionModelImplCopyWithImpl(_$TableDefinitionModelImpl _value,
      $Res Function(_$TableDefinitionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TableDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? columns = null,
  }) {
    return _then(_$TableDefinitionModelImpl(
      columns: null == columns
          ? _value._columns
          : columns // ignore: cast_nullable_to_non_nullable
              as List<ColumnDefinitionModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TableDefinitionModelImpl extends _TableDefinitionModel {
  const _$TableDefinitionModelImpl(
      {required final List<ColumnDefinitionModel> columns})
      : _columns = columns,
        super._();

  factory _$TableDefinitionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableDefinitionModelImplFromJson(json);

// required String tableName,
  final List<ColumnDefinitionModel> _columns;
// required String tableName,
  @override
  List<ColumnDefinitionModel> get columns {
    if (_columns is EqualUnmodifiableListView) return _columns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_columns);
  }

  @override
  String toString() {
    return 'TableDefinitionModel(columns: $columns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableDefinitionModelImpl &&
            const DeepCollectionEquality().equals(other._columns, _columns));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_columns));

  /// Create a copy of TableDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableDefinitionModelImplCopyWith<_$TableDefinitionModelImpl>
      get copyWith =>
          __$$TableDefinitionModelImplCopyWithImpl<_$TableDefinitionModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableDefinitionModelImplToJson(
      this,
    );
  }
}

abstract class _TableDefinitionModel extends TableDefinitionModel {
  const factory _TableDefinitionModel(
          {required final List<ColumnDefinitionModel> columns}) =
      _$TableDefinitionModelImpl;
  const _TableDefinitionModel._() : super._();

  factory _TableDefinitionModel.fromJson(Map<String, dynamic> json) =
      _$TableDefinitionModelImpl.fromJson;

// required String tableName,
  @override
  List<ColumnDefinitionModel> get columns;

  /// Create a copy of TableDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableDefinitionModelImplCopyWith<_$TableDefinitionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
