# Code Coverage CMake Script. If _COVERALLS_UPLOAD is ON, it will upload gcov json
# data to overalls.io automatically. 

# Param _COVERAGE_SRCS	        A list of coverage source files.
# Param _COVERALLS_UPLOAD       Upload the result to coveralls.
# Param _CMAKE_SCRIPT_PATH      CMake script path.
function(code_coverage _COVERAGE_SRCS _COVERALLS_UPLOAD _CMAKE_SCRIPT_PATH)
    # clean previous gcov data.
    file(REMOVE_RECURSE ${PROJECT_BINARY_DIR}/*.gcda)

    # find curl for upload JSON soon.
    if (_COVERALLS_UPLOAD)
		find_program(CURL_EXECUTABLE curl)
		if (NOT CURL_EXECUTABLE)
			message(FATAL_ERROR "Coveralls: curl not found!")
		endif()
    endif()

	# When passing a CMake list to an external process, the list
	# will be converted from the format "1;2;3" to "1 2 3".
	set(COVERAGE_SRCS "")
	foreach (SINGLE_SRC ${_COVERAGE_SRCS})
		set(COVERAGE_SRCS "${COVERAGE_SRCS}*${SINGLE_SRC}")
	endforeach()

    # coveralls json file.
	set(COVERALLS_FILE ${PROJECT_BINARY_DIR}/coveralls.json)

 	add_custom_target(coveralls_generate
		# Run regress tests.
		COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
		# Generate Gcov and translate it into coveralls JSON.
		COMMAND ${CMAKE_COMMAND}
				-DCOVERAGE_SRCS="${COVERAGE_SRCS}"
				-DCOVERALLS_OUTPUT_FILE="${COVERALLS_FILE}"
				-DCOV_PATH="${PROJECT_BINARY_DIR}"
				-DPROJECT_ROOT="${PROJECT_SOURCE_DIR}"
				-P "${_CMAKE_SCRIPT_PATH}/CoverallsGenerateGcov.cmake"
		WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
		COMMENT "Coveralls: generating coveralls output..."
		)

	if (_COVERALLS_UPLOAD)
		message("COVERALLS UPLOAD: ON")
        # Upload the JSON to coveralls.
		add_custom_target(coveralls_upload
			COMMAND ${CURL_EXECUTABLE}
					-S -F json_file=@${COVERALLS_FILE}
					https://coveralls.io/api/v1/jobs
			DEPENDS coveralls_generate
			WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
			COMMENT "Coveralls: uploading coveralls output...")

		add_custom_target(coveralls DEPENDS coveralls_upload)
	else()
		message("COVERALLS UPLOAD: OFF")
		add_custom_target(coveralls DEPENDS coveralls_generate)
	endif()
endfunction()

set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")

set(LIB_SRC ${PROJECT_SOURCE_DIR}/src/base.c)

code_coverage(
    "${LIB_SRC}" 
    ${COVERALLS_UPLOAD}                 
    "${PROJECT_SOURCE_DIR}/cmake"
)