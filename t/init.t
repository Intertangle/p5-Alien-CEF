#!/usr/bin/env perl

use Test2::V0;
use Test::Alien;
use Alien::CEF;

subtest 'CEF init' => sub {
	alien_ok 'Alien::CEF';

	my $xs = do { local $/; <DATA> };
	xs_ok {
		xs => $xs,
		verbose => 0,
	}, with_subtest {
		my($module) = @_;
		is $module->init(
			Alien::CEF->resource_path,
			Alien::CEF->locales_path,
		), 0,
			"Initialised CEF";
	};

};

done_testing;
__DATA__

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "include/capi/cef_base_capi.h"
#include "include/capi/cef_app_capi.h"

int
init(
	const char* class,
	const char* resource_path,
	const char* locales_path ) {

	// Main args.
	cef_main_args_t main_args = {};
	main_args.argc = 1;

	char* argv[1];
	argv[0] = "perl";

	main_args.argv = argv;

	cef_app_t* app = NULL;

	// Execute subprocesses. It is also possible to have
	// a separate executable for subprocesses by setting
	// cef_settings_t.browser_subprocess_path. In such
	// case cef_execute_process should not be called here.
	printf("cef_execute_process, argc=%d\n", main_args.argc);
	int code = cef_execute_process(&main_args, app, NULL);
	if (code >= 0) {
		return code;
	}

	// Application settings. It is mandatory to set the
	// "size" member.
	cef_settings_t settings = {};
	settings.size = sizeof(cef_settings_t);
	settings.log_severity = LOGSEVERITY_WARNING; // Show only warnings/errors
	settings.no_sandbox = 1;

	cef_string_t cef_resource_path = {};
	cef_string_t cef_locales_path = {};
	cef_string_utf8_to_utf16(resource_path, strlen(resource_path), &cef_resource_path);
	cef_string_utf8_to_utf16(locales_path, strlen(locales_path), &cef_locales_path);
	settings.resources_dir_path = cef_resource_path;
	settings.locales_dir_path = cef_locales_path;

	// Initialize CEF.
	printf("cef_initialize\n");
	cef_initialize(&main_args, &settings, app, NULL);

	// Shutdown CEF
	printf("cef_shutdown\n");
	cef_shutdown();

    return 0;
}

MODULE = TA_MODULE PACKAGE = TA_MODULE

int init(class, resource_path, locales_path )
	const char *class;
	const char* resource_path;
	const char* locales_path;
