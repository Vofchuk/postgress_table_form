enum PostgresDataType {
  // Numeric Types
  smallint,
  integer,
  bigint,
  decimal,
  numeric,
  real,
  doublePrecision,
  serial,
  bigserial,

  // Character Types
  characterVarying,
  character,
  text,

  // Date & Time Types
  date,
  timestamp,
  timestampWithTimeZone,
  time,
  timeWithTimeZone,
  interval,

  // Boolean Type
  boolean,

  // UUID Type
  uuid,

  // JSON Types
  json,
  jsonb,

  // Array Types
  integerArray,
  textArray,
  uuidArray,

  // Geometric Types
  point,
  line,
  lseg,
  box,
  path,
  polygon,
  circle,

  array,

  // Custom Types
  userDefined;

  /// Converts a PostgreSQL data type string to the corresponding enum value.
  ///
  /// This handles the conversion from PostgreSQL's format (e.g., "timestamp with time zone")
  /// to the enum format (e.g., timestampWithTimeZone).
  static PostgresDataType fromString(String typeString) {
    final normalizedType = typeString.trim().toLowerCase();

    // Map of PostgreSQL type strings to enum values
    final typeMap = {
      'array': PostgresDataType.array,
      'smallint': PostgresDataType.smallint,
      'integer': PostgresDataType.integer,
      'int': PostgresDataType.integer,
      'bigint': PostgresDataType.bigint,
      'decimal': PostgresDataType.decimal,
      'numeric': PostgresDataType.numeric,
      'real': PostgresDataType.real,
      'double precision': PostgresDataType.doublePrecision,
      'serial': PostgresDataType.serial,
      'bigserial': PostgresDataType.bigserial,
      'character varying': PostgresDataType.characterVarying,
      'varchar': PostgresDataType.characterVarying,
      'character': PostgresDataType.character,
      'char': PostgresDataType.character,
      'text': PostgresDataType.text,
      'date': PostgresDataType.date,
      'timestamp': PostgresDataType.timestamp,
      'timestamp without time zone': PostgresDataType.timestamp,
      'timestamp with time zone': PostgresDataType.timestampWithTimeZone,
      'time': PostgresDataType.time,
      'time without time zone': PostgresDataType.time,
      'time with time zone': PostgresDataType.timeWithTimeZone,
      'interval': PostgresDataType.interval,
      'boolean': PostgresDataType.boolean,
      'bool': PostgresDataType.boolean,
      'uuid': PostgresDataType.uuid,
      'json': PostgresDataType.json,
      'jsonb': PostgresDataType.jsonb,
      'integer[]': PostgresDataType.integerArray,
      'int[]': PostgresDataType.integerArray,
      'text[]': PostgresDataType.textArray,
      'uuid[]': PostgresDataType.uuidArray,
      'point': PostgresDataType.point,
      'line': PostgresDataType.line,
      'lseg': PostgresDataType.lseg,
      'box': PostgresDataType.box,
      'path': PostgresDataType.path,
      'polygon': PostgresDataType.polygon,
      'circle': PostgresDataType.circle,
      'user-defined': PostgresDataType.userDefined,
    };

    final dataType = typeMap[normalizedType];
    if (dataType == null) {
      throw ArgumentError(
          '`$typeString` is not one of the supported values: ${PostgresDataType.values.join(', ')}');
    }

    return dataType;
  }
}
