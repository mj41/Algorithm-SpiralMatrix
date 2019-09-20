use Algorithm::SpiralMatrix;

my $i = 1;
for square_distance(order => 'clockwise') -> ($x,$y) {
    say "{$i++} $x,$y";
    last if $i > 25;
}
