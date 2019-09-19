unit module Algorithm::Snail;

multi sub square3x3-reds-order('x-y') {
    ( 0,-1), (-1, 0), ( 1, 0), ( 0, 1);
}
multi sub square3x3-blues-order('x-y') {
    (-1,-1), ( 1,-1), (-1, 1), ( 1, 1);
}
multi sub big-squares-reds-order('x-y', $shift) {
    (0,-$shift), (-$shift,0), ($shift,0), (0,$shift);
}
multi sub big-squares-greens-order('x-y', $shift, $off) {
    (  -$off,-$shift), ( +$off, -$shift),
    (-$shift,  -$off), (+$shift,  -$off),
    (-$shift,  +$off), (+$shift,  +$off),
    (  -$off,+$shift), (  +$off,+$shift);
}
multi sub big-squares-blues-order('x-y', $shift) {
    (-$shift,-$shift), ($shift,-$shift), (-$shift,$shift), ($shift,$shift);
}


multi sub square3x3-reds-order('clockwise') {
    ( 0,-1), ( 1, 0), ( 0, 1), (-1, 0);
}
multi sub square3x3-blues-order('clockwise') {
    ( 1,-1), ( 1, 1), (-1, 1), (-1,-1);
}
multi sub big-squares-reds-order('clockwise', $shift) {
    (0,-$shift), ($shift,0), (0,$shift), (-$shift,0);
}
multi sub big-squares-greens-order('clockwise', $shift, $off) {
                       ( +$off, -$shift),
    (+$shift,  -$off), (+$shift,  +$off),
    (  +$off,+$shift), (  -$off,+$shift),
    (-$shift,  +$off), (-$shift,  -$off),
    (  -$off,-$shift);
}
multi sub big-squares-blues-order('clockwise', $shift) {
    ($shift,-$shift), ($shift,$shift), (-$shift,$shift), (-$shift,-$shift);
}


sub square_snail(
   :$order = 'clockwise'
) is export(:ALL) {
    # See docs/snail.md (or docs/vis-9x9.png) to understand the algorithm
    # and the colors in comments below.
    gather {
        # 1x1
        take (0,0); # magenta

        # 3x3
        take $_ for square3x3-reds-order($order); # red
        take $_ for square3x3-blues-order($order); # red

        # 5x5, 7x7, ...
        my $shift = 2;
        loop {
            take $_ for big-squares-reds-order($order,$shift); # red
            for 1..^$shift -> $off {
                take $_ for big-squares-greens-order($order,$shift,$off); # green
            }
            take $_ for big-squares-blues-order($order,$shift); # blue
            $shift++;
        }
    }
}

sub rectangle_snail( :$ratio, :$order=Nil ) is export(:ALL) {
    my $iter := square_snail(:$order).iterator;
    my @buffer;
    gather {
        take $iter.pull-one; # 0,0
        for 1..* -> $dist {
            my $dist_x = $dist;
            my $dist_y = $dist / $ratio;
            for 0..@buffer.end -> $index {
                next if @buffer[$index] ~~ Empty;
                my ($x,$y) = @buffer[$index][0,1];
                if $x.abs > $dist_x or $y.abs > $dist_y {
                    #say "$x,$y <-- buffer[{$index}], {$x.abs} > $dist_x or {$y.abs} > {$dist_y}";
                    next;
                }
                #say "$x,$y <-- used from buffer[{$index}]";
                @buffer[$index] = Empty;
                take ($x,$y);
            }
            #say "buffer end";
            loop {
                my ($x,$y) = $iter.pull-one;
                if $x.abs > $dist_x or $y.abs > $dist_y {
                    push @buffer, ($x,$y);
                    #say "$x,$y <-- buffered, {$x.abs} > $dist_x or {$y.abs} > {$dist_y}";
                    if $x.abs > $dist_x && $y.abs > $dist_y {
                        #say "$x, $y both coords over dist, {$x.abs} > $dist_x and {$y.abs} > {$dist_y}";
                        last;
                    }
                    next;
                }
                #say "$x,$y <-- used, {$x.abs} <= $dist_x or {$y.abs} <= {$dist_y}";
                take ($x,$y);
            }
            #say "LP end";
        }
    }
}
