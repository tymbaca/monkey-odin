#+feature dynamic-literals
package token        

import "base:builtin"
Token_Type :: enum {
	Illegal,
	EOF,

	Ident,
	Int,

	Assign,
	Plus,

	Comma,
	Semicolon,

	LParen,
	RParen,
	LBrace,
	RBrace,

	Function,
	Let,
}

keywords := map[string]Token_Type {
	"fn"  = .Function,
	"let" = .Let,
}

Token :: struct {
    type: Token_Type,
    literal: Literal,
}

Literal :: union {
    string,
    rune,
}

new :: proc(type: Token_Type, literal: rune) -> Token {
    return Token{type = type, literal = literal}
}
