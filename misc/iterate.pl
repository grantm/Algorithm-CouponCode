#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin . '/../lib';
use Algorithm::CouponCode qw(cc_generate);

my $i = 0;

while(1) {
    cc_generate(plaintext => $i++);
}

