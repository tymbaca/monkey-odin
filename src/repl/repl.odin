package repl

import "core:fmt"
import "base:runtime"
import "core:bufio"
import "core:io"
import "src:lexer"

PROMT :: ">> "

start :: proc(r: io.Reader, w: io.Writer, allocator := context.allocator) -> Error {
	scanner: bufio.Scanner
	bufio.scanner_init(&scanner, r, allocator)

	for {
		io.write_string(w, PROMT)
		ok := bufio.scanner_scan(&scanner)
		if !ok {
			return bufio.scanner_error(&scanner)
		}

		line := bufio.scanner_text(&scanner)

		l := lexer.new(line, allocator)
		tokens := lexer.read_all_tokens(&l)
        for tok in tokens {
            fmt.wprintln(w, tok)
        }
	}
}

Error :: union {
	bufio.Scanner_Error,
}
