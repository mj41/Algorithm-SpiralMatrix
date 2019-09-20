# Algorithm::SpiralMatrix

Various Perl 6 Sequences for spirals in matrix (two-dimensional 
arrays).

For overview see [docs/test-output.md](docs/test-output.md) 
and [docs/distance-variants.md](docs/distance-variants.md).

## Synopsis

```perl6
use Algorithm::SpiralMatrix;

my $i = 1;
for square_distance(order => 'clockwise') -> ($x,$y) {
    say "{$i++} $x,$y"; 
    last if $i > 25;
}
```

will print
```
1 0,0
2 0,-1
3 1,0
4 0,1
5 -1,0
6 1,-1
8 -1,1
9 -1,-1
...
24 -2,2
25 -2,-2
````

## Description

This module provides implementation of algorithms to generate various
spiral sequences in matrix (two-dimensional array).

## Related links

* [zero2cx/spiral-matrix](https://github.com/zero2cx/spiral-matrix) (Python)
* [bangjunyoung/SpiralMatrixSharp](https://github.com/bangjunyoung/SpiralMatrixSharp) (F#)
* [Exercism: spiral-matrix](https://github.com/exercism/problem-specifications/blob/master/exercises/spiral-matrix/description.md)

## Installation

Rakudo Perl 6 distribution contains *zef*. Use

	zef install Algorithm::SpiralMatrix

If you have a local copy of this repository use

	zef install .

in the module directory.

## Support

Feel free to share your suggestions, patches or comment 
[https://github.com/mj41/Algorithm-SpiralMatrix/issues](https://github.com/mj41/Algorithm-SpiralMatrix/issues).

## Licence and Copyright

This is free software. Please see the LICENCE file.

© Michal Jurosz, 2019