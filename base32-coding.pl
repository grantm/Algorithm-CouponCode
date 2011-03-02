#!/usr/bin/perl
#
# http://www.crockford.com/wrmg/base32.html
#

use strict;
use warnings;

my %algorithm = (
    a => \&algorithm_a,                            # the original
    b => \&algorithm_b,                            # mod 31 instead of 29
    c => \&algorithm_c,                            # use 5 LSB rather than mod
    d => \&algorithm_d,                            # rotation + XOR
);
my %symbol_set = (
    A => '0123456789ABCDEFGHJKMNPQRSTVWXYZ',
    B => '0123456789ABCDEFGHJKMNPQRSTVWXZY',       # X & Y swapped
    C => '0123456789ABCDEFGHJKLMNPQRSTVWXY',       # Add L, Drop Z
);
my($sym, @sym, $check_sub, %tally);

foreach my $alg ( sort keys %algorithm) {
    foreach my $set ( sort keys %symbol_set) {

        print "Testing Algorithm $alg with symbol set $set\n";
        $check_sub = $algorithm{$alg};
        $sym       = $symbol_set{$set};
        @sym       = split //, $sym;

        my $total     = 0;
        my $bad_swaps = 0;
        my $bad_reads = 0;
        foreach my $x ( @sym ) {
            foreach my $y ( @sym ) {
                foreach my $z ( @sym ) {
                    my $code = "$x$y$z";
                    $code .= $check_sub->($code);
                    $total++;
                    $bad_swaps += check_swaps($code);
                    $bad_reads += check_reads($code);
                }
            }
        }

        printf("Total codes generated: %5u\n", $total);
        printf(
            "Total bad swaps:       %5u ( %5.2f%%)\n",
            $bad_swaps, 100 * $bad_swaps / $total
        );
        printf(
            "Total bad reads:       %5u ( %5.2f%%)\n",
            $bad_reads, 100 * $bad_reads / $total
        );
        my $rate = sprintf("%4.2f", 100 * ($bad_swaps + $bad_reads) / $total);
        printf("False positive rate:   %s%%\n\n", $rate);

        $tally{$alg}{$set} = $rate;
    }
}

# Print accumulated results

print "          ";
print "    Set $_" foreach ( sort keys %symbol_set );
print "\n";

foreach my $alg ( sort keys %algorithm ) {
    print "algorithm_$alg";
    foreach my $set ( sort keys %symbol_set ) {
        printf("%8s%%", $tally{$alg}{$set});
    }
    print "\n";
}

exit;


sub check_swaps {
    my($orig) = @_;

    my $bad = 0;
    my($a, $b, $c, $d) = split //, $orig;
    foreach my $code (
        "$b$a$c$d",
        "$a$c$b$d",
        "$a$b$d$c",
    ) {
        next if $code eq $orig;
        if($check_sub->(substr($code, 0, 3)) eq substr($code, 3, 1)) {
            $bad++;
        }
    }
    return $bad;
}


sub check_reads {
    my($orig) = @_;

    my @try = map { [ $_ ] } split //, $orig;
    foreach (@try) {
        push @$_, '5' if $_->[0] eq 'S';
        push @$_, 'S' if $_->[0] eq '5';
        push @$_, '2' if $_->[0] eq 'Z';
        push @$_, 'Z' if $_->[0] eq '2';
    }
    return 0 unless grep { @$_ > 1 } @try;
    my $bad = 0;
    foreach my $a ( @{ $try[0] } ) {
        foreach my $b ( @{ $try[1] } ) {
            foreach my $c ( @{ $try[2] } ) {
                foreach my $d ( @{ $try[3] } ) {
                    my $code = "$a$b$c$d";
                    next if $code eq $orig;
                    if($check_sub->(substr($code, 0, 3)) eq substr($code, 3, 1)) {
                        $bad++;
                    }
                }
            }
        }
    }
    return $bad;
}


sub algorithm_a {
    my @char = split //, shift;

    my $check = 0;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = $check * 19 + $k;
    }
    return $sym[ $check % 29 ];
}


sub algorithm_b {
    my @char = split //, shift;

    my $check = 0;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = $check * 19 + $k;
    }
    return $sym[ $check % 31 ];
}


sub algorithm_c {
    my @char = split //, shift;

    my $check = 0;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = $check * 19 + $k;
    }
    return $sym[ $check & 31 ];
}


sub algorithm_d {
    my @char = split //, shift;

    my $check = 0;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = ($check + $k) << 3;
        $check = $check ^ ($check >> 4);
    }
    return $sym[ $check & 31 ];
}


