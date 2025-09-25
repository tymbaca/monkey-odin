package main

import "core:log"
import "core:os"
import "src:lexer"
import "src:token"
import "src:misc"
import "src:repl"

main :: proc() {
    err := repl.start(os.stream_from_handle(os.stdin), os.stream_from_handle(os.stdout), context.allocator)
    if err != nil {
        log.panic(err)
    }
    
}
