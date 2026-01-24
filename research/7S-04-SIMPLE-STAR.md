# 7S-04: SIMPLE-STAR - simple_codec


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Ecosystem Integration

### Dependencies on Other simple_* Libraries
- **simple_json** - JSON parsing and serialization
- **simple_toml** - TOML parsing and serialization
- **simple_yaml** - YAML parsing and serialization

### Libraries That May Depend on simple_codec
- **simple_config** - Configuration file handling
- **simple_http** - API request/response bodies
- **simple_oracle** - Data interchange

### Integration Patterns

#### Auto-detect and parse
```eiffel
local
    codec: SIMPLE_CODEC
    value: detachable CODEC_VALUE
do
    create codec.make
    value := codec.parse (content) -- auto-detects format
    if attached value as v then
        if v.is_object then
            across v.object_keys_list as k loop
                print (k + ": " + v.string_item (k))
            end
        end
    end
end
```

#### Format conversion
```eiffel
-- Convert JSON to YAML
yaml_output := codec.json_to_yaml (json_input)

-- Convert TOML to JSON
json_output := codec.toml_to_json (toml_input)
```

## Namespace Conventions
- Main facade: SIMPLE_CODEC
- Value type: CODEC_VALUE
- Format constants: Format_json, Format_toml, etc.
