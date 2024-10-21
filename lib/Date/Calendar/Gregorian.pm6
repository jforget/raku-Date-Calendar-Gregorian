use v6.c;
use Date::Names;
use Date::Calendar::Strftime;

unit class Date::Calendar::Gregorian:ver<0.0.2>:auth<zef:jforget>:api<0>
        is Date
      does Date::Calendar::Strftime;

has Str $.locale is rw where { check-locale($_) } = 'en';

has Str         $!instantiated-locale;
has Date::Names $!date-names;

method month-name {
  self!lazy-instance;
  $!date-names.mon($.month);
}

method day-name {
  self!lazy-instance;
  $!date-names.dow($.day-of-week);
}

method month-abbr {
  my $locale = $.locale;
  my $index  = $.month - 1;
  my $class  = "Date::Names::$locale";
  return $::($class)::mon3[$index]
      // $::($class)::mon2[$index]
      // $::($class)::mona[$index];
}

method day-abbr {
  my $locale = $.locale;
  my $index  = $.day-of-week - 1;
  my $class  = "Date::Names::$locale";
  return $::($class)::dow3[$index]
      // $::($class)::dow2[$index]
      // $::($class)::dowa[$index];
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount);
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount);
  return $d;
}

sub check-locale ($locale) {
  unless grep { $_ eq $locale }, @Date::Names::langs {
    X::Invalid::Value.new(:method<BUILD>, :name<locale>, :value($locale)).throw;
  }
  True;
}

method !lazy-instance {
  $.locale              //= 'en';
  $!instantiated-locale //= '';
  if $.locale ne $!instantiated-locale {
    $!date-names = Date::Names.new(lang => $.locale);
    $!instantiated-locale = $.locale;
  }
}


=begin pod

=head1 NAME

Date::Calendar::Gregorian - Extending the core class 'Date' with strftime and conversions with other calendars

=head1 SYNOPSIS

Here are two ways of printing the date 2020-04-05 in French.

First, B<without> Date::Calendar::Gregorian

=begin code :lang<perl6>

use Date::Names;
use Date::Calendar::Strftime;

my Date        $date   .= new('2020-04-05');
my Date::Names $locale .= new(lang => 'fr');

my $day   = $locale.dow($date.day-of-week);
my $month = $locale.mon($date.month);
$date does Date::Calendar::Strftime;

say $date.strftime("$day %d $month %Y");
# --> dimanche 05 avril 2020

=end code

Second, B<with> Date::Calendar::Gregorian

=begin code :lang<perl6>

use Date::Calendar::Gregorian;
my  Date::Calendar::Gregorian $date .= new('2020-04-05', locale => 'fr');
say $date.strftime("%A %d %B %Y");
# --> dimanche 05 avril 2020

=end code

=head1 DESCRIPTION

Date::Calendar::Gregorian is a  child class to the  core class 'Date',
to extend  it with the  string-generation method C<strftime>  and with
the conversion methods C<new-from-date> and C<to-date>.

The  core class  C<Date> is  very good  at number  crunching and  date
computations,  but it  lacks facilities  with string  generation. This
module, which invokes  the C<Date::Calendar::Strftime>, glues together
the core class C<Date> and the utility module C<Date::Names>.

In addition,  this class declares methods  to convert dates from  / to
other C<Date::Calendar::>R<xxx> classes.

For  the  documentation  of  most   methods  and  functions,  see  the
documentation of C<Date>. Here are the new ones.

=head2 Constructors

=head3 new-from-date

Build a Gregorian  date by cloning an object from  another class. This
other class can be the core class C<Date> (but why would you convert a
Gregorian date into Gregorian?) or any C<Date::Calendar::>R<xxx> class
with a C<daycount> method.

This method does not allow a  C<locale> build parameter. The object is
built with the default locale, C<'en'>.

=head3 new

Actually, C<new> is the constructor for the parent core class C<Date>.
Yet, every  form of this  multi-method accepts a  C<locale> parameter.
All the variants below gives the same date, with different locales:

=begin code :lang<perl6>

my Date::Calendar::Gregorian $d1 .= new('2020-02-02'                        , locale => 'fr');
my Date::Calendar::Gregorian $d2 .= new( 2020, 2, 2                         , locale => 'es');
my Date::Calendar::Gregorian $d3 .= new(year => 2020, month => 2, day => 2  , locale => 'de');
my Date::Calendar::Gregorian $d4 .= new(Instant.from-posix(1580602000      ), locale => 'it');
my Date::Calendar::Gregorian $d5 .= new(DateTime.new('2020-02-02T12:00:00Z'), locale => 'nl');

=end code

=head2 Accessors

=head3 locale

The two-char  string defining the  locale used  for the date.  Use any
value allowed by the module C<Date::Names>.

This attribute can be updated after build time.

=head3 month-name

The month of the date, as a string. This depends on the date's current
locale.

=head3 month-abbr

The abbreviated month of the date.

Depending on the locale, it may be a 3-char string, a 2-char string or
a short string  of variable length. Please refer  to the documentation
of  C<Date::Names>  for  the  availability  of  C<mon3>,  C<mon2>  and
C<mona>.

=head3 day-name

The name of the day within the  week. It depends on the date's current
locale.

=head3 day-abbr

The abbreviated day name of the date.

Depending on the locale, it may be a 3-char string, a 2-char string or
a short code of variable length.  Please refer to the documentation of
C<Date::Names> for the availability of C<dow3>, C<dow2> and C<dowa>.

=head2 Other Methods

=head3 to-date

Clones the  date into a C<Date::Calendar::>R<xxx>  compatible calendar
class. The target class name is  given as a positional parameter. This
parameter  is  optional,  the  default  value  is  C<"Date">  for  the
Gregorian calendar, which  is not very useful but which  at least does
not depend on  which modules are installed on your  system and is sure
to be available.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while  converting  "1st February  2020"  to  the French  Revolutionary
calendar, you can code:

=begin code :lang<perl6>

use Date::Calendar::Gregorian;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Gregorian           $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 2020
             , month =>    2
             , day   =>    1);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);

=end code

Even  if both  calendars use  a C<locale>  attribute, when  a date  is
created by  the conversion  of another  date, it  is created  with the
default  locale. If  you  want the  locale to  be  transmitted in  the
conversion, you should add this line:

=begin code :lang<perl6>

$d-dest-pull.locale = $d-orig.locale;

=end code

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<perl6>

$df.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring. Thus, the whole  string will be at least 42 chars
long.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute. Not used with the Gregorian calendar.

=item A mandatory type code.

The allowed type codes are:

=defn C<%a>

The day of week name, abbreviated to 2 or 3 chars.

=defn C<%A>

The full day of week name.

=defn C<%b>

The abbreviated month name.

=defn C<%B>

The full month name.

=defn C<%d>

The day of the month as a decimal number (range 01 to 31).

=defn C<%e>

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn C<%f>

The month as a decimal number (1  to 12). Unlike C<%m>, a leading zero
is replaced by a space.

=defn C<%F>

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn C<%G>

The  "week year"  as a  decimal number  for the  so-called "ISO  date"
format.

=defn C<%j>

The day of the year as a decimal number (range 001 to 366).

=defn C<%m>

The month as a two-digit decimal  number (range 01 to 12), including a
leading zero if necessary.

=defn C<%n>

A newline character.

=defn C<%t>

A tab character.

=defn C<%u>

The day of week as a 1..7 number.

=defn C<%V>

The week number in the so-called "ISO date" format.

=defn C<%Y>

The year as a decimal number.

=defn C<%%>

A literal `%' character.

=head1 ISSUES

In  the parent  class,  objects  are immutable.  You  cannot change  a
"Sunday 5  April 2020" C<Date> object  into "Monday 6 April  2020". In
this  class, objects  are no  longer completely  immutable. You  still
cannot change  a "Sunday  5 April  2020" object  into "Monday  6 April
2020",  but you  can change  this "Sunday  5 April  2020" object  into
"dimanche 5 avril 2020" or "domingo 5 abril 2020".

This may  seem no  big deal,  but in  some cases  it may  prevent some
optimisations from being applied or it may enable thread-related bugs.
I am no expert on this but  I think you cannot blindly change all your
uses of C<Date> into uses of C<Date::Calendar::Gregorian>.

Another  issue,   as  explained  in   the  C<Date::Calendar::Strftime>
documentation. Please ensure that  format-string passed to C<strftime>
comes from  a trusted source.  For example, by including  a outrageous
length in  a C<strftime> specifier, you  can drain your PC's  RAM very
fast.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Names>

L<Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

=head2 Perl 5 Software

L<DateTime>

L<Date::Convert>

L<Date::Converter>

=head2 Other Software

date(1), strftime(3)

F<calendar/calendar.el>  in emacs or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>
(Actually, I have used the 3.0 version which is not longer available)

=head2 Books

Calendrical  Calculations   (Third  or   Fourth  Edition)   by  Nachum
Dershowitz  and Edward  M. Reingold,  Cambridge University  Press, see
L<http://www.calendarists.com> or
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

I<La saga des calendriers>, by Jean Lefort, published by I<Belin> (I<Pour la Science>), ISBN 2-90929-003-5
See L<https://www.belin-editeur.com/la-saga-des-calendriers>

I<Le Calendrier>, by Paul Couderc, published by I<Presses universitaires de France> (I<Que sais-je ?>), ISBN 2-13-036266-4
See L<https://catalogue.bnf.fr/ark:/12148/cb329699661>.

=head2 Internet

L<https://www.tondering.dk/claus/calendar.html> - Claus Tøndering's
calendar FAQ, especially the page L<https://www.tondering.dk/claus/cal/gregorian.php>.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020, 2021, 2024 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
