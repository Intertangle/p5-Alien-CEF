#!/usr/bin/env perl

use Test2::V0;
use Test::Alien;
use Alien::CEF;

subtest 'CEF version' => sub {
	alien_ok 'Alien::CEF';

	my $xs = do { local $/; <DATA> };
	xs_ok {
		xs => $xs,
		verbose => 0,
	}, with_subtest {
		my($module) = @_;
		is $module->version, Alien::CEF->version,
			"Got CEF version @{[ Alien::CEF->version ]}";
	};

};

done_testing;

__DATA__
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "include/cef_version.h"

const char *
version(const char *class)
{
	return CEF_VERSION;
}

MODULE = TA_MODULE PACKAGE = TA_MODULE

const char *version(class);
	const char *class;
