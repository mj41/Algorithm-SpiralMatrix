unit module ASMTestCommon;

sub dump_matrix(
    $seq,
    $size_x,
    $size_y,
    $max_iterations=1000,
    *%seq_params
) is export {
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
