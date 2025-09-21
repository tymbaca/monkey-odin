package misc

import "core:testing"
import "core:log"

run_tt :: proc(t: ^testing.T, name: string, tt: $T, test: proc(t: ^testing.T, tt: T) -> bool) {
    success := test(t, tt)
	if !success || testing.failed(t) {
		testing.fail_now(t, name)
	}
}

expect_slice :: proc(t: ^testing.T, values, expecteds: $T/[]$E, loc := #caller_location, value_expr := #caller_expression(values)) -> bool {
    if len(values) != len(expecteds) {
		log.errorf("expected %v to be %v, got different len (want: %d, got: %d), got values: %v", value_expr, expecteds, len(expecteds), len(values), values, location=loc)
    }
    failed := false
    for value, i in values {
        expected := expecteds[i]
        if !testing.expect_value(t, value, expected, loc = loc) {
            log.errorf("dismatch in index %d", i)
            failed = true
        }
    }

    if failed {
        log.errorf("expected values: %v, got values %v", expecteds, values)
        return false
    }

    return true
}
