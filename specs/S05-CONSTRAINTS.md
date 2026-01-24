# S05: CONSTRAINTS - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Technical Constraints

### 1. Format-Specific Limitations

#### TOML
- **Constraint:** No null support in TOML
- **Impact:** Null values are omitted in TOML output
- **Mitigation:** Documented behavior

#### XML
- **Constraint:** Not implemented (stub only)
- **Impact:** XML operations return placeholder
- **Mitigation:** Future implementation

### 2. Type Precision
- **Constraint:** Integer vs float determined by parser
- **Impact:** May differ between formats
- **Mitigation:** Use is_integer/is_float to check

### 3. Key Order
- **Constraint:** Object key order preserved via separate list
- **Impact:** Slight memory overhead
- **Mitigation:** Necessary for consistent output

### 4. Circular References
- **Constraint:** No detection of circular references
- **Impact:** Could cause infinite loop in serialization
- **Mitigation:** Don't create circular structures

## Resource Limits

| Resource | Limit | Notes |
|----------|-------|-------|
| Document size | Memory | No explicit limit |
| Nesting depth | Stack | Very deep nesting may fail |
| Key length | No limit | STRING_32 |

## Performance Constraints

| Operation | Expected Time |
|-----------|---------------|
| Parse | O(n) document size |
| Serialize | O(n) value count |
| Convert | O(n) parse + serialize |
