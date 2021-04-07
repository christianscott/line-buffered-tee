#! /usr/bin/env bash

create_noise() {
    if [[ "${USE_LINE_BUFFERED_TEE:-}" == "true" ]]; then
        ./bin/tee_breaker | ./bin/line_buffered_tee tee.log
    else
        ./bin/tee_breaker | tee -a tee.log
    fi
}

run() {
    create_noise &
    pid_1="$!"

    create_noise &
    pid_2="$!"

    wait $pid_1
    wait $pid_2
}

echo "Without line buffering (via tee -a):"
run

echo
echo

echo "With line buffering (via bin/line_buffered_tee):"
USE_LINE_BUFFERED_TEE="true" run
