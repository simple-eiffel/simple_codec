# S03: CONTRACTS - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Design by Contract Summary

### SIMPLE_CODEC Contracts

#### detect_format
```eiffel
require
    content_not_void: a_content /= Void
```

#### parse
```eiffel
require
    content_not_void: a_content /= Void
```

#### to_json
```eiffel
require
    value_not_void: a_value /= Void
```

#### convert_format
```eiffel
require
    content_not_void: a_content /= Void
    valid_from: a_from >= Format_json and a_from <= Format_xml
    valid_to: a_to >= Format_json and a_to <= Format_xml
```

### CODEC_VALUE Contracts

#### make_string
```eiffel
require
    value_not_void: a_value /= Void
ensure
    is_string: is_string
    value_set: as_string = a_value
```

#### make_array
```eiffel
ensure
    is_array: is_array
    empty: array_count = 0
```

#### as_boolean
```eiffel
require
    is_boolean: is_boolean
```

#### array_item
```eiffel
require
    is_array: is_array
    valid_index: a_index >= 1 and a_index <= array_count
```

#### array_extend
```eiffel
require
    is_array: is_array
    value_not_void: a_value /= Void
ensure
    one_more: array_count = old array_count + 1
```

#### object_put
```eiffel
require
    is_object: is_object
    value_not_void: a_value /= Void
    key_not_void: a_key /= Void
ensure
    has_key: object_has (a_key)
```

### CODEC_VALUE Invariants
```eiffel
invariant
    string_value_not_void: string_value /= Void
    array_items_not_void: array_items /= Void
    object_entries_not_void: object_entries /= Void
    object_keys_not_void: object_keys /= Void
```
