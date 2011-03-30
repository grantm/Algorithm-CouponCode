#!/usr/bin/perl
#
# http://www.crockford.com/wrmg/base32.html
#

use strict;
use warnings;

my %algorithm = (
    a  => \&algorithm_a,                            # the original
    b  => \&algorithm_b,                            # mod 31 instead of 29
    c  => \&algorithm_c,                            # use 5 LSB rather than mod
    d  => \&algorithm_d,                            # rotation + XOR
);
my %symbol_set = (
    A => '0123456789ABCDEFGHJKMNPQRSTVWXYZ',
    B => '0123456789ABCDEFGHJKMNPQRSTVWXZY',       # X & Y swapped
    C => '0123456789ABCDEFGHJKLMNPQRSTVWXY',       # Add L, Drop Z
    D => '0123456789ABCDEFGHJKLMNPQRTUVWXY',       # Add L & U, Drop S & Z
);
my($sym, @sym, $check_sub, %tally, %sully);
my $cuss_words = make_cuss_regex();

foreach my $alg ( sort keys %algorithm) {
    foreach my $set ( sort keys %symbol_set) {

        print "Testing Algorithm $alg with symbol set $set\n";
        $check_sub = $algorithm{$alg};
        $sym       = $symbol_set{$set};
        @sym       = split //, $sym;

        my $total     = 0;
        my $bad_swaps = 0;
        my $bad_reads = 0;
        my $bad_pos   = 0;
        my $cuss      = 0;
        foreach my $x ( @sym ) {
            foreach my $y ( @sym ) {
                foreach my $z ( @sym ) {
                    my $code = "$x$y$z";
                    foreach my $pos (0, 1, 2) {
                        my $pcode = $code . $check_sub->($code, $pos);
                        $total++;
                        $bad_swaps += check_swaps($pcode, $pos);
                        $bad_reads += check_reads($pcode, $pos);
                        $bad_pos   += check_pos($pcode, $pos);
                        $cuss      += check_cuss($pcode, $pos);
                    }
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
        printf(
            "Total bad pos:         %5u ( %5.2f%%)\n",
            $bad_pos, 100 * $bad_pos / $total
        );
        my $rate = sprintf(
            "%4.2f", 100 * ($bad_swaps + $bad_reads + $bad_pos) / $total
        );
        printf("False positive rate:   %s%%\n\n", $rate);
        printf("Total cuss words:      %5u\n", $cuss);

        $tally{$alg}{$set} = $rate;
        $sully{$alg}{$set} = $cuss;
    }
}

# Print accumulated results

print "              ";
print "    Set $_     " foreach ( sort keys %symbol_set );
print "\n";

foreach my $alg ( sort keys %algorithm ) {
    printf("algorithm_%-2s", $alg);
    foreach my $set ( sort keys %symbol_set ) {
        printf("%8s%% (%2u)", $tally{$alg}{$set}, $sully{$alg}{$set});
    }
    print "\n";
}

exit;


sub check_swaps {
    my($orig, $pos) = @_;

    my $bad = 0;
    my($a, $b, $c, $d) = split //, $orig;
    foreach my $code (
        "$b$a$c$d",
        "$a$c$b$d",
        "$a$b$d$c",
    ) {
        next if $code eq $orig;
        if($check_sub->(substr($code, 0, 3), $pos) eq substr($code, 3, 1)) {
            $bad++;
        }
    }
    return $bad;
}


sub check_reads {
    my($orig, $pos) = @_;

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
                    if($check_sub->(substr($code, 0, 3), $pos) eq substr($code, 3, 1)) {
                        $bad++;
                    }
                }
            }
        }
    }
    return $bad;
}


sub check_pos {
    my($orig, $pos) = @_;

    my $bad  = 0;
    my $code = substr($orig, 0, 3);
    foreach my $i ( 0, 1, 2 ) {
        next if $pos == $i;
        if($check_sub->($code, $i) eq substr($orig, 3, 1)) {
            $bad++;
        }
    }
    return $bad;
}


sub check_cuss {
    my($orig, $pos) = @_;

    return 0 unless $orig =~ $cuss_words;
    print "Cuss word: $orig\n";
    return 1;
}


sub make_cuss_regex {
    my $words = join '|', map {
        s/[I1]/[I1]/g;
        s/[O0]/[O0]/g;
        s/[S5]/[S5]/g;
        s/[Z2]/[Z2]/g;
        s/[E3]/[E3]/g;
        $_;
    } map { uc($_) } qw (
        fuck cunt wank wang piss cock shit twat tits fart hell muff dick knob
        arse shag toss slut turd slag crap poop butt feck boob jism jizz
    );

    return qr{\A(?:$words)\z};
}


sub algorithm_a {
    my($data, $pos) = @_;
    my @char = split //, $data;

    my $check = $pos;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = $check * 19 + $k;
    }
    return $sym[ $check % 29 ];
}


sub algorithm_b {
    my($data, $pos) = @_;
    my @char = split //, $data;

    my $check = $pos;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = $check * 19 + $k;
    }
    return $sym[ $check % 31 ];
}


sub algorithm_c {
    my($data, $pos) = @_;
    my @char = split //, $data;

    my $check = $pos;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = $check * 19 + $k;
    }
    return $sym[ $check & 31 ];
}


sub algorithm_d {
    my($data, $pos) = @_;
    my @char = split //, $data;

    my $check = $pos;
    foreach my $i (0..2) {
        my $k = index($sym, $char[$i]);
        $check = ($check + $k) << 3;
        $check = $check ^ ($check >> 4);
    }
    return $sym[ $check & 31 ];
}


