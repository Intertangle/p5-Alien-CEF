package Alien::CEF;
# ABSTRACT: Alien package for Chromium Embedded Framework (CEF) embeddable browser

use strict;
use warnings;

use parent qw(Alien::Base);
use Role::Tiny::With qw( with );

=method resource_path

Returns a C<Str> which contains the absolute path
to the resources directory.

=cut
sub resource_path {
	my ($self) = @_;
	File::Spec->catfile( File::Spec->rel2abs($self->dist_dir) ,
		'Resources' );
}

=method locales_path

Returns a C<Str> which contains the absolute path
to the locales directory.

=cut
sub locales_path {
	my ($self) = @_;
	File::Spec->catfile( File::Spec->rel2abs($self->dist_dir) ,
		'Resources', 'locales' );
}


with 'Alien::Role::Dino';

1;
__END__

=head1 Inline support

This module supports L<Inline's with functionality|Inline/"Playing 'with' Others">.

=head1 SEE ALSO

L<CEF|https://bitbucket.org/chromiumembedded/cef>

L<Repository information|http://project-renard.github.io/doc/development/repo/p5-Alien-CEF/>
