package misc

import "core:bytes"
import "core:io"

string_to_stream :: #force_inline proc(str: string, allocator := context.allocator) -> io.Stream {
	b := new(bytes.Buffer, allocator = allocator)
	bytes.buffer_init_string(b, str)
	return bytes.buffer_to_stream(b)
}
