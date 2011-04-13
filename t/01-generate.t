#!perl -T

use strict;
use warnings;

use Test::More;
use Algorithm::CouponCode qw(cc_generate);


can_ok(__PACKAGE__, 'cc_generate');

my $code1 = cc_generate(plaintext => '1234567890');

ok($code1, 'generated a code from a static plaintext');
like($code1, qr{^[0-9A-Z-]+$}, 'code comprises uppercase letter, digits and dashes');
like($code1, qr{^\w{4}-\w{4}-\w{4}$}, 'pattern is XXXX-XXXX-XXXX');

my $code2 = cc_generate(plaintext => '123456789A');
ok($code2, 'generated a second code from a static plaintext');
like($code2, qr{^[0-9A-Z-]+$}, 'code2 comprises uppercase letter, digits and dashes');
like($code2, qr{^\w{4}-\w{4}-\w{4}$}, 'pattern is XXXX-XXXX-XXXX');

isnt($code1, $code2, 'second code differs from first');

my $code3 = cc_generate(plaintext => '1234567890');
is($code1, $code3, 'third code is same as first');

my $code4 = cc_generate();
my $code5 = cc_generate();
isnt($code4, $code5, 'two codes without plaintexts supplied are different');

is($code1, '1K7Q-CTFM-LMTC', '$code1 is exactly as expected');
is($code2, 'X730-KCV1-MA2G', '$code2 is exactly as expected');

done_testing();
