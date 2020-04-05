#
# Checking the formatting from strftime
#
use v6.c;
use Test;
use Date::Calendar::Gregorian;

my @tests = test-data;
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $locale, $format, $length, $expected) = $test;
  my Date::Calendar::Gregorian $d-greg .= new(year => $y, month => $m, day => $d, locale => $locale);
  my $result = $d-greg.strftime($format);

  # Remembering RT ticket 100311 for the Perl 5 module DateTime::Calendar::FrenchRevolutionary
  # Even if the relations between UTF-8 and Raku are much simpler than between UTF-8 and Perl5
  # better safe than sorry
  is($result.chars, $length);
  is($result,       $expected);
}

done-testing;

sub test-data {
  return    ((2019,  6,  7, 'en', 'zzz',          3, 'zzz')
           , (2019,  6,  7, 'en', '%Y-%m-%d',    10, '2019-06-07')
           , (2019,  6,  7, 'en', '%j',           3, '158')
           , (2019,  6,  7, 'en', '%Oj',          3, '158')
           , (2019,  6,  7, 'en', '%Ej',          3, '158')
           , (2019,  6,  7, 'en', '%EY',          4, '2019')
           , (2019,  6,  7, 'en', '%Ey',          3, '%Ey')
           , (2019,  6,  7, 'en', '%A',           6, 'Friday')
           , (2019,  6,  7, 'en', '%u',           1, '5')
           , (2019,  6,  7, 'en', '%B',           4, 'June')
           , (2019,  6,  7, 'en', '%b',           3, 'Jun')
           , (2020,  7,  7, 'en', '%j',           3, '189')
           , (2020,  7,  7, 'en', '%Y',           4, '2020')
           , (2020,  7,  7, 'en', '%G',           4, '2020')
           , (2020,  7,  7, 'en', '%V',           2, '28')
           , (2020,  7,  7, 'en', '%u',           1, '2')
           , (2020,  7,  7, 'en', '%A',           7, 'Tuesday')
           , (2020,  7,  7, 'en', '%B',           4, 'July')
           , (2020,  3,  7, 'de', '%A %B %a %b', 19, 'Samstag März Sa Mär')
           , (2020,  3,  4, 'es', '%A %a',       13, 'miércoles mié')
           , (2020,  2,  7, 'fr', '%A %B',       16, 'vendredi février')
           , (2020,  3,  1, 'nb', '%A %B %a %b', 17, 'søndag mars %a %b')
           , (2020,  3,  1, 'ru', '%A %B %a %b', 23, 'воскресенье март Вс мар')
             );
}
