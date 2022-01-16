package App::Wordle::Words;

use 5.10.0;
use strict;
use warnings;
use Carp 'croak';
use base 'Exporter';

our @EXPORT_OK = ('words');

sub words {
    my ($lang) = @_;
    $lang //= 'en-us';
    my $orig_lang = $lang;
    $lang = uc $lang;
    $lang =~ tr/-/_/;
    my $module = __PACKAGE__ . "::$lang";

    eval "require $module" or do {
        my $error = $@;
        croak("Could not load words for '$orig_lang' (tried: $module). $error");
    };
    my $words = $module->can('words');
    unless ($words) {
        croak(
"Loaded '$orig_lang' from $module, but it does not provide a 'words' subroutine"
        );
    }
    my $caller = caller;
    no strict 'refs';
    my %words = map { $_ => 1 } $words->();
    return \%words;
}

1;
