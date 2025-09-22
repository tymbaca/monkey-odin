package lexer

import "core:strings"
import "base:runtime"
import "core:io"
import "core:mem"
import "core:testing"
import "core:unicode"
import "src:misc"
import "src:token"

Lexer :: struct {
	ch:        string, // only 1 rune
	pos:       int,
	read_pos:  int,
	input:     string,
	allocator: mem.Allocator, // owns all token string literals
}

new :: proc(input: string, allocator := context.allocator) -> (l: Lexer) {
	l = Lexer {
		input     = input,
		allocator = allocator,
	}

    step(&l)
	return l
}

read_all_tokens :: proc(l: ^Lexer) -> (result: []token.Token) {
	toks := make([dynamic]token.Token, allocator = l.allocator)
	tok: token.Token

	for tok.type != .EOF { 
		tok = next_token(l)
		append(&toks, tok)
	}

	return toks[:]
}

next_token :: proc(l: ^Lexer) -> (tok: token.Token) {
    skip_whitespace(l)

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
            tok = read_multichar(l)
		} else {
			tok = token.new(.Illegal, l.ch)
		}
	}

	step(l)
	return tok
}

read_multichar :: proc(l: ^Lexer) -> (tok: token.Token) {
    start := l.pos
	for is_letter(l.ch) {
        step(l)
	}
    end := l.pos

    literal := l.input[start:end]
    
    return token.Token{
        type = token.keywords[literal] or_else .Ident,
        literal = literal,
    }
}


// called just before reading a token
step :: proc(l: ^Lexer) {
    defer {
        assert(l.pos <= len(l.input)+1)
        assert(strings.rune_count(l.ch) == 1)
    }

	if l.read_pos >= len(l.input) {
		l.ch = 
		l.pos = l.read_pos
		return
	} else {
        l.ch = l.input[l.pos:l.read_pos]
    }

    l.pos = l.read_pos
    l.read_pos += 1
}

skip_whitespace :: proc(l: ^Lexer) {
    for is_whitespace(l.ch) {
        step(l)
    }
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
