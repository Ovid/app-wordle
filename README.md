# NAME

App::Wordle - Perl CLI implementation of wordle (https://www.powerlanguage.co.uk/wordle/)

# VERSION

version 0.1

# SYNOPSIS

```perl
use App::Wordle;
App::Wordle->run;
```

# DESCRIPTION

The `bin/wordle` script can be installed in your `$PATH` (automatic if you install
this package) and you can run this directly:

```
$ wordle
```

# HOW TO PLAY

You have six tries to guess a five-letter word. For every guess, if you have a
correct letter in the correct position, it will show up as bright green on black.

If you have a correct letter in the wrong position, it will show up as bright
red on black.

If you have an incorrect letter, it will show up as bright white on black.

# LIMITATIONS

This does not run properly on Windows (due to the color codes).

The wordlist can be found in `App::Wordle::Words::EN_US` and is somewhat
limited.  I tried using a standard wordlist from `/usr/dict/words`, but it
had too many words that I've never heard of, making the game unreasonably
hard. I've chosen a simpler word list, but it's missing many common words.

# DISCLAIMER

There appears to be no copyright on Wordle, or restrictions on its usage. The
name of this package may change if that turns out to not be the case.

# AUTHOR

Curtis "Ovid" Poe <ovid@allaroundtheworld.fr>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2022 by Curtis "Ovid" Poe.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
