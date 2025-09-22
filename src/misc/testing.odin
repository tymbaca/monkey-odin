package misc

import "core:fmt"
import "core:strconv"
import "core:testing"
import "core:log"

run_tt :: proc(t: ^testing.T, name: string, tt: $T, test: proc(t: ^testing.T, tt: T) -> bool, loc := #caller_location) -> bool {
    success := test(t, tt)
	if !success || testing.failed(t) {
        log.errorf("failed testcase: \"%s\"", name, location = loc)
        return false
	}

    return true
}

expect_slice :: proc(t: ^testing.T, values, expecteds: $T/[]$E, loc := #caller_location, values_expr := #caller_expression(values), expecteds_expr := #caller_expression(expecteds), log_values := false) -> (ok: bool) {
    ok = true

    if len(values) != len(expecteds) {
        log.errorf("different len: len(%v) == %d, len(%v) == %d", values_expr, len(values), expecteds_expr, len(expecteds), location = loc)
        ok = false
    }

    if ok {
        for value, i in values {
            expected := expecteds[i]
            if !testing.expect_value(t, value, expected, loc = loc, value_expr = fmt.aprintf("values[%d]", i, allocator = t._log_allocator)) {
                ok = false
            }
        }
    }

    if !ok {
        if log_values {
            log.errorf("\n\texpected (%v) values: %v, \n\tgot (%v) values %v", expecteds_expr, expecteds, values_expr, values, location = loc)
        }
        return false
    }

    return true
}
