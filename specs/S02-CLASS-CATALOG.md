# S02: CLASS CATALOG - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Class Hierarchy

```
SIMPLE_CODEC (facade)
    |
    +-- uses --> SIMPLE_JSON
    +-- uses --> SIMPLE_TOML
    +-- uses --> SIMPLE_YAML
    |
    +-- produces --> CODEC_VALUE
```

## Class Descriptions

### SIMPLE_CODEC
**Purpose:** Unified API for multiple data formats
**Role:** Parse, serialize, and convert between formats
**Key Features:**

#### Format Detection
- `detect_format` - Auto-detect from content

#### Parsing
- `parse` - Auto-detect and parse
- `parse_json` - Parse JSON
- `parse_toml` - Parse TOML
- `parse_yaml` - Parse YAML
- `parse_xml` - Parse XML (stub)

#### Serialization
- `to_json` - Serialize to JSON
- `to_toml` - Serialize to TOML
- `to_yaml` - Serialize to YAML
- `to_xml` - Serialize to XML (stub)

#### Conversion
- `convert_format` - Generic conversion
- `json_to_toml`, `json_to_yaml` - From JSON
- `toml_to_json`, `toml_to_yaml` - From TOML
- `yaml_to_json`, `yaml_to_toml` - From YAML

#### Factory
- `new_object`, `new_array` - Containers
- `new_string`, `new_integer`, etc. - Scalars

### CODEC_VALUE
**Purpose:** Universal value representation
**Role:** Format-agnostic data structure
**Key Features:**

#### Type Checking
- `is_null`, `is_boolean`, `is_integer`, `is_float`
- `is_string`, `is_array`, `is_object`

#### Scalar Access
- `as_boolean`, `as_integer`, `as_float`, `as_string`

#### Array Operations
- `array_count`, `array_item`, `array_extend`

#### Object Operations
- `object_count`, `object_has`, `object_item`, `object_put`
- `object_keys_list`

#### Fluent API
- `with_string`, `with_integer`, `with_boolean`, etc.
