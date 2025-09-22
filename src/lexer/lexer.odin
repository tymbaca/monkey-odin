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
	ch:        rune,
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

    if type, ok := token.from_rune[l.ch]; ok {
        switch type {
        case .LT
        }

        tok = token.new(type, l.ch)
		step(l)
        return tok
    } 
    if is_letter(l.ch) {
        return read_multichar(l)
    } 
    if is_digit(l.ch) || l.ch == '.' {
        return read_multidigit(l)
    } 


    return token.new(.Illegal, l.ch)
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

read_multidigit :: proc(l: ^Lexer) -> (tok: token.Token) {
    start := l.pos
	for is_digit(l.ch) || l.ch == '.' {
        step(l)
	}
    end := l.pos

    literal := l.input[start:end]
    
    return token.Token{
        type = multidigit_type(literal),
        literal = literal,
    }
}

multidigit_type :: proc(literal: string) -> (type: token.Token_Type) {
    if strings.ends_with(literal, ".") {
        return .Illegal
    }

    if dots := strings.count(literal, "."); dots > 0 {
        if dots > 1 {
            return .Illegal
        }

        return .Float
    }

    return .Int
}

// called just before reading a token
step :: proc(l: ^Lexer) {
	assert(l.pos <= len(l.input)+1)
	if l.read_pos >= len(l.input) {
		l.ch = 0
		l.pos = l.read_pos
		return
	} else {
        l.ch = rune(l.input[l.read_pos]) // WARN: 
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

is_digit :: proc(ch: rune) -> bool {
	return unicode.is_digit(ch)
}

Error :: union {
	io.Error,
}
