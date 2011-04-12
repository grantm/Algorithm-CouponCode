#!perl -T

use Test::More;

use Algorithm::CouponCode;

ok(1, "Successfully loaded Algorithm::CouponCode via 'use'");

diag( "Testing Algorithm::CouponCode $Algorithm::CouponCode::VERSION, Perl $], $^X" );

done_testing();
