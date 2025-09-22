#+feature dynamic-literals
package token        

import "base:builtin"
Token_Type :: enum {
	Illegal,
	EOF,

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
    Rem,

	Comma,
	Semicolon,

	LParen,
	RParen,
	LBrace,
	RBrace,

    // dynamic literals
	Ident,
	Int,
    Float,

	Function,
	Let,
    If,
    Else,
    True,
    False,
    Return,
}

by_type := [Token_Type]Token{
    .Illegal = {.Illegal, "ILLEGAL"},
    .Ident = {.Ident, "IDENT"},
    .Int = {.Int, "INT"},
    .Float = {.Float, "FLOAT"},

    .EOF = {.EOF, 0},
    .Assign = {.Assign, '='},
    .Plus = {.Plus, '+'},
    .Minus = {.Minus, '-'},
    .Slash = {.Slash, '/'},
    .Asteriks = {.Asteriks, '*'},
    .Equal = {.Equal, "=="},
    .Not_Equal = {.Not_Equal, "!="},
    .LT = {.LT, '<'},
    .LE = {.LE, "<="},
    .GT = {.GT, '>'},
    .GE = {.GE, ">="},
    .Bang = {.Bang, '!'},
    .Rem = {.Rem, '%'},

    .Comma = {.Comma, ','},
    .Semicolon = {.Semicolon, ';'},
    .LParen = {.LParen, '('},
    .RParen = {.RParen, ')'},
    .LBrace = {.LBrace, '{'},
    .RBrace = {.RBrace, '}'},

    .Function = {.Function, "fn"},
    .Let = {.Let, "let"},
    .If = {.If, "if"},
    .Else = {.Else, "else"},
    .True = {.True, "true"},
    .False = {.False, "false"},
    .Return = {.Return, "return"},
}


keywords := map[string]Token_Type {
	"fn"  = .Function,
	"let" = .Let,
    "if" = .If,
    "else" = .Else,
    "true" = .True,
    "false" = .False,
    "return" = .Return,
}

Token :: struct {
    type: Token_Type,
    literal: Literal,
}

Literal :: union {
    string,
    rune,
}

new :: proc(type: Token_Type, literal: Literal) -> Token {
    return Token{type = type, literal = literal}
}
