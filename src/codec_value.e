note
	description: "[
		CODEC_VALUE - Universal value representation.
		Provides format-agnostic data structure that can be serialized to
		JSON, TOML, YAML, or XML.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CODEC_VALUE

create
	make_null,
	make_boolean,
	make_integer,
	make_float,
	make_string,
	make_array,
	make_object

feature {NONE} -- Initialization

	make_null
			-- Create null value
		do
			kind := Kind_null
			create string_value.make_empty
			create array_items.make (0)
			create object_entries.make (0)
			create object_keys.make (0)
		ensure
			is_null: is_null
		end

	make_boolean (a_value: BOOLEAN)
			-- Create boolean value
		do
			kind := Kind_boolean
			boolean_value := a_value
			create string_value.make_empty
			create array_items.make (0)
			create object_entries.make (0)
			create object_keys.make (0)
		ensure
			is_boolean: is_boolean
			value_set: as_boolean = a_value
		end

	make_integer (a_value: INTEGER_64)
			-- Create integer value
		do
			kind := Kind_integer
			integer_value := a_value
			create string_value.make_empty
			create array_items.make (0)
			create object_entries.make (0)
			create object_keys.make (0)
		ensure
			is_integer: is_integer
			value_set: as_integer = a_value
		end

	make_float (a_value: REAL_64)
			-- Create float value
		do
			kind := Kind_float
			float_value := a_value
			create string_value.make_empty
			create array_items.make (0)
			create object_entries.make (0)
			create object_keys.make (0)
		ensure
			is_float: is_float
			value_set: as_float = a_value
		end

	make_string (a_value: STRING_32)
			-- Create string value
		require
			value_not_void: a_value /= Void
		do
			kind := Kind_string
			string_value := a_value
			create array_items.make (0)
			create object_entries.make (0)
			create object_keys.make (0)
		ensure
			is_string: is_string
			value_set: as_string = a_value
		end

	make_array
			-- Create empty array value
		do
			kind := Kind_array
			create string_value.make_empty
			create array_items.make (10)
			create object_entries.make (0)
			create object_keys.make (0)
		ensure
			is_array: is_array
			empty: array_count = 0
		end

	make_object
			-- Create empty object value
		do
			kind := Kind_object
			create string_value.make_empty
			create array_items.make (0)
			create object_entries.make (10)
			create object_keys.make (10)
		ensure
			is_object: is_object
			empty: object_count = 0
		end

feature -- Access

	kind: INTEGER
			-- Value kind

feature -- Type checking

	is_null: BOOLEAN
			-- Is this a null value?
		do
			Result := kind = Kind_null
		end

	is_boolean: BOOLEAN
			-- Is this a boolean value?
		do
			Result := kind = Kind_boolean
		end

	is_integer: BOOLEAN
			-- Is this an integer value?
		do
			Result := kind = Kind_integer
		end

	is_float: BOOLEAN
			-- Is this a float value?
		do
			Result := kind = Kind_float
		end

	is_string: BOOLEAN
			-- Is this a string value?
		do
			Result := kind = Kind_string
		end

	is_array: BOOLEAN
			-- Is this an array value?
		do
			Result := kind = Kind_array
		end

	is_object: BOOLEAN
			-- Is this an object value?
		do
			Result := kind = Kind_object
		end

feature -- Scalar access

	as_boolean: BOOLEAN
			-- Get boolean value
		require
			is_boolean: is_boolean
		do
			Result := boolean_value
		end

	as_integer: INTEGER_64
			-- Get integer value
		require
			is_integer: is_integer
		do
			Result := integer_value
		end

	as_float: REAL_64
			-- Get float value
		require
			is_float: is_float
		do
			Result := float_value
		end

	as_string: STRING_32
			-- Get string value
		require
			is_string: is_string
		do
			Result := string_value
		end

feature -- Array operations

	array_count: INTEGER
			-- Number of array elements
		require
			is_array: is_array
		do
			Result := array_items.count
		end

	array_item (a_index: INTEGER): CODEC_VALUE
			-- Get array element at index (1-based)
		require
			is_array: is_array
			valid_index: a_index >= 1 and a_index <= array_count
		do
			Result := array_items [a_index]
		end

	array_extend (a_value: CODEC_VALUE)
			-- Add element to array
		require
			is_array: is_array
			value_not_void: a_value /= Void
		do
			array_items.extend (a_value)
		ensure
			one_more: array_count = old array_count + 1
		end

feature -- Object operations

	object_count: INTEGER
			-- Number of object entries
		require
			is_object: is_object
		do
			Result := object_entries.count
		end

	object_has (a_key: STRING_32): BOOLEAN
			-- Does object have key?
		require
			is_object: is_object
			key_not_void: a_key /= Void
		do
			Result := object_entries.has (a_key)
		end

	object_item (a_key: STRING_32): detachable CODEC_VALUE
			-- Get object value for key
		require
			is_object: is_object
			key_not_void: a_key /= Void
		do
			Result := object_entries.item (a_key)
		end

	object_put (a_value: CODEC_VALUE; a_key: STRING_32)
			-- Set object entry
		require
			is_object: is_object
			value_not_void: a_value /= Void
			key_not_void: a_key /= Void
		do
			if not object_entries.has (a_key) then
				object_keys.extend (a_key)
			end
			object_entries.force (a_value, a_key)
		ensure
			has_key: object_has (a_key)
		end

	object_keys_list: ARRAYED_LIST [STRING_32]
			-- List of object keys in insertion order
		require
			is_object: is_object
		do
			Result := object_keys.twin
		end

feature -- Convenience accessors

	string_item (a_key: STRING_32): detachable STRING_32
			-- Get string value for key
		require
			is_object: is_object
		do
			if attached object_item (a_key) as l_val and then l_val.is_string then
				Result := l_val.as_string
			end
		end

	integer_item (a_key: STRING_32): INTEGER_64
			-- Get integer value for key (0 if not found)
		require
			is_object: is_object
		do
			if attached object_item (a_key) as l_val and then l_val.is_integer then
				Result := l_val.as_integer
			end
		end

	boolean_item (a_key: STRING_32): BOOLEAN
			-- Get boolean value for key (False if not found)
		require
			is_object: is_object
		do
			if attached object_item (a_key) as l_val and then l_val.is_boolean then
				Result := l_val.as_boolean
			end
		end

feature -- Fluent API

	with_string (a_key, a_value: STRING_32): like Current
			-- Add string entry
		require
			is_object: is_object
		local
			l_val: CODEC_VALUE
		do
			create l_val.make_string (a_value)
			object_put (l_val, a_key)
			Result := Current
		end

	with_integer (a_key: STRING_32; a_value: INTEGER_64): like Current
			-- Add integer entry
		require
			is_object: is_object
		local
			l_val: CODEC_VALUE
		do
			create l_val.make_integer (a_value)
			object_put (l_val, a_key)
			Result := Current
		end

	with_boolean (a_key: STRING_32; a_value: BOOLEAN): like Current
			-- Add boolean entry
		require
			is_object: is_object
		local
			l_val: CODEC_VALUE
		do
			create l_val.make_boolean (a_value)
			object_put (l_val, a_key)
			Result := Current
		end

	with_null (a_key: STRING_32): like Current
			-- Add null entry
		require
			is_object: is_object
		local
			l_val: CODEC_VALUE
		do
			create l_val.make_null
			object_put (l_val, a_key)
			Result := Current
		end

	with_object (a_key: STRING_32; a_value: CODEC_VALUE): like Current
			-- Add object entry
		require
			is_object: is_object
			value_is_object: a_value.is_object
		do
			object_put (a_value, a_key)
			Result := Current
		end

	with_array (a_key: STRING_32; a_value: CODEC_VALUE): like Current
			-- Add array entry
		require
			is_object: is_object
			value_is_array: a_value.is_array
		do
			object_put (a_value, a_key)
			Result := Current
		end

feature {NONE} -- Implementation

	boolean_value: BOOLEAN
	integer_value: INTEGER_64
	float_value: REAL_64
	string_value: STRING_32
	array_items: ARRAYED_LIST [CODEC_VALUE]
	object_entries: HASH_TABLE [CODEC_VALUE, STRING_32]
	object_keys: ARRAYED_LIST [STRING_32]

feature -- Constants

	Kind_null: INTEGER = 0
	Kind_boolean: INTEGER = 1
	Kind_integer: INTEGER = 2
	Kind_float: INTEGER = 3
	Kind_string: INTEGER = 4
	Kind_array: INTEGER = 5
	Kind_object: INTEGER = 6

invariant
	string_value_not_void: string_value /= Void
	array_items_not_void: array_items /= Void
	object_entries_not_void: object_entries /= Void
	object_keys_not_void: object_keys /= Void

end
