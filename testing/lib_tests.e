note
	description: "Tests for SIMPLE_CODEC"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test: Format Detection

	test_detect_json_object
			-- Test detecting JSON object format.
		note
			testing: "covers/{SIMPLE_CODEC}.detect_format"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_integers_equal ("json object", codec.Format_json, codec.detect_format ("{%"key%": %"value%"}"))
		end

	test_detect_json_array
			-- Test detecting JSON array format.
		note
			testing: "covers/{SIMPLE_CODEC}.detect_format"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_integers_equal ("json array", codec.Format_json, codec.detect_format ("[1, 2, 3]"))
		end

	test_detect_yaml
			-- Test detecting YAML format.
		note
			testing: "covers/{SIMPLE_CODEC}.detect_format"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_integers_equal ("yaml", codec.Format_yaml, codec.detect_format ("name: value"))
		end

	test_detect_toml
			-- Test detecting TOML format.
		note
			testing: "covers/{SIMPLE_CODEC}.detect_format"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_integers_equal ("toml", codec.Format_toml, codec.detect_format ("key = %"value%""))
		end

	test_detect_xml
			-- Test detecting XML format.
		note
			testing: "covers/{SIMPLE_CODEC}.detect_format"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_integers_equal ("xml", codec.Format_xml, codec.detect_format ("<root>content</root>"))
		end

feature -- Test: Parsing

	test_parse_json
			-- Test parsing JSON content.
		note
			testing: "covers/{SIMPLE_CODEC}.parse_json"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			if attached codec.parse_json ("{%"name%": %"Alice%"}") as v then
				assert_true ("is object", v.is_object)
			else
				assert_false ("has errors", codec.has_errors)
			end
		end

	test_parse_yaml
			-- Test parsing YAML content.
		note
			testing: "covers/{SIMPLE_CODEC}.parse_yaml"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			if attached codec.parse_yaml ("name: Bob") as v then
				assert_true ("is object", v.is_object)
			else
				assert_false ("has errors", codec.has_errors)
			end
		end

	test_parse_toml
			-- Test parsing TOML content.
		note
			testing: "covers/{SIMPLE_CODEC}.parse_toml"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			if attached codec.parse_toml ("name = %"Charlie%"") as v then
				assert_true ("is object", v.is_object)
			else
				assert_false ("has errors", codec.has_errors)
			end
		end

feature -- Test: Serialization

	test_to_json
			-- Test serializing to JSON.
		note
			testing: "covers/{SIMPLE_CODEC}.to_json"
		local
			codec: SIMPLE_CODEC
			value: CODEC_VALUE
		do
			create codec.make
			create value.make_object
			value.with_string ("key", "value").do_nothing
			assert_string_contains ("json output", codec.to_json (value), "key")
		end

feature -- Test: Error Handling

	test_has_errors_initial
			-- Test no errors initially.
		note
			testing: "covers/{SIMPLE_CODEC}.has_errors"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_false ("no initial errors", codec.has_errors)
		end

	test_errors_as_string
			-- Test errors as string.
		note
			testing: "covers/{SIMPLE_CODEC}.errors_as_string"
		local
			codec: SIMPLE_CODEC
		do
			create codec.make
			assert_true ("empty errors", codec.errors_as_string.is_empty)
		end

end
