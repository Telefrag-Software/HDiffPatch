include_guard()

function(hdiffpatch_get_version HEADER_FILE OUT_VERSION)
	if(NOT EXISTS "${HEADER_FILE}")
		message(FATAL_ERROR "Version header not found: '${HEADER_FILE}'.")
	endif()

	file(READ "${HEADER_FILE}" _VERSION_FILE_CONTENTS)

	macro(extract_definition DEFINE_NAME OUTPUT_VARIABLE)
		string(REGEX MATCH "#define[ \t]+${DEFINE_NAME}[ \t]+([0-9]+)" _MATCH "${_VERSION_FILE_CONTENTS}")

		if(NOT CMAKE_MATCH_1)
			message(FATAL_ERROR "Failed to extract ${DEFINE_NAME} from ${HEADER_FILE}!")
		endif()

		set(${OUTPUT_VARIABLE} "${CMAKE_MATCH_1}")
	endmacro()

	extract_definition(HDIFFPATCH_VERSION_MAJOR _HDIFFPATCH_MAJOR_VERSION)
	extract_definition(HDIFFPATCH_VERSION_MINOR _HDIFFPATCH_MINOR_VERSION)
	extract_definition(HDIFFPATCH_VERSION_RELEASE _HDIFFPATCH_PATCH_VERSION)

	set(${OUT_VERSION} "${_HDIFFPATCH_MAJOR_VERSION}.${_HDIFFPATCH_MINOR_VERSION}.${_HDIFFPATCH_PATCH_VERSION}" PARENT_SCOPE)
endfunction()
