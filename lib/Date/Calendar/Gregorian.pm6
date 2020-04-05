use v6.c;
use Date::Names;
use Date::Calendar::Strftime;

unit class Date::Calendar::Gregorian:ver<0.0.1>
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

sub check-locale ($locale) {
  unless grep { $_ eq $locale }, @Date::Names::langs {
    X::Invalid::Value.new(:method<BUILD>, :name<locale>, :value($locale)).throw;
  }
  True;
}

method !lazy-instance {
  $.locale //= 'en';
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

Printing the date 2020-04-05 in French I<without> Date::Calendar::Gregorian

=begin code :lang<perl6>

use Date::Names;
use Date::Calendar::Strftime;

my Date        $date   .= new('2020-04-05');
my Date::Names $locale .= new(lang => 'fr');

my $day   = $locale.dow($date.day-of-week);
my $month = $locale.mon($date.month);
$date does Date::Calendar::Strftime;

say $date.strftime("$day %d $month %Y");

=end code

Printing the date 2020-04-05 in French I<with> Date::Calendar::Gregorian

=begin code :lang<perl6>

use Date::Calendar::Gregorian;
my Date::Calendar::Gregorian $date .= new('2020-04-05');
$date.locale = 'fr';
say $date.strftime("%A %d %B %Y");

=end code

=head1 DESCRIPTION

Date::Calendar::Gregorian is a  child class to the  core class 'Date',
to extend  it with the  string-generation method C<strftime>  and with
the conversion methods C<new-from-date> and C<to-date>.

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2020 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
