unit module Algorithm::Snail;

sub square_snail is export(:ALL) {
    # See docs/snail.md (docs/vis-*.png) to understand colors:
    gather {
        take $_ for
                ( 0, 0), # magenta
                ( 0,-1), (-1, 0), ( 1, 0), ( 0, 1), # red
                (-1,-1), ( 1,-1), (-1, 1), ( 1, 1), # blue
                ;

        my $shift = 2;
        loop {
            take $_ for (0,-$shift),(-$shift,0),($shift,0),(0,$shift); # red
            for 1..^$shift -> $off {
                take $_ for
                        # green
                        (  -$off,-$shift), ( +$off, -$shift),
                        (-$shift,  -$off), (+$shift,  -$off),
                        (-$shift,  +$off), (+$shift,  +$off),
                        (  -$off,+$shift), (  +$off,+$shift),
            }
            take $_ for (-$shift,-$shift),($shift,-$shift),(-$shift,$shift),($shift,$shift); # blue
            $shift++;
        }
    }
}

sub rectangle_snail( $ratio ) is export(:ALL) {
    my $iter := square_snail().iterator;
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
