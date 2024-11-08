#
# Checking the parent class' "new" constructor
#
use v6;
use Test;
use Date::Calendar::Gregorian;

plan 5;

my Date::Calendar::Gregorian $d1 .= new('2020-02-02', locale => 'fr');
is($d1.strftime("%A %d %B %Y"), "dimanche 02 février 2020");

my Date::Calendar::Gregorian $d2 .= new(2020, 2, 2, locale => 'es');
is($d2.strftime("%A %d %B %Y"), "domingo 02 febrero 2020");

my Date::Calendar::Gregorian $d3 .= new(year => 2020, month => 2, day => 2, locale => 'de');
is($d3.strftime("%A %d %B %Y"), "Sonntag 02 Februar 2020");

my Date::Calendar::Gregorian $d4 .= new(Instant.from-posix(1580602000), locale => 'it');
is($d4.strftime("%A %d %B %Y"), "domenica 02 Febbraio 2020");

my Date::Calendar::Gregorian $d5 .= new(DateTime.new('2020-02-02T12:00:00Z'), locale => 'nl');
is($d5.strftime("%A %d %B %Y"), "zondag 02 februari 2020");



done-testing;
