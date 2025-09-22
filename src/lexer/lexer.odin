package lexer

import "core:unicode"
import "base:runtime"
import "core:io"
import "core:mem"
import "core:testing"
import "src:misc"
import "src:token"

Lexer :: struct {
	ch:        rune,
	r:         io.Reader,
	allocator: mem.Allocator, // owns all token string literals
}

new :: proc(input: io.Reader, allocator := context.allocator) -> (l: Lexer) {
	l = Lexer {
		r         = input,
		allocator = allocator,
	}

	return l
}

read_all_tokens :: proc(l: ^Lexer) -> (result: []token.Token, err: Error) {
	toks := make([dynamic]token.Token, allocator = l.allocator)
	for {
		tok := next_token(l) or_return
		append(&toks, tok)

		if tok.type == .EOF {
			break
		}
	}

	return toks[:], nil
}

next_token :: proc(l: ^Lexer) -> (tok: token.Token, err: Error) {
	switch l.ch {
	case '(':
		tok = token.new(.LParen, l.ch)
	case ')':
		tok = token.new(.RParen, l.ch)
	case '{':
		tok = token.new(.LBrace, l.ch)
	case '}':
		tok = token.new(.RBrace, l.ch)
	case '=':
		tok = token.new(.Assign, l.ch)
	case '+':
		tok = token.new(.Plus, l.ch)
	case ',':
		tok = token.new(.Comma, l.ch)
	case ';':
		tok = token.new(.Semicolon, l.ch)
	case ':':
		tok = token.new(.Semicolon, l.ch)
	case 0:
        tok = token.new(.EOF, 0)
	case:
        if is_letter(l.ch) {

        } else {
            tok = token.new(.Illegal, l.ch)
        }
    }

    step(l) or_return
    return tok, nil
}

read_ident_or_keyword :: proc(l: ^Lexer) -> (tok: token.Token, err: Error) {
    // for 
}


// called just before reading a token
step :: proc(l: ^Lexer) -> (err: Error) {
	ch, _ := io.read_rune(l.r) or_return
	if err == .EOF {
        l.ch = 0
        return nil
	}
	if err != nil {
		return err
	}

	l.ch = ch
	return nil
}

is_whitespace :: proc(ch: rune) -> bool {
    return unicode.is_white_space(ch)
}

is_letter :: proc(ch: rune) -> bool {
    return unicode.is_letter(ch)
}

Error :: union {
	io.Error,
}
