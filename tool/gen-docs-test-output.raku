#!/usr/bin/env perl6

sub get_out($cmd) {
    my $proc = run $cmd.split(" "), :out, :merge;
    my $captured-output = $proc.out.slurp: :close;
    my $exit-code       = $proc.exitcode;
    fail "cmd '$cmd'\nexit-code {$exit-code}: $captured-output"
        if $exit-code;
    return $captured-output;
}


say "<!-- use './tool/gen-docs-test-output.raku > docs/test-output.md' to regenerate this file -->";
for 'var-distance','line' -> $t-file-base  {
    my $t-file-rel-path = "t/{$t-file-base}.rakutest";
    say "Test [{$t-file-rel-path}](../{$t-file-rel-path}) output:";
    say '```';
    my $cmd = "perl6 -Ilib -It/lib {$t-file-rel-path}";
    say get_out($cmd);
    say '```';
    say "\n";
    CATCH { say $_.perl }
}
