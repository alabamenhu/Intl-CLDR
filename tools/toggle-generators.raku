#!/usr/bin/env perl6
# Yes, I'm fully aware this could probably be a one liner.
sub MAIN($on-off where any <on off>) {

    say "This script will potentially rewrite EVERY file in lib/Intl/CLDR/Types";
    my $answer = prompt "Type 'yes' to proceed: ";
    say "You didn't say 'yes' to this.  I'm guessing you're going to make backups first."
        and exit
            unless $answer eq 'yes';

    # The following are codes that we are looking for.
    # - The multiline comment is enabled when it has a single starting # (because #`< starts a comment)
    #   and is turned off with two (because ##`< is just a regular fully commented out line).
    # - The multiline comment is enabled (and terminates) without any # (because > will finish it)
    #   but is turned off with a single # (because #> is just a fully commented out line).
    # - The message text can be changed by editing $new-start
    my $gen-orig   = $on-off eq 'on' ?? ''  !! '#';
    my $gen-new    = $on-off eq 'on' ?? '#' !! '';
    my $find-start = /^ $gen-orig '#`<<<<<' \h* '#' \h* 'GENERATOR'/; # some files may have different spacing
    my $find-end   = /^ $gen-orig '>>>>>' \h* '#' \h* 'GENERATOR'/;
    my $new-start  = $gen-new ~ '#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.';
    my $new-end    = $gen-new ~ '>>>>># GENERATOR';

    # Collect all type files
    my @files = $*PROGRAM
                .parent(2)
                .add('lib/Intl/CLDR/Types')
                .dir: test => /[pm6|rakumod]$/;

    for @files -> $file {
        my @new;
        my $changed = False;

        for $file.lines -> $line {
            if    $line ~~ $find-start { @new.push: $new-start; $changed = True }
            elsif $line ~~ $find-end   { @new.push: $new-end;   $changed = True }
            else                       { @new.push: $line                       }
        }

        $file.spurt: @new.join("\n")
            if $changed;
    }
}
