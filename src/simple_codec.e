note
	description: "[
		SIMPLE_CODEC - Unified API for JSON, TOML, YAML, and XML.

		Provides format-agnostic parsing and serialization:
		- Parse any format to CODEC_VALUE
		- Serialize CODEC_VALUE to any format
		- Convert between formats
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_CODEC

create
	make

feature {NONE} -- Initialization

	make
			-- Create codec
		do
			create json
			create toml
			create yaml.make
			create last_errors.make (5)
		end

feature -- Access

	last_errors: ARRAYED_LIST [STRING_32]
			-- Errors from last operation

	has_errors: BOOLEAN
			-- Were there errors?
		do
			Result := not last_errors.is_empty
		end

	errors_as_string: STRING_32
			-- All errors as single string
		do
			create Result.make (100)
			across last_errors as ic loop
				if not Result.is_empty then
					Result.append ("; ")
				end
				Result.append (ic)
			end
		end

feature -- Format detection

	detect_format (a_content: STRING_32): INTEGER
			-- Detect format of content
		require
			content_not_void: a_content /= Void
		local
			l_trimmed: STRING_32
			c: CHARACTER_32
		do
			l_trimmed := a_content.twin
			l_trimmed.left_adjust

			if l_trimmed.is_empty then
				Result := Format_unknown
			else
				c := l_trimmed [1]

				if c = '<' then
					Result := Format_xml
				elseif c = '{' then
					-- JSON object
					Result := Format_json
				elseif c = '[' then
					-- Could be JSON array or TOML section header
					-- TOML sections have format [name] with ]%N following
					if is_toml_section (l_trimmed) then
						Result := Format_toml
					else
						Result := Format_json
					end
				elseif c = '-' and then l_trimmed.count > 1 and then l_trimmed [2] = ' ' then
					-- YAML list item starts with "- "
					Result := Format_yaml
				elseif l_trimmed.starts_with ("---") then
					Result := Format_yaml
				elseif l_trimmed.has_substring (" = ") or l_trimmed.has_substring ("%T= ") then
					Result := Format_toml
				elseif l_trimmed.has_substring (": ") or l_trimmed.has_substring (":%N") then
					Result := Format_yaml
				else
					Result := Format_unknown
				end
			end
		end

	is_toml_section (a_content: STRING_32): BOOLEAN
			-- Is this a TOML section header?
			-- TOML: [section_name] followed by newline or content
			-- JSON: [value1, value2, ...] array with commas
		local
			l_bracket_pos: INTEGER
			l_between: STRING_32
		do
			-- Find closing bracket
			l_bracket_pos := a_content.index_of (']', 2)
			if l_bracket_pos > 2 then
				-- Check what's between [ and ]
				l_between := a_content.substring (2, l_bracket_pos - 1)
				-- JSON arrays have commas or colons inside brackets
				-- TOML sections have just an identifier (alphanumeric, _, ., -)
				if l_between.has (',') or l_between.has (':') or l_between.has ('"') then
					-- This is JSON-like content
					Result := False
				else
					-- TOML section: after ] should be newline, EOF, or comment
					if l_bracket_pos >= a_content.count then
						Result := True
					elseif a_content [l_bracket_pos + 1] = '%N' then
						Result := True
					elseif a_content [l_bracket_pos + 1] = '#' then
						Result := True
					else
						-- Check if content after bracket looks like key = value (TOML)
						Result := a_content.has_substring ("]%N") and then
							(a_content.has_substring (" = ") or a_content.has_substring ("= "))
					end
				end
			end
		end

feature -- Parsing

	parse (a_content: STRING_32): detachable CODEC_VALUE
			-- Parse content (auto-detect format)
		require
			content_not_void: a_content /= Void
		local
			l_format: INTEGER
		do
			l_format := detect_format (a_content)
			inspect l_format
			when Format_json then
				Result := parse_json (a_content)
			when Format_toml then
				Result := parse_toml (a_content)
			when Format_yaml then
				Result := parse_yaml (a_content)
			when Format_xml then
				Result := parse_xml (a_content)
			else
				last_errors.wipe_out
				last_errors.extend ("Unable to detect format")
			end
		end

	parse_json (a_content: STRING_32): detachable CODEC_VALUE
			-- Parse JSON content
		require
			content_not_void: a_content /= Void
		do
			last_errors.wipe_out
			if attached json.decode (a_content) as l_json then
				Result := simple_json_to_codec (l_json)
			else
				across json.last_errors as ic loop
					last_errors.extend (ic.message)
				end
			end
		end

	parse_toml (a_content: STRING_32): detachable CODEC_VALUE
			-- Parse TOML content
		require
			content_not_void: a_content /= Void
		do
			last_errors.wipe_out
			if attached toml.parse (a_content) as l_toml then
				Result := toml_to_codec (l_toml)
			else
				across toml.last_errors as ic loop
					last_errors.extend (ic)
				end
			end
		end

	parse_yaml (a_content: STRING_32): detachable CODEC_VALUE
			-- Parse YAML content
		require
			content_not_void: a_content /= Void
		do
			last_errors.wipe_out
			if attached yaml.parse (a_content) as l_yaml then
				Result := yaml_to_codec (l_yaml)
			else
				across yaml.last_errors as ic loop
					last_errors.extend (ic)
				end
			end
		end

	parse_xml (a_content: STRING_32): detachable CODEC_VALUE
			-- Parse XML content
		require
			content_not_void: a_content /= Void
		do
			last_errors.wipe_out
			last_errors.extend ("XML parsing not yet implemented")
		end

feature -- Serialization

	to_json (a_value: CODEC_VALUE): STRING_32
			-- Serialize to JSON
		require
			value_not_void: a_value /= Void
		local
			l_json: SIMPLE_JSON_VALUE
		do
			l_json := codec_to_simple_json (a_value)
			Result := l_json.to_pretty_json
		end

	to_toml (a_value: CODEC_VALUE): STRING_32
			-- Serialize to TOML
		require
			value_not_void: a_value /= Void
		do
			if attached codec_to_toml (a_value) as l_toml then
				Result := toml.to_toml (l_toml)
			else
				create Result.make_empty
			end
		end

	to_yaml (a_value: CODEC_VALUE): STRING_32
			-- Serialize to YAML
		require
			value_not_void: a_value /= Void
		do
			if attached codec_to_yaml (a_value) as l_yaml then
				Result := yaml.to_yaml (l_yaml)
			else
				create Result.make_empty
			end
		end

	to_xml (a_value: CODEC_VALUE): STRING_32
			-- Serialize to XML
		require
			value_not_void: a_value /= Void
		do
			create Result.make_from_string ("<!-- XML not yet implemented -->")
		end

feature -- Conversion

	convert_format (a_content: STRING_32; a_from, a_to: INTEGER): STRING_32
			-- Convert content from one format to another
		require
			content_not_void: a_content /= Void
			valid_from: a_from >= Format_json and a_from <= Format_xml
			valid_to: a_to >= Format_json and a_to <= Format_xml
		local
			l_value: detachable CODEC_VALUE
		do
			inspect a_from
			when Format_json then l_value := parse_json (a_content)
			when Format_toml then l_value := parse_toml (a_content)
			when Format_yaml then l_value := parse_yaml (a_content)
			when Format_xml then l_value := parse_xml (a_content)
			else
				l_value := Void
			end

			if attached l_value as lv then
				inspect a_to
				when Format_json then Result := to_json (lv)
				when Format_toml then Result := to_toml (lv)
				when Format_yaml then Result := to_yaml (lv)
				when Format_xml then Result := to_xml (lv)
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

	json_to_toml (a_json: STRING_32): STRING_32
		do
			Result := convert_format (a_json, Format_json, Format_toml)
		end

	json_to_yaml (a_json: STRING_32): STRING_32
		do
			Result := convert_format (a_json, Format_json, Format_yaml)
		end

	toml_to_json (a_toml: STRING_32): STRING_32
		do
			Result := convert_format (a_toml, Format_toml, Format_json)
		end

	toml_to_yaml (a_toml: STRING_32): STRING_32
		do
			Result := convert_format (a_toml, Format_toml, Format_yaml)
		end

	yaml_to_json (a_yaml: STRING_32): STRING_32
		do
			Result := convert_format (a_yaml, Format_yaml, Format_json)
		end

	yaml_to_toml (a_yaml: STRING_32): STRING_32
		do
			Result := convert_format (a_yaml, Format_yaml, Format_toml)
		end

feature -- Factory

	new_object: CODEC_VALUE
		do
			create Result.make_object
		end

	new_array: CODEC_VALUE
		do
			create Result.make_array
		end

	new_string (a_value: STRING_32): CODEC_VALUE
		do
			create Result.make_string (a_value)
		end

	new_integer (a_value: INTEGER_64): CODEC_VALUE
		do
			create Result.make_integer (a_value)
		end

	new_float (a_value: REAL_64): CODEC_VALUE
		do
			create Result.make_float (a_value)
		end

	new_boolean (a_value: BOOLEAN): CODEC_VALUE
		do
			create Result.make_boolean (a_value)
		end

	new_null: CODEC_VALUE
		do
			create Result.make_null
		end

feature {NONE} -- JSON conversion

	simple_json_to_codec (a_json: SIMPLE_JSON_VALUE): CODEC_VALUE
		require
			json_not_void: a_json /= Void
		local
			l_obj: SIMPLE_JSON_OBJECT
			l_arr: SIMPLE_JSON_ARRAY
			i: INTEGER
		do
			if a_json.is_null then
				create Result.make_null
			elseif a_json.is_boolean then
				create Result.make_boolean (a_json.as_boolean)
			elseif a_json.is_integer then
				create Result.make_integer (a_json.as_integer)
			elseif a_json.is_number then
				create Result.make_float (a_json.as_real)
			elseif a_json.is_string then
				create Result.make_string (a_json.as_string_32)
			elseif a_json.is_array then
				create Result.make_array
				l_arr := a_json.as_array
				from i := 1 until i > l_arr.count loop
					if attached l_arr.item (i) as l_item then
						Result.array_extend (simple_json_to_codec (l_item))
					end
					i := i + 1
				end
			elseif a_json.is_object then
				create Result.make_object
				l_obj := a_json.as_object
				across l_obj.keys as ic loop
					if attached l_obj.item (ic) as l_val then
						Result.object_put (simple_json_to_codec (l_val), ic)
					end
				end
			else
				create Result.make_null
			end
		end

	codec_to_simple_json (a_codec: CODEC_VALUE): SIMPLE_JSON_VALUE
		require
			codec_not_void: a_codec /= Void
		local
			l_obj: SIMPLE_JSON_OBJECT
			l_arr: SIMPLE_JSON_ARRAY
			i: INTEGER
		do
			if a_codec.is_null then
				Result := json.null_value
			elseif a_codec.is_boolean then
				Result := json.boolean_value (a_codec.as_boolean)
			elseif a_codec.is_integer then
				Result := json.integer_value (a_codec.as_integer)
			elseif a_codec.is_float then
				Result := json.number_value (a_codec.as_float)
			elseif a_codec.is_string then
				Result := json.string_value (a_codec.as_string)
			elseif a_codec.is_array then
				l_arr := json.new_array
				from i := 1 until i > a_codec.array_count loop
					l_arr := l_arr.add_value (codec_to_simple_json (a_codec.array_item (i)))
					i := i + 1
				end
				Result := l_arr
			elseif a_codec.is_object then
				l_obj := json.new_object
				across a_codec.object_keys_list as ic loop
					if attached a_codec.object_item (ic) as l_val then
						l_obj := l_obj.put_value (codec_to_simple_json (l_val), ic)
					end
				end
				Result := l_obj
			else
				Result := json.null_value
			end
		end

feature {NONE} -- TOML conversion

	toml_to_codec (a_toml: TOML_VALUE): CODEC_VALUE
		require
			toml_not_void: a_toml /= Void
		local
			l_table: TOML_TABLE
			l_arr: TOML_ARRAY
			i: INTEGER
		do
			if a_toml.is_boolean then
				create Result.make_boolean (a_toml.as_boolean)
			elseif a_toml.is_integer then
				create Result.make_integer (a_toml.as_integer)
			elseif a_toml.is_float then
				create Result.make_float (a_toml.as_float)
			elseif a_toml.is_string then
				create Result.make_string (a_toml.as_string)
			elseif a_toml.is_array then
				create Result.make_array
				l_arr := a_toml.as_array
				from i := 1 until i > l_arr.count loop
					Result.array_extend (toml_to_codec (l_arr.item (i)))
					i := i + 1
				end
			elseif a_toml.is_table then
				create Result.make_object
				l_table := a_toml.as_table
				across l_table.keys as ic loop
					if attached l_table.item (ic) as l_val then
						Result.object_put (toml_to_codec (l_val), ic)
					end
				end
			else
				create Result.make_null
			end
		end

	codec_to_toml (a_codec: CODEC_VALUE): TOML_TABLE
		require
			codec_not_void: a_codec /= Void
		do
			Result := toml.new_table
			if a_codec.is_object then
				across a_codec.object_keys_list as ic loop
					if attached a_codec.object_item (ic) as l_val then
						codec_value_to_toml_entry (Result, ic, l_val)
					end
				end
			end
		end

	codec_value_to_toml_entry (a_table: TOML_TABLE; a_key: STRING_32; a_value: CODEC_VALUE)
		require
			table_not_void: a_table /= Void
			key_not_void: a_key /= Void
			value_not_void: a_value /= Void
		local
			l_sub_table: TOML_TABLE
			l_arr: TOML_ARRAY
			i: INTEGER
		do
			if a_value.is_null then
				-- TOML does not support null
			elseif a_value.is_boolean then
				a_table.put (create {TOML_BOOLEAN}.make (a_value.as_boolean), a_key)
			elseif a_value.is_integer then
				a_table.put (create {TOML_INTEGER}.make (a_value.as_integer), a_key)
			elseif a_value.is_float then
				a_table.put (create {TOML_FLOAT}.make (a_value.as_float), a_key)
			elseif a_value.is_string then
				a_table.put (create {TOML_STRING}.make (a_value.as_string), a_key)
			elseif a_value.is_array then
				create l_arr.make
				from i := 1 until i > a_value.array_count loop
					l_arr.extend (codec_to_toml_value (a_value.array_item (i)))
					i := i + 1
				end
				a_table.put (l_arr, a_key)
			elseif a_value.is_object then
				l_sub_table := toml.new_table
				across a_value.object_keys_list as ic loop
					if attached a_value.object_item (ic) as l_val then
						codec_value_to_toml_entry (l_sub_table, ic, l_val)
					end
				end
				a_table.put (l_sub_table, a_key)
			end
		end

	codec_to_toml_value (a_codec: CODEC_VALUE): TOML_VALUE
		require
			codec_not_void: a_codec /= Void
		local
			l_arr: TOML_ARRAY
			l_table: TOML_TABLE
			i: INTEGER
		do
			if a_codec.is_boolean then
				create {TOML_BOOLEAN} Result.make (a_codec.as_boolean)
			elseif a_codec.is_integer then
				create {TOML_INTEGER} Result.make (a_codec.as_integer)
			elseif a_codec.is_float then
				create {TOML_FLOAT} Result.make (a_codec.as_float)
			elseif a_codec.is_string then
				create {TOML_STRING} Result.make (a_codec.as_string)
			elseif a_codec.is_array then
				create l_arr.make
				from i := 1 until i > a_codec.array_count loop
					l_arr.extend (codec_to_toml_value (a_codec.array_item (i)))
					i := i + 1
				end
				Result := l_arr
			elseif a_codec.is_object then
				l_table := toml.new_table
				across a_codec.object_keys_list as ic loop
					if attached a_codec.object_item (ic) as l_val then
						codec_value_to_toml_entry (l_table, ic, l_val)
					end
				end
				Result := l_table
			else
				create {TOML_STRING} Result.make ("")
			end
		end

feature {NONE} -- YAML conversion

	yaml_to_codec (a_yaml: YAML_VALUE): CODEC_VALUE
		require
			yaml_not_void: a_yaml /= Void
		local
			l_mapping: YAML_MAPPING
			l_seq: YAML_SEQUENCE
			i: INTEGER
		do
			if a_yaml.is_null then
				create Result.make_null
			elseif a_yaml.is_boolean then
				create Result.make_boolean (a_yaml.as_boolean)
			elseif a_yaml.is_integer then
				create Result.make_integer (a_yaml.as_integer)
			elseif a_yaml.is_float then
				create Result.make_float (a_yaml.as_float)
			elseif a_yaml.is_string then
				create Result.make_string (a_yaml.as_string)
			elseif a_yaml.is_sequence then
				create Result.make_array
				l_seq := a_yaml.as_sequence
				from i := 1 until i > l_seq.count loop
					Result.array_extend (yaml_to_codec (l_seq.item (i)))
					i := i + 1
				end
			elseif a_yaml.is_mapping then
				create Result.make_object
				l_mapping := a_yaml.as_mapping
				across l_mapping.keys as ic loop
					if attached l_mapping.item (ic) as l_val then
						Result.object_put (yaml_to_codec (l_val), ic)
					end
				end
			else
				create Result.make_null
			end
		end

	codec_to_yaml (a_codec: CODEC_VALUE): YAML_VALUE
		require
			codec_not_void: a_codec /= Void
		local
			l_mapping: YAML_MAPPING
			l_seq: YAML_SEQUENCE
			i: INTEGER
		do
			if a_codec.is_null then
				create {YAML_NULL} Result.make
			elseif a_codec.is_boolean then
				create {YAML_BOOLEAN} Result.make (a_codec.as_boolean)
			elseif a_codec.is_integer then
				create {YAML_INTEGER} Result.make (a_codec.as_integer)
			elseif a_codec.is_float then
				create {YAML_FLOAT} Result.make (a_codec.as_float)
			elseif a_codec.is_string then
				create {YAML_STRING} Result.make (a_codec.as_string)
			elseif a_codec.is_array then
				create l_seq.make
				from i := 1 until i > a_codec.array_count loop
					l_seq.extend (codec_to_yaml (a_codec.array_item (i)))
					i := i + 1
				end
				Result := l_seq
			elseif a_codec.is_object then
				create l_mapping.make
				across a_codec.object_keys_list as ic loop
					if attached a_codec.object_item (ic) as l_val then
						l_mapping.put (codec_to_yaml (l_val), ic)
					end
				end
				Result := l_mapping
			else
				create {YAML_NULL} Result.make
			end
		end

feature {NONE} -- Implementation

	json: SIMPLE_JSON
	toml: SIMPLE_TOML
	yaml: SIMPLE_YAML

feature -- Format constants

	Format_unknown: INTEGER = 0
	Format_json: INTEGER = 1
	Format_toml: INTEGER = 2
	Format_yaml: INTEGER = 3
	Format_xml: INTEGER = 4

end
