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

token_type_to_string :: [Token_Type]string {
	.Illegal = "ILLEGAL",
	.EOF = "EOF",
	.Ident = "IDENT",
	.Int = "INT",
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

keywords := map[string]Token_Type {
	"fn"  = .Function,
	"let" = .Let,
}


Token :: struct {
    type: Token_Type,
    literal: string,
}

new :: proc(type: Token_Type, literal: string) -> Token {
    return Token{type = type, literal = literal}
}
