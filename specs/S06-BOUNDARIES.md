# S06: BOUNDARIES - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## API Boundaries

### Public Interface

#### SIMPLE_CODEC
- `make` - Constructor
- Format detection
- All parsing methods
- All serialization methods
- All conversion methods
- All factory methods
- `last_errors`, `has_errors`, `errors_as_string`
- Format constants

#### CODEC_VALUE
- All constructors (make_*)
- All type checking (is_*)
- All scalar access (as_*)
- All array operations
- All object operations
- All fluent API methods
- Kind constants

### Internal Interface (NONE)

#### SIMPLE_CODEC
- `simple_json_to_codec` - JSON value conversion
- `codec_to_simple_json` - Reverse conversion
- `toml_to_codec` - TOML value conversion
- `codec_to_toml` - Reverse conversion
- `yaml_to_codec` - YAML value conversion
- `codec_to_yaml` - Reverse conversion
- `json`, `toml`, `yaml` - Parser instances

#### CODEC_VALUE
- Storage attributes (boolean_value, integer_value, etc.)

## Integration Points

| Component | Interface | Direction |
|-----------|-----------|-----------|
| simple_json | Library API | Both |
| simple_toml | Library API | Both |
| simple_yaml | Library API | Both |
| Caller code | Public API | Inbound |

## Format Constant Values

| Constant | Value |
|----------|-------|
| Format_unknown | 0 |
| Format_json | 1 |
| Format_toml | 2 |
| Format_yaml | 3 |
| Format_xml | 4 |
