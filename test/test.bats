@test "invoking without at least one file fails" {
    run bin/line_buffered_tee
    [ "$status" -eq 1 ]
}