#+feature dynamic-literals
package token        

import "base:builtin"
Token_Type :: enum {
	Illegal,
	EOF,

	Ident,
	Int,
    Float,

	Assign,
	Plus,
	Minus,
	Slash,
	Asteriks,
    Equal,
    Not_Equal,
    LT,
    LE,
    GT,
    GE,
    Bang,

	Comma,
	Semicolon,

	LParen,
	RParen,
	LBrace,
	RBrace,


	Function,
	Let,
}

// only token types that can have one literal
by_type := map[Token_Type]Token{
    .EOF = {.EOF, 0},
    .Assign = {.Assign, '='},
    .Plus = {.Plus, '+'},
    .Minus = {.Minus, '-'},
    .Slash = {.Slash, '/'},
    .Asteriks = {.Asteriks, '*'},
    .Equal = {.Equal, "=="},
    .Not_Equal = {.Not_Equal, "!="},
    .LT = {.LT, "<"},
    .LE = {.LE, "<="},
    .GT = {.GT, ">"},
    .GE = {.GE, ">="},
    .Bang = {.Bang, "!"},
    .Comma = {.Comma, ','},
    .Semicolon = {.Semicolon, ';'},
    .LParen = {.LParen, '('},
    .RParen = {.RParen, ')'},
    .LBrace = {.LBrace, '{'},
    .RBrace = {.RBrace, '}'},
    .Function = {.Function, "fn"},
    .Let = {.Let, "let"},
}



from_rune := map[rune]Token_Type {
	'=' = .Assign,
	'+' = .Plus,
    '<' = .LT,
    '>' = .GT,
    '!' = .Bang,
	',' = .Comma,
	';' = .Semicolon,
	'(' = .LParen,
	')' = .RParen,
	'{' = .LBrace,
	'}' = .RBrace,
    0   = .EOF,
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
