include_guard()

hunter_config(BZip2
	URL "https://github.com/Telefrag-Software/bzip2/archive/refs/heads/hunter-1.1.0.1.zip"
	VERSION "1.1.0.1"
	SHA1 "e5c848657e22f7e59165feee281b31aa15d2268d"
	CMAKE_ARGS
		ENABLE_APP=OFF
		ENABLE_TESTS=OFF
		ENABLE_DOCS=OFF
		ENABLE_EXAMPLES=OFF
		ENABLE_STATIC_LIB=ON
		ENABLE_SHARED_LIB=OFF
		ENABLE_STATIC_LIB_IS_PIC=ON
)

hunter_config(LibMD5-RFC
	URL "https://codeload.github.com/Telefrag-Software/LibMD5-RFC/zip/tags/2002.04.13"
	VERSION "2002.04.13"
	SHA1 "220c033a1d12d4337416e7025171234fd9feeb8f"
	CMAKE_ARGS
		BUILD_APPLICATION=OFF
)

hunter_config(SevenZip
	URL "https://github.com/Telefrag-Software/7-Zip/archive/refs/heads/hunter-21.7.0.3.zip"
	VERSION "21.7.0.3"
	SHA1 "7c1c5c7fbea2da100ca99ae3cdbdfc263a1457b0"
	CMAKE_ARGS
		BUILD_CPP_LIB=OFF
)

hunter_config(xxHash
	URL "https://codeload.github.com/Cyan4973/xxHash/zip/tags/v0.8.3"
	VERSION "0.8.3"
	SHA1 "98c8ffb8d67f8b94e3f4d64d4680e4c77c0bc200"
	CMAKE_ARGS
		BUILD_SHARED_LIBS=OFF
		XXHASH_BUILD_XXHSUM=OFF
)

hunter_config(ZLIB
	URL "https://github.com/Telefrag-Software/zlib/archive/refs/heads/hunter-1.3.1.2.zip"
	VERSION "1.3.1.2"
	SHA1 "0a8b433ea1eac928a1dfaff3f533dfba61b3aeb9"
	CMAKE_ARGS
		ZLIB_BUILD_TESTING=OFF
		ZLIB_BUILD_SHARED=OFF
		ZLIB_BUILD_STATIC=ON
		ZLIB_BUILD_MINIZIP=OFF
		ZLIB_INSTALL=ON
		ZLIB_PREFIX=OFF
		ZLIB_INSTALL_DOCS=OFF
		ZLIB_INSTALL_LICENSES=OFF
)

hunter_config(zstd
	URL "https://codeload.github.com/facebook/zstd/zip/tags/v1.5.7"
	VERSION "1.5.7.0"
	SHA1 "8bd73c3d2bf87f0c033299f5d05fb4bde2480ad1"
	CMAKE_ARGS
		ZSTD_LEGACY_SUPPORT=OFF
		ZSTD_MULTITHREAD_SUPPORT=ON
		ZSTD_BUILD_PROGRAMS=OFF
		ZSTD_BUILD_CONTRIB=OFF
		ZSTD_PROGRAMS_LINK_SHARED=OFF
		ZSTD_BUILD_TESTS=OFF
		ZSTD_USE_STATIC_RUNTIME=ON
		ZSTD_ENABLE_CXX=ON
)
