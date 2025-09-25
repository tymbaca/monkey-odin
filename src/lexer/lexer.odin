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

	for { 
		tok = read_token(l)
        if tok.type == .EOF {
            break
        }

		append(&toks, tok)
	}

	return toks[:]
}

read_token :: proc(l: ^Lexer) -> (tok: token.Token) {
    skip_whitespace(l)


    switch l.ch {
    case '=':
        if peek(l) == '=' {
            step(l)
            tok = token.new(.Equal, "==")
        } else {
            tok = token.new(.Assign, l.ch)
        }
    case '+':
        tok = token.new(.Plus, l.ch)
    case '-':
        tok = token.new(.Minus, l.ch)
    case '*':
        tok = token.new(.Asteriks, l.ch)
    case '/':
        tok = token.new(.Slash, l.ch)
    case '<':
        if peek(l) == '=' {
            step(l)
            tok = token.new(.LE, "<=")
        } else {
            tok = token.new(.LT, l.ch)
        }
    case '>':
        if peek(l) == '=' {
            step(l)
            tok = token.new(.GE, ">=")
        } else {
            tok = token.new(.GT, l.ch)
        }
    case '!':
        if peek(l) == '=' {
            step(l)
            tok = token.new(.Not_Equal, "!=")
        } else {
            tok = token.new(.Bang, l.ch)
        }
    case '%':
        tok = token.new(.Rem, l.ch)
    case ',':
        tok = token.new(.Comma, l.ch)
    case ';':
        tok = token.new(.Semicolon, l.ch)
    case '(':
        tok = token.new(.LParen, l.ch)
    case ')':
        tok = token.new(.RParen, l.ch)
    case '{':
        tok = token.new(.LBrace, l.ch)
    case '}':
        tok = token.new(.RBrace, l.ch)
    case 0:
        tok = token.new(.EOF, l.ch)
    case:
        if is_letter(l.ch) {
            return read_multichar(l)
        } 
        if is_digit(l.ch) || l.ch == '.' {
            return read_multidigit(l)
        } 

        tok = token.new(.Illegal, l.ch)
    }

    step(l)
    return tok
}

@(private)
read_multichar :: proc(l: ^Lexer) -> (tok: token.Token) {
    start := l.pos
	for is_letter(l.ch) || is_digit(l.ch) {
        step(l)
	}
    end := l.pos

    literal := l.input[start:end]
    
    return token.Token{
        type = token.keywords[literal] or_else .Ident,
        literal = literal,
    }
}

@(private)
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


@(private)
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
@(private)
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

// it's like step, but it only shows next char, whithout actually advancing
@(private)
peek :: proc(l: ^Lexer) -> rune {
    if l.read_pos >= len(l.input) {
        return 0
    }

    return rune(l.input[l.read_pos])
}

@(private)
skip_whitespace :: proc(l: ^Lexer) {
    for is_whitespace(l.ch) {
        step(l)
    }
}

@(private)
is_whitespace :: proc(ch: rune) -> bool {
	return unicode.is_white_space(ch)
}

@(private)
is_letter :: proc(ch: rune) -> bool {
	return unicode.is_letter(ch)
}

@(private)
is_digit :: proc(ch: rune) -> bool {
	return unicode.is_digit(ch)
}

Error :: union {
	io.Error,
}
