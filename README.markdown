CouponCode
==========

A 'CouponCode' is a type of code that will be passed *in printed form* to
someone who will be expected to type it into a web page or other application.
The codes are random strings which are designed to be easy for the recipient to
type accurately into a web form.

The following features make the codes well suited to manual transcription:

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

Algorithm::CouponCode
---------------------

This git repository contains:

* the Perl [CPAN module](http://search.cpan.org/dist/Algorithm-CouponCode/)
which implements the code generation algorithm and the server-side validation
* a [Javascript implementation](http://search.cpan.org/dist/Algorithm-CouponCode/html/index.html)
of the validator function, in the form of a jQuery plugin, which can be
included in your web application to do client-side validation and highlighting
of errors

Alternative implementations
---------------------------

The code generation and server-side validation routines have been ported to
other languages (_Note: a listing here does not constitute an endorsement nor a
guarantee of compatibility_):


* [Javascript for Node.js](https://www.npmjs.com/package/coupon-code)
* [Ruby](https://rubygems.org/gems/coupon_code/versions/0.0.1)
* [PHP](https://github.com/atelierdisko/coupon_code)
* [C#](https://github.com/rebeccapowell/csharp-algorithm-coupon-code)
* [Go](https://github.com/CaptainCodeman/couponcode)
* [Elixir](https://hexdocs.pm/coupon_code_ex/CouponCode.html)
