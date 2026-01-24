# S04: FEATURE SPECS - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Feature Specifications

### SIMPLE_CODEC - Format Detection

| Feature | Signature | Description |
|---------|-----------|-------------|
| detect_format | (content: STRING_32): INTEGER | Auto-detect format |
| is_toml_section | (content: STRING_32): BOOLEAN | Check TOML section |

### SIMPLE_CODEC - Parsing

| Feature | Signature | Description |
|---------|-----------|-------------|
| parse | (content: STRING_32): detachable CODEC_VALUE | Auto-parse |
| parse_json | (content: STRING_32): detachable CODEC_VALUE | Parse JSON |
| parse_toml | (content: STRING_32): detachable CODEC_VALUE | Parse TOML |
| parse_yaml | (content: STRING_32): detachable CODEC_VALUE | Parse YAML |
| parse_xml | (content: STRING_32): detachable CODEC_VALUE | Parse XML (stub) |

### SIMPLE_CODEC - Serialization

| Feature | Signature | Description |
|---------|-----------|-------------|
| to_json | (value: CODEC_VALUE): STRING_32 | To JSON |
| to_toml | (value: CODEC_VALUE): STRING_32 | To TOML |
| to_yaml | (value: CODEC_VALUE): STRING_32 | To YAML |
| to_xml | (value: CODEC_VALUE): STRING_32 | To XML (stub) |

### SIMPLE_CODEC - Conversion

| Feature | Signature | Description |
|---------|-----------|-------------|
| convert_format | (content: STRING_32; from, to: INTEGER): STRING_32 | Generic |
| json_to_toml | (json: STRING_32): STRING_32 | JSON to TOML |
| json_to_yaml | (json: STRING_32): STRING_32 | JSON to YAML |
| toml_to_json | (toml: STRING_32): STRING_32 | TOML to JSON |
| toml_to_yaml | (toml: STRING_32): STRING_32 | TOML to YAML |
| yaml_to_json | (yaml: STRING_32): STRING_32 | YAML to JSON |
| yaml_to_toml | (yaml: STRING_32): STRING_32 | YAML to TOML |

### SIMPLE_CODEC - Factory

| Feature | Signature | Description |
|---------|-----------|-------------|
| new_object | : CODEC_VALUE | Create object |
| new_array | : CODEC_VALUE | Create array |
| new_string | (value: STRING_32): CODEC_VALUE | Create string |
| new_integer | (value: INTEGER_64): CODEC_VALUE | Create integer |
| new_float | (value: REAL_64): CODEC_VALUE | Create float |
| new_boolean | (value: BOOLEAN): CODEC_VALUE | Create boolean |
| new_null | : CODEC_VALUE | Create null |

### CODEC_VALUE - Type Checking

| Feature | Signature | Description |
|---------|-----------|-------------|
| is_null | : BOOLEAN | Is null? |
| is_boolean | : BOOLEAN | Is boolean? |
| is_integer | : BOOLEAN | Is integer? |
| is_float | : BOOLEAN | Is float? |
| is_string | : BOOLEAN | Is string? |
| is_array | : BOOLEAN | Is array? |
| is_object | : BOOLEAN | Is object? |

### CODEC_VALUE - Fluent API

| Feature | Signature | Description |
|---------|-----------|-------------|
| with_string | (key, value: STRING_32): like Current | Add string |
| with_integer | (key: STRING_32; value: INTEGER_64): like Current | Add integer |
| with_boolean | (key: STRING_32; value: BOOLEAN): like Current | Add boolean |
| with_null | (key: STRING_32): like Current | Add null |
| with_object | (key: STRING_32; value: CODEC_VALUE): like Current | Add object |
| with_array | (key: STRING_32; value: CODEC_VALUE): like Current | Add array |
