#!/usr/bin/perl
#
# http://www.crockford.com/wrmg/base32.html
#

use strict;
use warnings;

my $sym = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

print gen_code(), "\n" foreach (1..20);

exit;


sub gen_code {
    my @code;
    foreach my $i (0..2) {
        my $str   = '';
        my $check = 0;
        foreach my $j (0..2) {
            my $k = int(rand(32));
            $str .= substr($sym, $k, 1);
            $check = $check * 19 + $k;
        }
        push @code, $str . substr($sym, $check % 29, 1);
    }
    return join '-', @code;
}
