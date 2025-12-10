# simple_codec

Unified API for encoding/decoding structured data across multiple formats (JSON, TOML, YAML, XML).

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Planned** - Design document available at [simple_codec_design.md](https://github.com/simple-eiffel/claude_eiffel_op_docs/blob/main/designs/simple_codec_design.md)

## Overview

Instead of learning four different APIs, developers use one common interface with format-specific backends:

```eiffel
codec: SIMPLE_CODEC
data: CODEC_VALUE

create codec

-- Parse any format (auto-detected from extension)
data := codec.parse_file ("config.toml")
data := codec.parse_file ("config.json")
data := codec.parse_file ("config.yaml")

-- Same API regardless of source
name := data.string_item ("name")

-- Convert between formats
codec.to_file (data, "output.json", {CODEC_FORMAT}.json)
```

## Dependencies

- simple_json (JSON backend)
- simple_toml (TOML backend)
- simple_yaml (YAML backend)
- simple_xml (XML backend)

## License

MIT License
