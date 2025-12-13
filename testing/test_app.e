note
	description: "Test application for simple_codec"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests
		do
			create codec.make
			print ("simple_codec test suite%N")
			print ("========================%N%N")

			run_all_tests
		end

feature -- Access

	codec: SIMPLE_CODEC
			-- Codec processor

feature -- Helpers

	assert (a_tag: STRING; a_condition: BOOLEAN)
			-- Check condition and report if false
		do
			if not a_condition then
				print ("ASSERTION FAILED: " + a_tag + "%N")
			end
		end

feature -- Tests

	run_all_tests
			-- Run all test cases
		do
			test_codec_value_scalars
			test_codec_value_array
			test_codec_value_object
			test_fluent_api
			test_format_detection
			test_parse_json
			test_parse_toml
			test_parse_yaml
			test_to_json
			test_to_toml
			test_to_yaml
			test_json_to_toml
			test_toml_to_json

			print ("%N========================%N")
			print ("All tests completed!%N")
		end

	test_codec_value_scalars
			-- Test scalar value creation
		local
			l_null: CODEC_VALUE
			l_bool: CODEC_VALUE
			l_int: CODEC_VALUE
			l_float: CODEC_VALUE
			l_str: CODEC_VALUE
		do
			print ("Test: codec value scalars... ")

			create l_null.make_null
			assert ("null is null", l_null.is_null)

			create l_bool.make_boolean (True)
			assert ("bool is boolean", l_bool.is_boolean)
			assert ("bool value", l_bool.as_boolean = True)

			create l_int.make_integer (42)
			assert ("int is integer", l_int.is_integer)
			assert ("int value", l_int.as_integer = 42)

			create l_float.make_float (3.14)
			assert ("float is float", l_float.is_float)
			assert ("float value", (l_float.as_float - 3.14).abs < 0.001)

			create l_str.make_string ("hello")
			assert ("str is string", l_str.is_string)
			assert ("str value", l_str.as_string.same_string ("hello"))

			print ("PASSED%N")
		end

	test_codec_value_array
			-- Test array value operations
		local
			l_arr: CODEC_VALUE
			l_item: CODEC_VALUE
		do
			print ("Test: codec value array... ")

			create l_arr.make_array
			assert ("is array", l_arr.is_array)
			assert ("empty", l_arr.array_count = 0)

			create l_item.make_integer (1)
			l_arr.array_extend (l_item)
			create l_item.make_integer (2)
			l_arr.array_extend (l_item)
			create l_item.make_integer (3)
			l_arr.array_extend (l_item)

			assert ("count 3", l_arr.array_count = 3)
			assert ("first", l_arr.array_item (1).as_integer = 1)
			assert ("last", l_arr.array_item (3).as_integer = 3)

			print ("PASSED%N")
		end

	test_codec_value_object
			-- Test object value operations
		local
			l_obj: CODEC_VALUE
			l_val: CODEC_VALUE
		do
			print ("Test: codec value object... ")

			create l_obj.make_object
			assert ("is object", l_obj.is_object)
			assert ("empty", l_obj.object_count = 0)

			create l_val.make_string ("John")
			l_obj.object_put (l_val, "name")
			create l_val.make_integer (30)
			l_obj.object_put (l_val, "age")

			assert ("count 2", l_obj.object_count = 2)
			assert ("has name", l_obj.object_has ("name"))
			assert ("has age", l_obj.object_has ("age"))

			if attached l_obj.string_item ("name") as l_name then
				assert ("name value", l_name.same_string ("John"))
			end
			assert ("age value", l_obj.integer_item ("age") = 30)

			print ("PASSED%N")
		end

	test_fluent_api
			-- Test fluent builder API
		local
			l_obj: CODEC_VALUE
		do
			print ("Test: fluent API... ")

			create l_obj.make_object
			l_obj := l_obj.with_string ("name", "test")
			l_obj := l_obj.with_integer ("version", 1)
			l_obj := l_obj.with_boolean ("active", True)
			l_obj := l_obj.with_null ("optional")

			assert ("has name", l_obj.object_has ("name"))
			assert ("has version", l_obj.object_has ("version"))
			assert ("has active", l_obj.object_has ("active"))
			assert ("has optional", l_obj.object_has ("optional"))

			if attached l_obj.object_item ("optional") as l_opt then
				assert ("optional is null", l_opt.is_null)
			end

			print ("PASSED%N")
		end

	test_format_detection
			-- Test format auto-detection
		do
			print ("Test: format detection... ")

			assert ("detect json object", codec.detect_format ("{%"name%": %"test%"}") = codec.Format_json)
			assert ("detect json array", codec.detect_format ("[1, 2, 3]") = codec.Format_json)
			assert ("detect toml", codec.detect_format ("[section]%Nkey = %"value%"") = codec.Format_toml)
			assert ("detect yaml mapping", codec.detect_format ("name: test%Nage: 30") = codec.Format_yaml)
			assert ("detect yaml list", codec.detect_format ("- item1%N- item2") = codec.Format_yaml)
			assert ("detect xml", codec.detect_format ("<?xml version=%"1.0%"?><root/>") = codec.Format_xml)
			assert ("detect xml tag", codec.detect_format ("<root><child/></root>") = codec.Format_xml)

			print ("PASSED%N")
		end

	test_parse_json
			-- Test JSON parsing
		local
			l_result: detachable CODEC_VALUE
		do
			print ("Test: parse JSON... ")

			l_result := codec.parse_json ("{%"name%": %"John%", %"age%": 30}")

			if attached l_result then
				assert ("is object", l_result.is_object)
				if attached l_result.string_item ("name") as l_name then
					assert ("name", l_name.same_string ("John"))
				end
				assert ("age", l_result.integer_item ("age") = 30)
				print ("PASSED%N")
			else
				print ("FAILED: " + codec.errors_as_string + "%N")
			end
		end

	test_parse_toml
			-- Test TOML parsing
		local
			l_result: detachable CODEC_VALUE
			l_text: STRING_32
		do
			print ("Test: parse TOML... ")

			l_text := "name = %"John%"%Nage = 30"
			l_result := codec.parse_toml (l_text)

			if attached l_result then
				assert ("is object", l_result.is_object)
				if attached l_result.string_item ("name") as l_name then
					assert ("name", l_name.same_string ("John"))
				end
				assert ("age", l_result.integer_item ("age") = 30)
				print ("PASSED%N")
			else
				print ("FAILED: " + codec.errors_as_string + "%N")
			end
		end

	test_parse_yaml
			-- Test YAML parsing
		local
			l_result: detachable CODEC_VALUE
			l_text: STRING_32
		do
			print ("Test: parse YAML... ")

			l_text := "name: John%Nage: 30"
			l_result := codec.parse_yaml (l_text)

			if attached l_result then
				assert ("is object", l_result.is_object)
				if attached l_result.string_item ("name") as l_name then
					assert ("name", l_name.same_string ("John"))
				end
				assert ("age", l_result.integer_item ("age") = 30)
				print ("PASSED%N")
			else
				print ("FAILED: " + codec.errors_as_string + "%N")
			end
		end

	test_to_json
			-- Test JSON output
		local
			l_obj: CODEC_VALUE
			l_output: STRING_32
		do
			print ("Test: to JSON... ")

			create l_obj.make_object
			l_obj := l_obj.with_string ("name", "test")
			l_obj := l_obj.with_integer ("version", 1)

			l_output := codec.to_json (l_obj)

			assert ("has name", l_output.has_substring ("%"name%""))
			assert ("has test", l_output.has_substring ("%"test%""))
			assert ("has version", l_output.has_substring ("%"version%""))

			print ("PASSED%N")
		end

	test_to_toml
			-- Test TOML output
		local
			l_obj: CODEC_VALUE
			l_output: STRING_32
		do
			print ("Test: to TOML... ")

			create l_obj.make_object
			l_obj := l_obj.with_string ("name", "test")
			l_obj := l_obj.with_integer ("version", 1)

			l_output := codec.to_toml (l_obj)

			assert ("has name", l_output.has_substring ("name"))
			assert ("has version", l_output.has_substring ("version = 1"))

			print ("PASSED%N")
		end

	test_to_yaml
			-- Test YAML output
		local
			l_obj: CODEC_VALUE
			l_output: STRING_32
		do
			print ("Test: to YAML... ")

			create l_obj.make_object
			l_obj := l_obj.with_string ("name", "test")
			l_obj := l_obj.with_integer ("version", 1)

			l_output := codec.to_yaml (l_obj)

			assert ("has name", l_output.has_substring ("name:"))
			assert ("has version", l_output.has_substring ("version: 1"))

			print ("PASSED%N")
		end

	test_json_to_toml
			-- Test JSON to TOML conversion
		local
			l_json, l_toml: STRING_32
		do
			print ("Test: JSON to TOML... ")

			l_json := "{%"name%": %"test%", %"version%": 1}"
			l_toml := codec.json_to_toml (l_json)

			assert ("has name", l_toml.has_substring ("name"))
			assert ("has version", l_toml.has_substring ("version = 1"))

			print ("PASSED%N")
		end

	test_toml_to_json
			-- Test TOML to JSON conversion
		local
			l_toml, l_json: STRING_32
		do
			print ("Test: TOML to JSON... ")

			l_toml := "name = %"test%"%Nversion = 1"
			l_json := codec.toml_to_json (l_toml)

			assert ("has name", l_json.has_substring ("%"name%""))
			assert ("has version", l_json.has_substring ("%"version%""))

			print ("PASSED%N")
		end

end
