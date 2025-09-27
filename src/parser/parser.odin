package parser

import "core:strconv"
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

parse :: proc(p: ^Parser) -> (program: Program, err: Error) {
	program = Program{
        stmts = make([dynamic]Statement, p.allocator),
    }

    for p.cur_tok.type != .EOF {
        stmt := parse_statement(p) or_return
        if stmt != nil {
            append(&program.stmts, stmt)
        }
        
        step(p)
    }

	return program, nil
}

@(private)
parse_statement :: proc(p: ^Parser) -> (stmt: Statement, err: Error) {
    #partial switch p.cur_tok.type {
    case .Let:
        return parse_let_statement(p)
        
    }

    return {}, Unsupported_Token_Error{p.cur_tok}
}

@(private)
parse_let_statement :: proc(p: ^Parser) -> (stmt: Let, err: Error) {
    step(p)
    let := Let{}
    expect_token_type(p.cur_tok, .Ident) or_return
    let.name = Identifier{name = p.cur_tok.literal.(string)}

    step(p)
    expect_token_type(p.cur_tok, .Assign) or_return

    step(p)
    let.val = parse_expression(p) or_return

    step(p)
    expect_token_type(p.cur_tok, .Semicolon) or_return

    return let, nil
}

@(private)
parse_expression :: proc(p: ^Parser) -> (expr: Expression, err: Error) {
    if token.is_operator(p.next_tok.type) {
        return parse_operator_expression(p)
    }

    return parse_single_expression(p)
}

@(private)
parse_single_expression :: proc(p: ^Parser) -> (expr: Expression, err: Error) {
    #partial switch p.cur_tok.type {
    case .Int:
        return parse_int_literal(p.cur_tok)
    case .Ident:
    }

    return {}, Unsupported_Token_Error{p.cur_tok}
}

@(private)
parse_operator_expression :: proc(p: ^Parser) -> (expr: Expression, err: Error) {
    // parse left
    return {}, Unsupported_Token_Error{}
}

parse_int_literal :: proc(tok: token.Token) -> (expr: Int_Literal, err: Error) {
    literal, to_str_ok := tok.literal.(string)
    if !to_str_ok {
        return {}, Invalid_Token_Error{.Invalid_Int, tok}
    }
    
    v, parse_ok := strconv.parse_int(literal)
    if !parse_ok {
        return {}, Invalid_Token_Error{.Invalid_Int, tok}
    }
    
    return Int_Literal{val = v}, nil
}

@(private)
step :: proc(p: ^Parser) {
	p.cur_tok = p.next_tok
	p.next_tok = lexer.read_token(p.l)
}

@(private)
expect_token_type :: proc(target: token.Token, to_have_type: token.Token_Type) -> (err: Error) {
    if target.type != to_have_type {
        return Unexpected_Token_Error{expected_type = to_have_type, got = target}
    }

    return nil
}
