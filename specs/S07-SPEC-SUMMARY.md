# S07: SPEC SUMMARY - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Executive Summary

simple_codec provides a unified API for parsing, serializing, and converting between multiple data formats (JSON, TOML, YAML). It uses a universal value type (CODEC_VALUE) that can represent any structured data.

## Key Design Decisions

### 1. Universal Value Type
CODEC_VALUE can hold any value - null, scalar, array, or object.

### 2. Format Agnostic
Same CODEC_VALUE works with all formats; format-specific features abstracted.

### 3. Auto-Detection
`parse` method auto-detects format from content structure.

### 4. Fluent Builders
CODEC_VALUE supports fluent API for easy value construction.

### 5. Key Order Preservation
Object keys maintain insertion order for consistent serialization.

## Class Summary

| Class | Purpose | Lines |
|-------|---------|-------|
| SIMPLE_CODEC | Format operations | 657 |
| CODEC_VALUE | Value representation | 411 |

## Feature Summary

- **Detection:** Auto-detect format from content
- **Parsing:** JSON, TOML, YAML (XML stub)
- **Serialization:** JSON, TOML, YAML (XML stub)
- **Conversion:** Any format to any format
- **Factory:** Create values programmatically
- **Fluent:** Builder pattern for objects

## Contract Coverage

- Parsing requires non-void content
- Serialization requires non-void value
- Type access requires correct type check
- Array operations require is_array
- Object operations require is_object
- Invariants ensure storage validity
