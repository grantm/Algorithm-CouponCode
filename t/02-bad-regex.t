#!perl -T

use strict;
use warnings;

use Test::More;
use Algorithm::CouponCode qw(make_bad_regex cc_generate);

can_ok(__PACKAGE__, 'make_bad_regex');

my $regex1 = make_bad_regex();

isa_ok($regex1, 'Regexp');

like('P00P', $regex1, "regex1 matches 'P00P'");
unlike('P00P1E', $regex1, "regex1 does not match 'P00P1E'");
like('POOP', $regex1, "regex1 matches 'POOP'");
like('B00B', $regex1, "regex1 matches 'B00B'");

unlike('F0RD', $regex1, "regex1 does not match 'F0RD'");

my $regex2 = make_bad_regex(mode => 'add', words => [ 'FORD', 'FIAT' ]);

like('F0RD', $regex2, "regex2 matches 'F0RD'");
like('F1AT', $regex2, "regex2 matches 'F1AT'");
like('P00P', $regex2, "regex2 matches 'P00P'");

my $regex3 = make_bad_regex(mode => 'replace', words => [ 'FORD', 'FIAT' ]);

like('F0RD', $regex3, "regex3 matches 'F0RD'");
like('F1AT', $regex3, "regex3 matches 'F1AT'");
unlike('P00P', $regex3, "regex3 does not match 'P00P'");

my $code1 = cc_generate(plaintext => '4803', bad_regex => $regex3);
like($code1, qr/B00B/, 'a bad word slipped through $regex3');

my $code2 = cc_generate(plaintext => '4803');
unlike($code2, qr/B00B/, 'but not through default regex');

my $code3 = cc_generate(plaintext => '4803', bad_regex => $regex2);
unlike($code3, qr/B00B/, 'and not through default $regex2');

done_testing();

