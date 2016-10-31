#
# Param _COVERAGE_SRCS	A list of source files that coverage should be collected for.
# Param _COVERALLS_UPLOAD Upload the result to coveralls?
#

function(coveralls_setup _COVERAGE_SRCS _COVERALLS_UPLOAD _CMAKE_SCRIPT_PATH)
	# When passing a CMake list to an external process, the list
	# will be converted from the format "1;2;3" to "1 2 3".
	# http://cmake.3232098.n2.nabble.com/Passing-a-CMake-list-quot-as-is-quot-to-a-custom-target-td6505681.html
	set(COVERAGE_SRCS_TMP ${_COVERAGE_SRCS})
	set(COVERAGE_SRCS "")
	foreach (COVERAGE_SRC ${COVERAGE_SRCS_TMP})
		set(COVERAGE_SRCS "${COVERAGE_SRCS}*${COVERAGE_SRC}")
	endforeach()

	set(COVERALLS_FILE ${PROJECT_BINARY_DIR}/coveralls.json)
    file(REMOVE_RECURSE ${PROJECT_BINARY_DIR}/*.gcda)

	add_custom_target(coveralls_generate
		# Run regress tests.
		COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
		# Generate Gcov and translate it into coveralls JSON.
		# We do this by executing an external CMake script.
		# (We don't want this to run at CMake generation time, but after compilation and everything has run).
		COMMAND ${CMAKE_COMMAND}
				-DCOVERAGE_SRCS="${COVERAGE_SRCS}" # TODO: This is passed like: "a b c", not "a;b;c"
				-DCOVERALLS_OUTPUT_FILE="${COVERALLS_FILE}"
				-DCOV_PATH="${PROJECT_BINARY_DIR}"
				-DPROJECT_ROOT="${PROJECT_SOURCE_DIR}"
				-P "${_CMAKE_SCRIPT_PATH}/CoverallsGenerateGcov.cmake"
		WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
		COMMENT "Generating coveralls output..."
		)

	if (_COVERALLS_UPLOAD)
		message("COVERALLS UPLOAD: ON")

		find_program(CURL_EXECUTABLE curl)

		if (NOT CURL_EXECUTABLE)
			message(FATAL_ERROR "Coveralls: curl not found! Aborting")
		endif()

		add_custom_target(coveralls_upload
			# Upload the JSON to coveralls.
			COMMAND ${CURL_EXECUTABLE}
					-S -F json_file=@${COVERALLS_FILE}
					https://coveralls.io/api/v1/jobs

			DEPENDS coveralls_generate

			WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
			COMMENT "Uploading coveralls output...")

		add_custom_target(coveralls DEPENDS coveralls_upload)
	else()
		message("COVERALLS UPLOAD: OFF")
		add_custom_target(coveralls DEPENDS coveralls_generate)
	endif()

endfunction()
