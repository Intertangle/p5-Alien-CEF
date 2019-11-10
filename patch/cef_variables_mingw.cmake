
if(OS_WINDOWS AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GCC")
	set(CEF_LIBTYPE STATIC)
	list(APPEND CEF_CXX_COMPILER_FLAGS
		-Wno-attributes             # The cfi-icall attribute is not supported by the GNU C++ compiler
	)
	list(APPEND CEF_COMPILER_DEFINES
		WIN32 _WIN32 _WINDOWS             # Windows platform
		UNICODE _UNICODE                  # Unicode build
		WINVER=0x0601 _WIN32_WINNT=0x601  # Targeting Windows 7
		NOMINMAX                          # Use the standard's templated min/max
		WIN32_LEAN_AND_MEAN               # Exclude less common API declarations
		_HAS_EXCEPTIONS=0                 # Disable exceptions
	)
	list(APPEND CEF_COMPILER_DEFINES_RELEASE
		NDEBUG _NDEBUG                    # Not a debug build
	)

	# Standard libraries.
	set(CEF_STANDARD_LIBS
		comctl32.lib
		rpcrt4.lib
		shlwapi.lib
		ws2_32.lib
	)

	# CEF directory paths.
	set(CEF_RESOURCE_DIR        "${_CEF_ROOT}/Resources")
	set(CEF_BINARY_DIR          "${_CEF_ROOT}/$<CONFIGURATION>")
	set(CEF_BINARY_DIR_DEBUG    "${_CEF_ROOT}/Debug")
	set(CEF_BINARY_DIR_RELEASE  "${_CEF_ROOT}/Release")

	# CEF library paths.
	set(CEF_LIB_DEBUG   "${CEF_BINARY_DIR_DEBUG}/libcef.lib")
	set(CEF_LIB_RELEASE "${CEF_BINARY_DIR_RELEASE}/libcef.lib")

	# List of CEF binary files.
	set(CEF_BINARY_FILES
		chrome_elf.dll
		d3dcompiler_47.dll
		libcef.dll
		libEGL.dll
		libGLESv2.dll
		natives_blob.bin
		snapshot_blob.bin
		v8_context_snapshot.bin
		swiftshader
	)

	# List of CEF resource files.
	set(CEF_RESOURCE_FILES
		cef.pak
		cef_100_percent.pak
		cef_200_percent.pak
		cef_extensions.pak
		devtools_resources.pak
		icudtl.dat
		locales
	)

	if(USE_SANDBOX)
		list(APPEND CEF_COMPILER_DEFINES
			PSAPI_VERSION=1   # Required by cef_sandbox.lib
			CEF_USE_SANDBOX   # Used by apps to test if the sandbox is enabled
		)

		# Libraries required by cef_sandbox.lib.
		set(CEF_SANDBOX_STANDARD_LIBS
			dbghelp.lib
			Delayimp.lib
			PowrProf.lib
			Propsys.lib
			psapi.lib
			SetupAPI.lib
			version.lib
			wbemuuid.lib
			winmm.lib
		)

		# CEF sandbox library paths.
		set(CEF_SANDBOX_LIB_DEBUG "${CEF_BINARY_DIR_DEBUG}/cef_sandbox.lib")
		set(CEF_SANDBOX_LIB_RELEASE "${CEF_BINARY_DIR_RELEASE}/cef_sandbox.lib")
	endif()
endif()
