package parser

import "src:lexer"
import "src:token"

Parser :: struct {
	l:        ^lexer.Lexer,
	cur_tok:  token.Token,
	next_tok: token.Token,
}

new :: proc(l: ^lexer.Lexer) -> Parser {
	p := Parser {
		l = l,
	}

    step(&p)
    step(&p)
    return p
}

parse :: proc(p: ^Parser) -> Program {
    return {}
}

step :: proc(p: ^Parser) {
	p.cur_tok = p.next_tok
	p.next_tok = lexer.read_token(p.l)
}
