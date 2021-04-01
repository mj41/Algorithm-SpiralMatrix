unit module Algorithm::SpiralMatrix;

multi sub square3x3-reds-order('clockwise') {
    ( 0,-1), ( 1, 0), ( 0, 1), (-1, 0);
}
multi sub square3x3-blues-order('clockwise') {
    ( 1,-1), ( 1, 1), (-1, 1), (-1,-1);
}
multi sub big-squares-reds-order('clockwise', $shift) {
    (0,-$shift), ($shift,0), (0,$shift), (-$shift,0);
}
multi sub big-squares-greens-order('clockwise', $shift, $tone) {
                       (+$tone, -$shift),
    (+$shift, -$tone), (+$shift, +$tone),
    ( +$tone,+$shift), ( -$tone,+$shift),
    (-$shift, +$tone), (-$shift, -$tone),
    ( -$tone,-$shift);
}
multi sub big-squares-blues-order('clockwise', $shift) {
    ($shift,-$shift), ($shift,$shift), (-$shift,$shift), (-$shift,-$shift);
}


multi sub square3x3-reds-order('x-y') {
    ( 0,-1), (-1, 0), ( 1, 0), ( 0, 1);
}
multi sub square3x3-blues-order('x-y') {
    (-1,-1), ( 1,-1), (-1, 1), ( 1, 1);
}
multi sub big-squares-reds-order('x-y', $shift) {
    (0,-$shift), (-$shift,0), ($shift,0), (0,$shift);
}
multi sub big-squares-greens-order('x-y', $shift, $tone) {
    ( -$tone,-$shift), (+$tone, -$shift),
    (-$shift, -$tone), (+$shift, -$tone),
    (-$shift, +$tone), (+$shift, +$tone),
    ( -$tone,+$shift), ( +$tone,+$shift);
}
multi sub big-squares-blues-order('x-y', $shift) {
    (-$shift,-$shift), ($shift,-$shift), (-$shift,$shift), ($shift,$shift);
}


sub square_distance(
   :$order = 'clockwise'
) is export {
    # See docs/distance-variants.md to understand the algorithm
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
            for 1..^$shift -> $tone {
                take $_ for big-squares-greens-order($order,$shift,$tone); # green tone
            }
            take $_ for big-squares-blues-order($order,$shift); # blue
            $shift++;
        }
    }
}

# ToDo - Duplication below - maybe macro would help.
#
multi sub line( 'x', 'clockwise' ) {
    gather {
        take (0,0);
        my $shift = 1;
        loop {
            take (+$shift,0);
            take (-$shift,0);
            $shift++;
        }
    }
}
multi sub line( 'y', 'clockwise' ) {
    gather {
        take (0,0);
        my $shift = 1;
        loop {
            take (0, -$shift);
            take (0, +$shift);
            $shift++;
        }
    }
}

multi sub line( 'x', 'x-y' ) {
    gather {
        take (0,0);
        my $shift = 1;
        loop {
            take (-$shift,0);
            take (+$shift,0);
            $shift++;
        }
    }
}
multi sub line( 'y', 'x-y' ) {
    line( 'y', 'clockwise' );
}

multi sub rectangle_line( :$direction, :$order='clockwise' ) is export {
    line( $direction, $order );
}

sub rectangle_distance( :$ratio, :$order=Nil ) is export {

    return line('x',$order) if $ratio == Inf;
    return line('y',$order) if $ratio == 0;

    my $iter := square_distance(:$order).iterator;
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
