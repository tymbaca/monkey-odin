package parser

import "core:mem"
import "src:lexer"
import "src:token"

Parser :: struct {
	l:        ^lexer.Lexer,
	cur_tok:  token.Token,
	next_tok: token.Token,

    allocator: mem.Allocator,
}

new :: proc(l: ^lexer.Lexer, allocator := context.allocator) -> Parser {
	p := Parser {
		l = l,

	}

	step(&p)
	step(&p)
	return p
}

parse :: proc(p: ^Parser) -> Program {
	program := Program{
        stmts = make([dynamic]Statement, p.allocator),
    }

    for p.cur_tok.type != .EOF {
        stmt := parse_statement(p)
        if stmt != nil {
            append(&program.stmts, stmt)
        }
        
        step(p)
    }

	return {}
}

@(private)
parse_statement :: proc(p: ^Parser) -> (stmt: Statement, err: Error) {
    switch p.cur_tok.type {
    case .Let:
        step(p)
        let := Let{}
        if p.cur_tok.type != .Ident {
            return {}, Unexpected_Token_Error{expected = token.Token{type = .Ident}, got = p.cur_tok}
        }
        let.name = Identifier{name = p.cur_tok.literal.(string)}

        step(p)
        if p.cur_tok.type != .Assign {
            return {}, Unexpected_Token_Error{expected = token.Token{type = .Ident}, got = p.cur_tok}
        }


    }
    return {}, nil
}

step :: proc(p: ^Parser) {
	p.cur_tok = p.next_tok
	p.next_tok = lexer.read_token(p.l)
}

expect_token_type :: proc(target: token.Token, to_have_type: token.Token_Type) -> (err: Error) {
    if target.type != to_have_type {
        return Unexpected_Token_Error{expected = token.Token{type = to_have_type}, got = target}
    }

    return nil
}
