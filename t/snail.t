use Test;

use Algorithm::Snail :ALL;

sub dump_matrix( $seq, @seq_params, $size_x, $size_y ) {
    my $i = 0;
    my $off_x = ($size_x - 1) / 2;
    my $off_y = ($size_y - 1) / 2;
    my @arr;
    for $seq.(|@seq_params) -> ($x,$y) {
        #say "{$i.fmt('%3d')} {$x.fmt('%3d')},{$y.fmt('%3d')}";
        fail "Error $x,$y ({$x+$off_x,$y+$off_y}) already has value {@arr[$y+$off_y][$x+$off_x]}"
                with @arr[$y+$off_y][$x+$off_x];
        last if $x+$off_x > $size_x and $y+$off_y > $size_y;
        $i++;
        next if $x+$off_x < 0 or $x+$off_x >= $size_x or $y+$off_y < 0 or $y+$off_y >= $size_y;
        @arr[$y+$off_y][$x+$off_x] = $i;
    }
    my $out_matrix;
    for 0..^$size_y -> $y { for 0..^$size_x -> $x { @arr[$y][$x] //= 0 } }
    $out_matrix = @arr.fmt("%3d","\n");
}

{
    my $out_matrix = dump_matrix( &square_snail, (), 11, 11 );
    diag "\n"~$out_matrix;
    is(
        $out_matrix,
        qq:to/END/.chomp,
        118 110 102  94  86  82  87  95 103 111 119
        112  78  70  62  54  50  55  63  71  79 113
        104  72  46  38  30  26  31  39  47  73 105
         96  64  40  22  14  10  15  23  41  65  97
         88  56  32  16   6   2   7  17  33  57  89
         83  51  27  11   3   1   4  12  28  52  84
         90  58  34  18   8   5   9  19  35  59  91
         98  66  42  24  20  13  21  25  43  67  99
        106  74  48  44  36  29  37  45  49  75 107
        114  80  76  68  60  53  61  69  77  81 115
        120 116 108 100  92  85  93 101 109 117 121
        END
        'square matrix 11x11'
    );
}

{
    my $out_matrix = dump_matrix( &rectangle_snail, (2,), 11, 5 );
    diag "\n"~$out_matrix;
    is(
        $out_matrix,
        qq:to/END/.chomp,
         52  42  32  28  24  22  25  29  33  43  53
         48  38  18  12   6   4   7  13  19  39  49
         46  36  16  10   2   1   3  11  17  37  47
         50  40  20  14   8   5   9  15  21  41  51
         54  44  34  30  26  23  27  31  35  45  55
        END
        'rectangle matrix size to 11x5, ratio 2'
    );
}


done-testing;
