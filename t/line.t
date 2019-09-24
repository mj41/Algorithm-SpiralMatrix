use Test;

use Algorithm::SpiralMatrix;

sub dump_matrix( $seq, $size_x, $size_y, $max_iterations=1000, *%seq_params ) {
    my $i = 0;
    my $off_x = ($size_x - 1) / 2;
    my $off_y = ($size_y - 1) / 2;
    my @arr;
    for &$seq(|%seq_params) -> ($x,$y) {
        #say "{$i.fmt('%3d')} {$x.fmt('%3d')},{$y.fmt('%3d')}";
        fail "Error $x,$y ({$x+$off_x,$y+$off_y}) already has value {@arr[$y+$off_y][$x+$off_x]}"
                with @arr[$y+$off_y][$x+$off_x];
        last if $x+$off_x > $size_x and $y+$off_y > $size_y;
        $i++;
        @arr[$y+$off_y][$x+$off_x] = $i
            if $x+$off_x >= 0 and $x+$off_x < $size_x and $y+$off_y >= 0 and $y+$off_y < $size_y;
        last if $i >= $max_iterations;
    }
    my $out_matrix;
    for 0..^$size_y -> $y { for 0..^$size_x -> $x { @arr[$y][$x] //= 0 } }
    $out_matrix = @arr.fmt("%3d","\n");
    return $out_matrix;
}

{
    my $out_matrix = dump_matrix(
        &rectangle_line,
        11, 3, 50,
        :direction('x'), :order('clockwise')
    );
    is(
        $out_matrix,
        qq:to/END/.chomp,
          0   0   0   0   0   0   0   0   0   0   0
         11   9   7   5   3   1   2   4   6   8  10
          0   0   0   0   0   0   0   0   0   0   0
        END
        'distance:clockwise line 11x3'
    );
    diag "\n$out_matrix\n";
}

{
    my $out_matrix = dump_matrix(
        &rectangle_line,
        3, 11, 50,
        :direction('y'), :order('clockwise')
    );
    is(
        $out_matrix,
        qq:to/END/.chomp,
          0  10   0
          0   8   0
          0   6   0
          0   4   0
          0   2   0
          0   1   0
          0   3   0
          0   5   0
          0   7   0
          0   9   0
          0  11   0
        END
        'distance:clockwise line 3x11'
    );
    diag "\n$out_matrix\n";
}

{
    my $out_matrix = dump_matrix(
        &rectangle_line,
        11, 3, 50,
        :direction('x'), :order('x-y')
    );
    is(
        $out_matrix,
        qq:to/END/.chomp,
          0   0   0   0   0   0   0   0   0   0   0
         10   8   6   4   2   1   3   5   7   9  11
          0   0   0   0   0   0   0   0   0   0   0
        END
        'distance:x-y line 11x3'
    );
    diag "\n$out_matrix\n";
}

{
    my $out_matrix = dump_matrix(
        &rectangle_line,
        3, 11, 50,
        :direction('y'), :order('x-y')
    );
    is(
        $out_matrix,
        qq:to/END/.chomp,
          0  10   0
          0   8   0
          0   6   0
          0   4   0
          0   2   0
          0   1   0
          0   3   0
          0   5   0
          0   7   0
          0   9   0
          0  11   0
        END
        'distance:clockwise line 3x11'
    );
    diag "\n$out_matrix\n";
}

done-testing;
