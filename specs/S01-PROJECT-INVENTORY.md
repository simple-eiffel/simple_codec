# S01: PROJECT INVENTORY - simple_codec

**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Library:** simple_codec

## Project Structure

```
simple_codec/
    src/
        simple_codec.e          -- Main facade
        codec_value.e           -- Universal value type
    testing/
        test_app.e              -- Test application
        lib_tests.e             -- Test suite
    research/
        7S-01-SCOPE.md
        7S-02-STANDARDS.md
        7S-03-SOLUTIONS.md
        7S-04-SIMPLE-STAR.md
        7S-05-SECURITY.md
        7S-06-SIZING.md
        7S-07-RECOMMENDATION.md
    specs/
        S01-PROJECT-INVENTORY.md
        S02-CLASS-CATALOG.md
        S03-CONTRACTS.md
        S04-FEATURE-SPECS.md
        S05-CONSTRAINTS.md
        S06-BOUNDARIES.md
        S07-SPEC-SUMMARY.md
        S08-VALIDATION-REPORT.md
    simple_codec.ecf            -- Project configuration
```

## File Inventory

| File | Type | Lines | Purpose |
|------|------|-------|---------|
| simple_codec.e | Source | 657 | Main codec class |
| codec_value.e | Source | 411 | Value representation |
| test_app.e | Test | ~50 | Test runner |
| lib_tests.e | Test | ~150 | Test cases |

## External Dependencies

| Dependency | Type | Purpose |
|------------|------|---------|
| simple_json | Library | JSON support |
| simple_toml | Library | TOML support |
| simple_yaml | Library | YAML support |
| EiffelBase | Library | Core classes |
