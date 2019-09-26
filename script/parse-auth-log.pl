#!/usr/bin/perl

use Data::Dumper;

my $a = ();
my $b = ();
my $fh = undef;

open ($fh, "<", (shift));
while (<$fh>) {
	if (/Invalid user (.*) from (.*) port/) {
		push (@{$a->{$1}}, $2);
		push (@{$b->{$2}}, $1);
	}
}
close($fh);

print Dumper($a);
print Dumper($b);
