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

token_type_to_string :: [Token_Type]string {
	.Illegal = "ILLEGAL",
	.EOF = "EOF",
	.Ident = "IDENT",
	.Int = "int",
	.Assign = "=",
	.Plus = "+",
	.Comma = ",",
	.Semicolon = ";",
	.LParen = "(",
	.RParen = ")",
	.LBrace = "{",
	.RBrace = "}",
	.Function = "fn",
	.Let = "let",
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
