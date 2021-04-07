@test "invoking without at least one file fails" {
    run bin/line_buffered_tee
    [ "${status}" -eq 1 ]
}

@test "can write to a file that already exists" {
    log_file="${BATS_TMPDIR}/one.log"
    touch "${log_file}"
    echo hello | bin/line_buffered_tee "${log_file}"
}

@test "can write to a file that does not already exists" {
    log_file="${BATS_TMPDIR}/one.log"
    echo hello | bin/line_buffered_tee "${log_file}"
}

concurrent_tees() {
    local log_file="$1"
    ./bin/tee_breaker | ./bin/line_buffered_tee "${log_file}" &
    pid_1="$!"

    ./bin/tee_breaker | ./bin/line_buffered_tee "${log_file}" &
    pid_2="$!"

    wait $pid_1
    wait $pid_2
}


expected_output=$(cat <<EOF
{ "msg": "hello!" }
{ "msg": "hello!" }
{ "msg": "goodbye :(" }
{ "msg": "goodbye :(" }
EOF
)

@test "behaves when two processes write to the same log file concurrently" {
    log_file="${BATS_TMPDIR}/one.log"
    run concurrent_tees "${log_file}"
    [ "${output}" = "${expected_output}" ]
}