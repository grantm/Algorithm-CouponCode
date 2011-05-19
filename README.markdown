Algorithm::CouponCode
=====================

This Perl [CPAN module][1]  is used for generating and validating 'CouponCode'
strings.   A 'CouponCode' is a code that will be passed in printed form to
someone who will be expected to type it into a web page or other application.

Coupon Codes are random codes which are easy for the recipient to type
accurately into a web form.  Features of the codes that make them well suited
to manual transcription:

* The codes are not case sensitive.
* Not all letters and numbers are used, so if a person enters the letter 'O' we
  can automatically correct it to the digit '0' (similarly for I => 1, S => 5,
  Z => 2).
* The 4th character of each part is a checkdigit, so client-side scripting can
  be used to highlight parts which have been mis-typed, before the code is even
  submitted to the application's back-end validation.
* The checkdigit algorithm takes into account the position of the part being
  keyed. So for example '1K7Q' might be valid in the first part but not in the
  second so if a user typed the parts in the wrong boxes then their error could
  be highlighted.
* The code generation algorithm avoids 'undesirable' codes. For example any
  code in which transposed characters happen to result in a valid checkdigit
  will be skipped. Any generated part which happens to spell an 'inappropriate'
  4-letter word (e.g.: 'P00P') will also be skipped.

The Algorithm-CouponCode distribution includes a [Javascript implementation][2]
of the validator function, in the form of a jQuery plugin. You can include this
in your web application to do client-side validation and highlighting of
errors.

  [1]: http://search.cpan.org/dist/Algorithm-CouponCode/
  [2]: http://search.cpan.org/dist/Algorithm-CouponCode/html/index.html "search.cpan.org"
