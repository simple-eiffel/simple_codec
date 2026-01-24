# 7S-02: STANDARDS - simple_codec


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Applicable Standards

### JSON (ECMA-404, RFC 8259)
- Objects: `{key: value, ...}`
- Arrays: `[value, ...]`
- Strings, numbers, booleans, null

### TOML (Tom's Obvious Minimal Language)
- Version: 1.0
- Tables: `[section]`
- Key-value: `key = "value"`
- No null support

### YAML (YAML Ain't Markup Language)
- Version: 1.2
- Mappings, sequences, scalars
- Null support via `null` or `~`

### XML (Extensible Markup Language)
- Placeholder only - not implemented

## Format Detection Rules

| Pattern | Detected Format |
|---------|-----------------|
| Starts with `<` | XML |
| Starts with `{` | JSON object |
| Starts with `[` + has commas | JSON array |
| Starts with `[` + newline after `]` | TOML section |
| Contains ` = ` | TOML |
| Starts with `---` | YAML |
| Contains `: ` | YAML |

## Type Mapping

| Concept | JSON | TOML | YAML | CODEC_VALUE |
|---------|------|------|------|-------------|
| Object | object | table | mapping | is_object |
| Array | array | array | sequence | is_array |
| String | string | string | string | is_string |
| Integer | number | integer | integer | is_integer |
| Float | number | float | float | is_float |
| Boolean | boolean | boolean | boolean | is_boolean |
| Null | null | N/A | null | is_null |
