#!/usr/bin/env perl6
use File::Find;

sub MAIN($version!) {
    use META6;

    my %provides;
    my @resources;

    my $lib = $?FILE.IO.parent(2).add('lib');

    my $prefix-length = $lib.Str.chars - 3; # -3 because '…/lib', we must preserve the 'lib'
    for find(dir => $lib, name => /'.pm6'$/) -> $sub-module {
        my $file = $sub-module.Str.substr($prefix-length);
        my $name = $file.substr(4, *-4).subst('/','::', :g);
        %provides{$name} = $file;
    }

    my $bin-data = $?FILE.IO.parent.add('languages-binary');
    my $res-prefix-length = $bin-data.Str.chars - 16; # -16 because '…/languages-binary')

    for find(dir => $bin-data) -> $lang-file {
        @resources.push: $lang-file.Str.substr($res-prefix-length)
            unless $lang-file.Str.contains('.DS_Store'); # I hate you macOS
    }

    use META6;


    my $meta6 = META6.new:
        name => 'Intl::CLDR',
        description => 'A module providing access to the Unicode Common Language Data Repository',
        version => Version.new($version),
        depends => <
            Intl::LanguageTag
            Intl::UserLanguage
            DateTime::Timezones
        >,
        tags => <CLDR international localization language>,
        license => 'Artistic-2.0',
        api => '1',
        source-url => 'git://github.com/alabamenhu/Intl-CLDR.git',
        support => META6::Support.new(
            source => 'https://github.com/alabamenhu/META6.git'
        ),
        auth => 'github:alabamenhu',
        perl-version => Version.new('6.d+'),
        raku-version => Version.new('6.d+'),
        authors => [
            'Matthew ‘Matéu’ Stephen STUCKWISCH <mateu@softastur.com>'
        ],
        auth => 'git:alabamenhu',
        :%provides,
        :@resources;

    $?FILE.IO.parent.parent.add("META6.json").spurt: $meta6.to-json(:sorted-keys), :close;

    say "Created META6 file for v$version successfully";
}