#!perl -T

use strict;
use warnings;

use Test::More;
use Algorithm::CouponCode qw(cc_validate cc_generate);

foreach my $i (1..1000) {
    my $code = cc_generate(parts => 1);
    my $label = sprintf("transposition test %04u '%s' =>", $i, $code);
    my($a, $b, $c, $d) = split //, $code;
    ok( cc_validate(code => "$a$b$c$d", parts => 1),
        "$label '$a$b$c$d' is valid");

    foreach my $trans ( "$b$a$c$d", "$a$c$b$d", "$a$b$d$c" ) {
        next if $trans eq $code;  # swapped characters were the same
        ok(!cc_validate(code => $trans, parts => 1),
            "$label '$trans' is not valid");
    }
}

done_testing;
