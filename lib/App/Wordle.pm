package App::Wordle;

# ABSTRACT: Perl CLI implementation of wordle (https://www.powerlanguage.co.uk/wordle/)

use 5.10.0;
use strict;
use warnings;
use Term::ANSIColor 'colored';
use Carp 'croak';
use App::Wordle::Words 'words';

use constant NUM_GUESSES => 6;

sub run {
    binmode( STDOUT, ":encoding(UTF-8)" );
    my ( undef, $lang ) = @_;
    my $words = words($lang);
    my $word  = get_word($words);

    my $count = 0;
  ROUND: while (1) {
        $count++;
        if ( $count > NUM_GUESSES ) {
            my $word =
              play_again( $lang, $word,
                "You lose! The word was '$word'. Play again?" )
              or return;
            $count = 0;
            next ROUND;
        }

        my $guess = get_guess($words);
        my ( $result, $matches ) = match( $word, $guess );
        my $left      = NUM_GUESSES - $count;
        my $remaining = sprintf "You have %d guesses left" => $left;
        say $left ? "$result ($remaining)" : $result;

        if ( NUM_GUESSES == $matches ) {
            my $word =
              play_again( $lang, $word,
                "You win! The word was '$word'. Play again?" )
              or return;
            $count = 0;
            next ROUND;
        }
    }
}

sub play_again {
    my ( $lang, $word, $message ) = @_;

    my $continue = get_yes_no($message);
    if ($continue) {
        return get_word( words($lang) );
    }
    else {
        say "Thank you for playing! Good-bye";
        return;
    }
}

sub get_yes_no {
    my $message = shift;
    print "$message (y/N) ";
    my $response = input();
    return $response =~ /^y/;
}

sub match {
    my ( $word, $guess ) = @_;

    my @word  = split // => $word;
    my @guess = split // => $guess;
    my %is_character = map { $_ => 1 } @word;
    unless ( @word == @guess ) {
        croak("PANIC: '$word' and '$guess' lengths do not match.");
    }
    my $result  = '';
    my $matches = 0;
    foreach my $i ( 0 .. 4 ) {
        my $w = $word[$i];
        my $g = $guess[$i];
        if ( $w eq $g ) {
            $result .= colored( ['bright_green on_black'], $g );
            $matches += 1;
        }
        elsif ( $is_character{$g} ) {
            $result .= colored( ['bright_red on_black'], $g );
        }
        else {
            $result .= colored( ['bright_white on_black'], $g );
        }
        $result .= ' ';
    }
    return ( $result, $matches );
}

sub input {
    chomp( my $response = <STDIN> );
    return lc $response;
}

sub get_word {
    my $words       = shift;
    my @words       = keys %$words;
    my $word        = $words[ rand @words ];
    unless ( $word =~ /^[[:alpha:]]{5}$/ ) {
        croak("PANIC: Word from word list isn't five letters: '$word'");
    }
    return $word;
}

sub get_guess {
    my $words = shift;
    my $guess;
  GUESS: while ( !$guess ) {
        print "Enter your guess: ";
        $guess = input();
        next GUESS unless $guess;
        my $length = length($guess);
        if ( 5 != $length ) {
            say
"Guess must be exactly five letters long, not '$guess'. $length letter(s).";
            undef $guess;
            next GUESS;
        }
        elsif ( !exists $words->{$guess} ) {
            say "That word isn't in my dictionary.";
            undef $guess;
            next GUESS;
        }
    }
    return $guess;
}

1;

__END__

=head1 SYNOPSIS

    use App::Wordle;
    App::Wordle->run;

=head1 DESCRIPTION

The C<bin/wordle> script can be installed in your C<$PATH> (automatic if you install
this package) and you can run this directly:

    $ wordle

=head1 HOW TO PLAY

You have six tries to guess a five-letter word. For every guess, if you have a
correct letter in the correct position, it will show up as bright green on black.

If you have a correct letter in the wrong position, it will show up as bright
red on black.

If you have an incorrect letter, it will show up as bright white on black.

=head1 LIMITATIONS

This does not run properly on Windows (due to the color codes).

The wordlist can be found in C<App::Wordle::Words::EN_US> and is somewhat
limited.  I tried using a standard wordlist from C</usr/dict/words>, but it
had too many words that I've never heard of, making the game unreasonably
hard. I've chosen a simpler word list, but it's missing many common words.

=head1 DISCLAIMER

There appears to be no copyright on Wordle, or restrictions on its usage. The
name of this package may change if that turns out to not be the case.
