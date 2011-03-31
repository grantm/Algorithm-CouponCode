package Algorithm::CouponCode;

use warnings;
use strict;

=head1 NAME

Algorithm::CouponCode - Generate and validate 'CouponCode' strings

=cut

our $VERSION = '1.000';


sub cc_generate {
}


sub cc_validate {
}


1;
__END__

=pod

=head1 SYNOPSIS

  use Algorithm::CouponCode qw(cc_generate cc_validate);

  print cc_generate(parts => 3);  # generate a 3-part code

  try {
      cc_validate(code => $code, parts => 3);
  } catch {
      warn "Coupon Code not valid: $_";
  };

=head1 DESCRIPTION

A 'Coupon Code' is made up of letters and numbers grouped into 4 character
'parts'.  For example, a 3-part code might look like this:

  T8FE-AYHW-1JP0

Coupon Codes are random codes which are easy for the recipient to type
accurately into a web form.  An example application might be to print a code on
a letter to a customer who would then enter the code as part of the
registration process for web access to their account.

Features of the codes that make them well suited to manual transcription:

=over 4

=item *

The codes are not case sensitive.

=item *

Not all letters and numbers are used, so if a person enters the letter 'O' we
can automatically correct it to the digit '0' (similarly for I => 1, S => 5, Z
=> 2).

=item *

The 4th character of each part is a checkdigit, so client-side scripting can
be used to highlight parts which have been mis-typed, before the code is even
submitted to the application's back-end validation.

=item *

The checkdigit algorithm takes into account the position of the part being
keyed.  So for example 1X3E might be valid in the first part but not in the
second so if a user typed the parts in the wrong boxes then their error could
be highlighted.

=item *

The code generation algorithm avoids 'undesirable' codes. For example any code
in which transposed characters happen to result in a valid checkdigit will be
skipped.  Any generated part which happens to spell an 'inappropriate' 4-letter
word (e.g.: 'P00P') will also be skipped.

=back

The Algorithm-CouponCode distribution includes a Javascript implementation of
the validator function, in the form of a jQuery plugin.  You can include this
in your web application to do client-side validation and highlighting of
errors.

=head2 Randomness and Uniqueness

The code returned by C<cc_generate()> is random, but not necessarily unique.
If your application requires unique codes, it is your responsibility to
avoid duplicates (for example by using a unique index on your database column).

The codes are generated using a SHA1 cryptographic hash of a plaintext.  If you
do not supply a plaintext, one will be generated for you (using /dev/urandom if
available or Perl's C<rand()> function otherwise).  In the event that an
'inappropriate' code is created, the generated hash will be used as a
plaintext input for generating a new hash and the process will be repeated.

Each 4-character part encodes 15 bits of randomness, so a 3-part code will
incorporate 45 bits making a total of 2^45 (approximately 35 trillion) unique
codes.


=head1 EXPORTS

The following functions can be exported from the C<Algorithm::CouponCode>
module. No functions are exported by default.

=head2 cc_generate( options )

Returns a coupon code as a string of 4-character parts separated by '-'
characters.  The following optional named parameters may be supplied:

=over 4

=item parts

The number of parts desired.  Must be a number in the range 1 - 6.  Default is
3.

=item plaintext

A byte string which will be hashed using L<Digest::SHA1> to produce the code.
If you do not supply your own plaintext then a random one will be generated for
you.

=item bad_regex

You can supply a regular expression for matching 4-letter words which should
not appear in generated output.  The C<make_bad_regex()> helper function can
be used to turn a list of words into a suitable regular expression.

=back

=head2 cc_validate( options )

Takes a code and validates the checkdigits.  Returns true on success or throws
an exception on error.  The following named parameters may be supplied:

=over 4

=item code

The code to be validated.  The parameter is mandatory.

=item parts

The number of parts you expect the code to contain.  Default is 3.

=back

=head2 make_bad_regex( options )

This function is used to compile a list of 4-letter words into a regular
expression suitable for passing to the C<cc_generate()> function.  You would
only need to do this if you wished to augment or replace the default list of
undesirable words.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Algorithm::CouponCode

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm::CouponCode>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Algorithm::CouponCode>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Algorithm::CouponCode>

=item * Search CPAN

L<http://search.cpan.org/dist/Algorithm::CouponCode/>

=back


=head1 COPYRIGHT AND LICENSE

Copyright 2011 Grant McLean C<< <grantm@cpan.org> >>

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
