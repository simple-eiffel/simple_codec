# 7S-01: SCOPE - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Problem Domain

Unified data serialization and format conversion. Applications often need to work with multiple data formats (JSON, TOML, YAML, XML), and converting between them is tedious and error-prone.

## Target Users

- Developers working with configuration files
- Applications reading multiple data formats
- Tools converting between formats
- APIs accepting multiple input formats

## Boundaries

### In Scope
- Unified value representation (CODEC_VALUE)
- Format detection (auto-detect from content)
- JSON parsing and serialization
- TOML parsing and serialization
- YAML parsing and serialization
- Format conversion (any-to-any)
- Factory methods for value creation

### Out of Scope
- XML parsing (placeholder only)
- Binary formats (MessagePack, BSON, etc.)
- Schema validation
- Streaming parsing
- Custom format plugins
- Format-specific features (TOML datetime, YAML anchors)

## Dependencies

- simple_json (JSON operations)
- simple_toml (TOML operations)
- simple_yaml (YAML operations)
