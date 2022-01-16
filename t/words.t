#!/usr/bin/env perl

use 5.10.0;
use strict;
use warnings;
use Test::More;
use App::Wordle::Words 'words';

my $words = words();
ok exists $words->{abase},  'We should be able to import english words';
ok !exists $words->{qqqqq}, '... but not non-existent words';

eval { words('no-such-language') };
my $error = $@ // 'no error';
like $error,
qr{\QCould not load words for 'no-such-language' (tried: App::Wordle::Words::NO_SUCH_LANGUAGE)},
  'Trying to fetch words for a non-existent language should fail';

done_testing;
