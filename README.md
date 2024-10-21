NAME
====

Date::Calendar::Gregorian - Extending the core class 'Date' with strftime and conversions with other calendars

SYNOPSIS
========

Here are two ways of printing the date 2020-04-05 in French.

First, __without__ Date::Calendar::Gregorian

```perl6
use Date::Names;
use Date::Calendar::Strftime;

my Date        $date   .= new('2020-04-05');
my Date::Names $locale .= new(lang => 'fr');

my $day   = $locale.dow($date.day-of-week);
my $month = $locale.mon($date.month);
$date does Date::Calendar::Strftime;

say $date.strftime("$day %d $month %Y");
# --> dimanche 05 avril 2020
```

Second, __with__ Date::Calendar::Gregorian

```perl6
use Date::Calendar::Gregorian;
my  Date::Calendar::Gregorian $date .= new('2020-04-05', locale => 'fr');
say $date.strftime("%A %d %B %Y");
# --> dimanche 05 avril 2020
```

INSTALLATION
============

```shell
zef install Date::Calendar::Gregorian
```

or

```shell
git clone https://github.com/jforget/raku-Date-Calendar-Gregorian.git
cd raku-Date-Calendar-Gregorian
zef install .
```

DESCRIPTION
===========

Date::Calendar::Gregorian is a  child class to the  core class 'Date',
to extend it with the string-generation method `strftime` and with the
conversion methods `new-from-date` and `to-date`.

AUTHOR
======

Jean Forget <J2N-FORGET at orange dot fr>

COPYRIGHT AND LICENSE
=====================

Copyright (c) 2020, 2021, 2024 Jean Forget, all rights reserved.

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

