#!/usr/bin/env perl6
# Yes, I'm fully aware this could be a one liner.
my $resources = $*PROGRAM.parent.sibling('resources');

my $list  = $resources.add('language-list.data');
my @files = $resources.add('languages-binary').dir;
my @data  = @files.grep(*.extension eq    'data').map(*.basename.substr: 0,*-5);
my @strs  = @files.grep(*.extension eq 'strings').map(*.basename.substr: 0,*-8);
my $safe  = @data ∩ @strs; # Ensure we have data and strings to include

$list.spurt: $safe.keys.sort.join("\n");
say "There are {$safe.elems} languages available.";
say "List of languages written to $list";

exit;