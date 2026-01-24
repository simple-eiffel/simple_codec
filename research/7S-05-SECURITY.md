# 7S-05: SECURITY - simple_codec


**Date**: 2026-01-23

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Security Considerations

### 1. Parsing Untrusted Data
- **Risk:** Malformed input could cause issues
- **Mitigation:** Underlying parsers handle malformed input
- **Mitigation:** Error list captures parsing failures

### 2. Denial of Service
- **Risk:** Very large documents could exhaust memory
- **Mitigation:** No built-in limits (caller responsibility)

### 3. Type Coercion
- **Risk:** Unexpected type conversions
- **Mitigation:** Explicit type checking via is_* methods

### 4. Format Detection Ambiguity
- **Risk:** Wrong format detected
- **Mitigation:** Use explicit parse_json, parse_toml, etc.

### 5. Information Leakage
- **Risk:** Errors may reveal structure
- **Mitigation:** Error messages are descriptive

## Attack Vectors

| Vector | Likelihood | Impact | Mitigation |
|--------|------------|--------|------------|
| Malformed input | Medium | Low | Error handling |
| Large document | Low | Medium | Caller limits |
| Format confusion | Low | Low | Explicit parsing |

## Recommendations

1. Validate input size before parsing
2. Use explicit format methods when format is known
3. Check has_errors after parsing
4. Validate extracted values before use
