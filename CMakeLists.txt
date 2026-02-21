cmake_minimum_required(VERSION 3.23 FATAL_ERROR)

cmake_policy(SET CMP0144 NEW)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

include(HDiffPatchVersion)

hdiffpatch_get_version("${CMAKE_CURRENT_SOURCE_DIR}/libHDiffPatch/HPatch/patch_types.h" HDIFFPATCH_VERSION)

if(NOT HDIFFPATCH_VERSION)
	message(FATAL_ERROR "Failed to determine HDiffPatch version from 'patch_types.h' file.")
endif()

option(HUNTER_ENABLED "Enable Hunter package manager support." ON)
option(HDIFFPATCH_BUILD_DIRDIFFPATCH "Build dirDiffPatch sub-library." ON)
option(HDIFFPATCH_BUILD_LIBPARALLEL "Build libParallel sub-library." ON)
option(HDIFFPATCH_BUILD_BSDIFF_WRAPPER "Build bsdiff_wrapper sub-library." ON)
option(HDIFFPATCH_BUILD_VCDIFF_WRAPPER "Build vcdiff_wrapper sub-library." ON)
option(HDIFFPATCH_BUILD_LIBHSYNC "Build libhsync sub-library." ON)
option(HDIFFPATCH_BUILD_UNIT_TESTS "Build HDiffPatch unit test application." OFF)

if(HUNTER_ENABLED)
	include(Hunter/HunterInit)
endif()

project(HDiffPatch VERSION ${HDIFFPATCH_VERSION} LANGUAGES C CXX)

if(HUNTER_ENABLED)
	include(ThirdPartyLibraries)
endif()

set(HDIFFPATCH_LIBRARY_NAME libHDiffPatch)
set(DIRDIFFPATCH_LIBRARY_NAME dirDiffPatch)
set(LIBPARALLEL_LIBRARY_NAME libParallel)
set(BSDIFF_WRAPPER_LIBRARY_NAME bsdiff_wrapper)
set(VCDIFF_WRAPPER_LIBRARY_NAME vcdiff_wrapper)
set(LIBHSYNC_LIBRARY_NAME libhsync)
set(UNIT_TEST_APPLICATION_NAME unit_test)

set(INSTALL_TARGETS
	${HDIFFPATCH_LIBRARY_NAME}
)

add_library(${HDIFFPATCH_LIBRARY_NAME}
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/diff.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/match_block.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/bytes_rle.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/bytes_rle.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/compress_detect.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/compress_detect.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/match_inplace.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/match_inplace.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/mem_buf.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/pack_uint.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/qsort_parallel.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/suffix_string.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/suffix_string.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/config.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/divsufsort.c.inc.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/divsufsort.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/divsufsort.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/divsufsort_private.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/divsufsort64.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/divsufsort64.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/sssort.c.inc.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/libdivsufsort/trsort.c.inc.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/adler_roll.c
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/adler_roll.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/bloom_filter.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/covers.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/digest_matcher.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/digest_matcher.h
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/stream_serialize.cpp
	${HDIFFPATCH_LIBRARY_NAME}/HDiff/private_diff/limit_mem_diff/stream_serialize.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/patch.c
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/patch_private.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_hcache_old_mt.c
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_hcache_old_mt.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_hinput_mt.c
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_hinput_mt.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_houtput_mt.c
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_houtput_mt.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_hpatch_mt.c
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_hpatch_mt.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/_patch_private_mt.h
	${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/hpatch_mt.c
	${HDIFFPATCH_LIBRARY_NAME}/HPatchLite/hpatch_lite.c
)

add_library(${PROJECT_NAME}::${HDIFFPATCH_LIBRARY_NAME} ALIAS ${HDIFFPATCH_LIBRARY_NAME})

target_sources(${HDIFFPATCH_LIBRARY_NAME}
	PUBLIC
		FILE_SET HEADERS
		TYPE HEADERS
		BASE_DIRS
			${CMAKE_CURRENT_SOURCE_DIR}
		FILES
			${HDIFFPATCH_LIBRARY_NAME}/HDiff/diff.h
			${HDIFFPATCH_LIBRARY_NAME}/HDiff/diff_for_hpatch_lite.h
			${HDIFFPATCH_LIBRARY_NAME}/HDiff/diff_types.h
			${HDIFFPATCH_LIBRARY_NAME}/HDiff/match_block.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatch/checksum_plugin.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatch/patch.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatch/patch_types.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatch/hpatch_mt/hpatch_mt.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatchLite/hpatch_lite.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatchLite/hpatch_lite_input_cache.h
			${HDIFFPATCH_LIBRARY_NAME}/HPatchLite/hpatch_lite_types.h
)

target_include_directories(${HDIFFPATCH_LIBRARY_NAME}
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${HDIFFPATCH_LIBRARY_NAME}>
		$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_compile_features(${HDIFFPATCH_LIBRARY_NAME}
	PUBLIC
		c_std_99
		cxx_std_11
)

# TODO: definitions?
# TODO: third party libraries?

if(HDIFFPATCH_BUILD_DIRDIFFPATCH)
	add_library(${DIRDIFFPATCH_LIBRARY_NAME}
		file_for_patch.c
		hpatch_dir_listener.h
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/dir_diff.cpp
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/dir_diff_tools.cpp
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/dir_manifest.cpp
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/dir_patch.c
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/dir_patch_tools.c
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/new_dir_output.c
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/new_stream.c
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/ref_stream.c
		${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/res_handle_limit.c
	)

	add_library(${PROJECT_NAME}::${DIRDIFFPATCH_LIBRARY_NAME} ALIAS ${DIRDIFFPATCH_LIBRARY_NAME})

	target_sources(${DIRDIFFPATCH_LIBRARY_NAME}
		PUBLIC
			FILE_SET HEADERS
			TYPE HEADERS
			BASE_DIRS
				${CMAKE_CURRENT_SOURCE_DIR}
			FILES
				file_for_patch.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/dir_diff.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/dir_diff_tools.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/dir_manifest.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_diff/file_for_dirDiff.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/dir_patch.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/dir_patch_private.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/dir_patch_tools.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/dir_patch_types.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/new_dir_output.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/new_stream.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/ref_stream.h
				${DIRDIFFPATCH_LIBRARY_NAME}/dir_patch/res_handle_limit.h
	)

	target_include_directories(${DIRDIFFPATCH_LIBRARY_NAME}
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${DIRDIFFPATCH_LIBRARY_NAME}>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
	)

	target_compile_features(${DIRDIFFPATCH_LIBRARY_NAME}
		PUBLIC
			c_std_99
			cxx_std_11
	)

	target_link_libraries(${DIRDIFFPATCH_LIBRARY_NAME}
		PUBLIC
			${HDIFFPATCH_LIBRARY_NAME}
	)

	list(APPEND INSTALL_TARGETS
		${DIRDIFFPATCH_LIBRARY_NAME}
	)
endif()

if(HDIFFPATCH_BUILD_LIBPARALLEL)
	add_library(${LIBPARALLEL_LIBRARY_NAME}
		${LIBPARALLEL_LIBRARY_NAME}/parallel_channel.cpp
		${LIBPARALLEL_LIBRARY_NAME}/parallel_import_c.c
	)

	add_library(${PROJECT_NAME}::${LIBPARALLEL_LIBRARY_NAME} ALIAS ${LIBPARALLEL_LIBRARY_NAME})

	target_sources(${LIBPARALLEL_LIBRARY_NAME}
		PUBLIC
			FILE_SET HEADERS
			TYPE HEADERS
			BASE_DIRS
				${CMAKE_CURRENT_SOURCE_DIR}
			FILES
				${LIBPARALLEL_LIBRARY_NAME}/parallel_channel.h
				${LIBPARALLEL_LIBRARY_NAME}/parallel_import.h
				${LIBPARALLEL_LIBRARY_NAME}/parallel_import_c.h
	)

	target_include_directories(${LIBPARALLEL_LIBRARY_NAME}
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${LIBPARALLEL_LIBRARY_NAME}>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
	)

	target_compile_features(${LIBPARALLEL_LIBRARY_NAME}
		PUBLIC
			c_std_99
			cxx_std_11
	)

	target_link_libraries(${LIBPARALLEL_LIBRARY_NAME}
		PUBLIC
			${HDIFFPATCH_LIBRARY_NAME}
	)

	list(APPEND INSTALL_TARGETS
		${LIBPARALLEL_LIBRARY_NAME}
	)
endif()

if(HDIFFPATCH_BUILD_BSDIFF_WRAPPER)
	add_library(${BSDIFF_WRAPPER_LIBRARY_NAME}
		${BSDIFF_WRAPPER_LIBRARY_NAME}/bsdiff_wrapper.cpp
		${BSDIFF_WRAPPER_LIBRARY_NAME}/bspatch_wrapper.c
	)

	add_library(${PROJECT_NAME}::${BSDIFF_WRAPPER_LIBRARY_NAME} ALIAS ${BSDIFF_WRAPPER_LIBRARY_NAME})

	target_sources(${BSDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			FILE_SET HEADERS
			TYPE HEADERS
			BASE_DIRS
				${CMAKE_CURRENT_SOURCE_DIR}
			FILES
				${BSDIFF_WRAPPER_LIBRARY_NAME}/bsdiff_wrapper.h
				${BSDIFF_WRAPPER_LIBRARY_NAME}/bspatch_wrapper.h
	)

	target_include_directories(${BSDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${BSDIFF_WRAPPER_LIBRARY_NAME}>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
	)

	target_compile_features(${BSDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			c_std_99
			cxx_std_11
	)

	target_link_libraries(${BSDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			${HDIFFPATCH_LIBRARY_NAME}
	)

	list(APPEND INSTALL_TARGETS
		${BSDIFF_WRAPPER_LIBRARY_NAME}
	)
endif()

if(HDIFFPATCH_BUILD_VCDIFF_WRAPPER)
	add_library(${VCDIFF_WRAPPER_LIBRARY_NAME}
		${VCDIFF_WRAPPER_LIBRARY_NAME}/vcdiff_wrapper.cpp
		${VCDIFF_WRAPPER_LIBRARY_NAME}/vcpatch_wrapper.c
	)

	add_library(${PROJECT_NAME}::${VCDIFF_WRAPPER_LIBRARY_NAME} ALIAS ${VCDIFF_WRAPPER_LIBRARY_NAME})

	target_sources(${VCDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			FILE_SET HEADERS
			TYPE HEADERS
			BASE_DIRS
				${CMAKE_CURRENT_SOURCE_DIR}
			FILES
				${VCDIFF_WRAPPER_LIBRARY_NAME}/vcdiff_wrapper.h
				${VCDIFF_WRAPPER_LIBRARY_NAME}/vcpatch_code_table.h
				${VCDIFF_WRAPPER_LIBRARY_NAME}/vcpatch_wrapper.h
	)

	target_include_directories(${VCDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${VCDIFF_WRAPPER_LIBRARY_NAME}>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
	)

	target_compile_features(${VCDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			c_std_99
			cxx_std_11
	)

	target_link_libraries(${VCDIFF_WRAPPER_LIBRARY_NAME}
		PUBLIC
			${HDIFFPATCH_LIBRARY_NAME}
	)

	list(APPEND INSTALL_TARGETS
		${VCDIFF_WRAPPER_LIBRARY_NAME}
	)
endif()

if(HDIFFPATCH_BUILD_LIBHSYNC)
	add_library(${LIBHSYNC_LIBRARY_NAME}
		${LIBHSYNC_LIBRARY_NAME}/sign_diff/_match_in_old_sign.cpp
		${LIBHSYNC_LIBRARY_NAME}/sign_diff/sign_diff.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_client/dir_sync_client.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_client/match_in_old.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_client.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_client_private.h
		${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_client_type_private.h
		${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_diff_data.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_info_client.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_make/dir_sync_make.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_make/match_in_new.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_make/sync_info_make.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_make/sync_make.cpp
		${LIBHSYNC_LIBRARY_NAME}/sync_make/sync_make_private.h
		${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_client_type_private.h
		${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_client_wrapper.cpp
		${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_info_client.cpp
		${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_match_in_old.cpp
		${LIBHSYNC_LIBRARY_NAME}/zsync_make_wrapper/zsync_info_make.cpp
		${LIBHSYNC_LIBRARY_NAME}/zsync_make_wrapper/zsync_make_wrapper.cpp
	)

	add_library(${PROJECT_NAME}::${LIBHSYNC_LIBRARY_NAME} ALIAS ${LIBHSYNC_LIBRARY_NAME})

	target_sources(${LIBHSYNC_LIBRARY_NAME}
		PUBLIC
			FILE_SET HEADERS
			TYPE HEADERS
			BASE_DIRS
				${CMAKE_CURRENT_SOURCE_DIR}
			FILES
				${LIBHSYNC_LIBRARY_NAME}/sign_diff/_match_in_old_sign.h
				${LIBHSYNC_LIBRARY_NAME}/sign_diff/_sign_diff_type.h
				${LIBHSYNC_LIBRARY_NAME}/sign_diff/sign_diff.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/dict_decompress_plugin.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/dir_sync_client.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/match_in_old.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/match_in_types.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_client.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_client_type.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_diff_data.h
				${LIBHSYNC_LIBRARY_NAME}/sync_client/sync_info_client.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/dict_compress_plugin.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/dir_sync_make.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/hsynz_plugin.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/match_in_new.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/sync_info_make.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/sync_make.h
				${LIBHSYNC_LIBRARY_NAME}/sync_make/sync_make_hash_clash.h
				${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_client_type.h
				${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_client_wrapper.h
				${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_info_client.h
				${LIBHSYNC_LIBRARY_NAME}/zsync_client_wrapper/zsync_match_in_old.h
				${LIBHSYNC_LIBRARY_NAME}/zsync_make_wrapper/zsync_info_make.h
				${LIBHSYNC_LIBRARY_NAME}/zsync_make_wrapper/zsync_make_wrapper.h
	)

	target_include_directories(${LIBHSYNC_LIBRARY_NAME}
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${LIBHSYNC_LIBRARY_NAME}>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
	)

	target_compile_features(${LIBHSYNC_LIBRARY_NAME}
		PUBLIC
			cxx_std_11
	)

	target_link_libraries(${LIBHSYNC_LIBRARY_NAME}
		PUBLIC
			${HDIFFPATCH_LIBRARY_NAME}
			${DIRDIFFPATCH_LIBRARY_NAME}
			${LIBPARALLEL_LIBRARY_NAME}
	)

	list(APPEND INSTALL_TARGETS
		${LIBHSYNC_LIBRARY_NAME}
	)
endif()

if(HDIFFPATCH_BUILD_UNIT_TESTS)
	if(NOT HDIFFPATCH_BUILD_DIRDIFFPATCH OR NOT HDIFFPATCH_BUILD_LIBPARALLEL OR NOT HDIFFPATCH_BUILD_BSDIFF_WRAPPER OR NOT HDIFFPATCH_BUILD_VCDIFF_WRAPPER OR NOT HDIFFPATCH_BUILD_LIBHSYNC)
		message(FATAL_ERROR "Cannot build unit test application unless all sub-libraries are also enabled.")
	endif()

	if(NOT HUNTER_ENABLED)
		message(FATAL_ERROR "Hunter must be enabled in order to build the unit test application.")
	endif()

	add_executable(${UNIT_TEST_APPLICATION_NAME}
		test/unit_test.cpp
	)

	set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${UNIT_TEST_APPLICATION_NAME})

	target_compile_features(${UNIT_TEST_APPLICATION_NAME}
		PUBLIC
			c_std_99
	)

	target_compile_definitions(${UNIT_TEST_APPLICATION_NAME}
		PRIVATE
			ChecksumPlugin_crc32
			ChecksumPlugin_md5
			ChecksumPlugin_xxh3
			ChecksumPlugin_xxh128
			CompressPlugin_7zXZ
			CompressPlugin_bz2
			CompressPlugin_ldef
			CompressPlugin_ldef_is_use_zlib
			CompressPlugin_lzma
			CompressPlugin_lzma2
			CompressPlugin_zlib
			CompressPlugin_zstd
	)

	target_link_libraries(${UNIT_TEST_APPLICATION_NAME}
		PRIVATE
			BZip2::bz2_static
			LibMD5-RFC::MD5
			SevenZip::SevenZip
			xxHash::xxhash
			ZLIB::ZLIBSTATIC
			zstd::libzstd_static
			${HDIFFPATCH_LIBRARY_NAME}
			${DIRDIFFPATCH_LIBRARY_NAME}
			${LIBPARALLEL_LIBRARY_NAME}
			${BSDIFF_WRAPPER_LIBRARY_NAME}
			${VCDIFF_WRAPPER_LIBRARY_NAME}
			${LIBHSYNC_LIBRARY_NAME}
	)
endif()

include(GNUInstallDirs)

set(CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(VERSION_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}ConfigVersion.cmake")
set(PROJECT_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(NAMESPACE "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
	"${VERSION_CONFIG}" COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
	"cmake/Config.cmake.in"
	"${PROJECT_CONFIG}"
	INSTALL_DESTINATION "${CONFIG_INSTALL_DIR}"
)

install(
	TARGETS ${INSTALL_TARGETS}
	EXPORT "${TARGETS_EXPORT_NAME}"
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	FILE_SET HEADERS
		DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

install(
	FILES "${PROJECT_CONFIG}" "${VERSION_CONFIG}"
	DESTINATION "${CONFIG_INSTALL_DIR}"
)

install(
	EXPORT "${TARGETS_EXPORT_NAME}"
	NAMESPACE "${NAMESPACE}"
	DESTINATION "${CONFIG_INSTALL_DIR}"
)
