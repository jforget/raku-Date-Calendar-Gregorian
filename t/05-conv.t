#
# Checking the conversions
#
use v6.c;
use Test;
use Date::Calendar::Gregorian;

#
# Embedded minimalistic class, just for the purposes of checking D::C::Gregorian without bothering
# to download and install an existing full-fledged Date::Calendar::xxx module.
#
class Date::Calendar::RataDie {
  has Int $.rata-die;

  method new-from-daycount(Int $count) {
    $.new(rata-die => $count + 678576);
  }
  method daycount {
    $.rata-die - 678576;
  }
}

my @tests = test-data;
plan 2 × @tests.elems;

for @tests -> $test {
  my ($rata-die, $gregorian) = $test;
  my Date::Calendar::RataDie   $d-rd   .= new(rata-die => $rata-die);
  my Date::Calendar::Gregorian $d-greg .= new-from-date($d-rd);
  is($d-greg.gist, $gregorian, "Conversion $rata-die → $gregorian");
}

for @tests -> $test {
  my ($rata-die, $gregorian) = $test;
  my Date::Calendar::Gregorian $d-greg .= new($gregorian);
  my Date::Calendar::RataDie   $d-rd    = $d-greg.to-date("Date::Calendar::RataDie");
  is($d-rd.rata-die, $rata-die, "Conversion $gregorian → $rata-die");
}

done-testing;

# Data generated by Perl5's DateTime
sub test-data {
  return    ((678576,  '1858-11-17')
           , (737520,  '2020-04-05')
           , (737425,  '2020-01-01')
           , (730486,  '2001-01-01')
           , (730119,  '1999-12-31')
           , (730120,  '2000-01-01')
           , (     1,  '0001-01-01')
           , (     0,  '0000-12-31')
           , (  -365,  '0000-01-01')
           , (  -366, '-0001-12-31')
           , (  -730, '-0001-01-01')
           , (577725,  '1582-10-04')
           , (577735,  '1582-10-14')
           , (577736,  '1582-10-15')
           );
}