NAME
====

Date::Calendar::Gregorian - Extending the core class 'Date' with strftime and conversions with other calendars

SYNOPSIS
========

Printing the date 2020-04-05 in French _without_ Date::Calendar::Gregorian

```perl6
use Date::Names;
use Date::Calendar::Strftime;

my Date        $date   .= new('2020-04-05');
my Date::Names $locale .= new(lang => 'fr');

my $day   = $locale.dow($date.day-of-week);
my $month = $locale.mon($date.month);
$date does Date::Calendar::Strftime;

say $date.strftime("$day %d $month %Y");
```

Printing the date 2020-04-05 in French _with_ Date::Calendar::Gregorian

```perl6
use Date::Calendar::Gregorian;
my Date::Calendar::Gregorian $date .= new('2020-04-05');
$date.locale = 'fr';
say $date.strftime("%A %d %B %Y");
```

INSTALLATION
============

```shell
zef install Date::Calendar::Gregorian
```

or

```shell
git clone https://github.com/jforget/raku-Date-Calendar-Gregorian.git
cd raku-Date-Calendar-Julian
zef install .
```

DESCRIPTION
===========

Date::Calendar::Gregorian is a  child class to the  core class 'Date',
to extend it with the string-generation method `strftime` and with the
conversion methods `new-from-date` and `to-date`.

AUTHOR
======

Jean Forget <JFORGET@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright © 2020 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

