#!perl -T

use strict;
use warnings;

use Try::Tiny;
use Test::More;
use Algorithm::CouponCode qw(cc_validate);


can_ok(__PACKAGE__, 'cc_validate');

ok(!cc_validate(), 'missing code failed validation');
ok( cc_validate(code => '1K7Q-CTFM-LMTC'), 'valid code was accepted');
ok(!cc_validate(code => '1K7Q-CTFM'), 'short code was rejected');

ok( cc_validate(code => '1K7Q-CTFM', parts => 2),
    "but accepted with correct 'parts'");

ok(!cc_validate(code => 'CTFM-1K7Q', parts => 2),
    "parts must be in correct order");

is( cc_validate(code => '1k7q-ctfm-lmtc'), '1K7Q-CTFM-LMTC',
    "lowercase code is fixed and valid");

is(cc_validate(code => 'I9oD-V467-8D52'), '190D-V467-8D52', "'o' is fixed to '0'");
is(cc_validate(code => 'I9oD-V467-8D52'), '190D-V467-8D52', "'O' is fixed to '0'");
is(cc_validate(code => 'i9oD-V467-8D52'), '190D-V467-8D52', "'i' is fixed to '1'");
is(cc_validate(code => 'i9oD-V467-8D52'), '190D-V467-8D52', "'I' is fixed to '1'");
is(cc_validate(code => 'i9oD-V467-8D5z'), '190D-V467-8D52', "'z' is fixed to '2'");
is(cc_validate(code => 'i9oD-V467-8D5z'), '190D-V467-8D52', "'Z' is fixed to '2'");
is(cc_validate(code => 'i9oD-V467-8Dsz'), '190D-V467-8D52', "'s' is fixed to '5'");
is(cc_validate(code => 'i9oD-V467-8Dsz'), '190D-V467-8D52', "'S' is fixed to '5'");

is(cc_validate(code => 'i9oD/V467/8Dsz'), '190D-V467-8D52',
    "alternative separator is accepted and fixed");

is(cc_validate(code => ' i9oD V467 8Dsz '), '190D-V467-8D52',
    "whitespace is accepted and fixed");

is(cc_validate(code => ' i9oD_V467_8Dsz '), '190D-V467-8D52',
    "underscores are accepted and fixed");

is(cc_validate(code => 'i9oDV4678Dsz'), '190D-V467-8D52',
    "no separator is required");

ok( cc_validate(code => '1K7Q', parts => 1), 'valid code-pretest');
ok(!cc_validate(code => '1K7C', parts => 1),
    'invalid checkdigit was rejected in part 1');

ok( cc_validate(code => '1K7Q-CTFM', parts => 2), 'valid code-pretest');
ok(!cc_validate(code => '1K7Q-CTFW', parts => 2),
    'invalid checkdigit was rejected in part 2');

ok( cc_validate(code => '1K7Q-CTFM-LMTC', parts => 3), 'valid code-pretest');
ok(!cc_validate(code => '1K7Q-CTFM-LMT1', parts => 3),
    'invalid checkdigit was rejected in part 3');

ok( cc_validate(code => '7YQH-1FU7-E1HX-0BG9', parts => 4),
    'valid code-pretest');
ok(!cc_validate(code => '7YQH-1FU7-E1HX-0BGP', parts => 4),
    'invalid checkdigit was rejected in part 4');

ok( cc_validate(code => 'YENH-UPJK-PTE0-20U6-QYME', parts => 5),
    'valid code-pretest');
ok(!cc_validate(code => 'YENH-UPJK-PTE0-20U6-QYMT', parts => 5),
    'invalid checkdigit was rejected in part 5');

ok( cc_validate(code => 'YENH-UPJK-PTE0-20U6-QYME-RBK1', parts => 6),
    'valid code-pretest');
ok(!cc_validate(code => 'YENH-UPJK-PTE0-20U6-QYME-RBK2', parts => 6),
    'invalid checkdigit was rejected in part 6');

done_testing;
