# 7S-03: SOLUTIONS - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Existing Solutions Comparison

### 1. Direct format libraries
- **Pros:** Format-specific features
- **Cons:** Different APIs, manual conversion

### 2. Universal data structures (like Python dicts)
- **Pros:** Flexible, any format
- **Cons:** No type safety, not idiomatic Eiffel

### 3. simple_codec (chosen solution)
- **Pros:** Unified API, type-safe, format conversion
- **Cons:** May lose format-specific features

### 4. Protocol Buffers / Cap'n Proto
- **Pros:** Schema-driven, efficient
- **Cons:** Requires schema definition

### 5. XML-centric (convert all to XML)
- **Pros:** Mature tooling
- **Cons:** Verbose, not modern

## Why simple_codec?

1. **Unified API** - Same interface for all formats
2. **Type-safe** - CODEC_VALUE with kind checking
3. **Bidirectional** - Parse and serialize all formats
4. **Auto-detection** - Detect format from content
5. **Conversion** - Any format to any format
6. **Fluent** - Builder pattern for value creation
