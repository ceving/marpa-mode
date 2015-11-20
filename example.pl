#! /usr/bin/perl

use strict;
use warnings;
use Marpa::R2;
use Data::Dumper;
use File::Map qw(map_file);

map_file my $grammar, 'example.marpa';
map_file my $input, 'example.ddl';

my $marpa = Marpa::R2::Scanless::G->new ({source => \$grammar});

print Dumper($marpa->parse (\$input));
