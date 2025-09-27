#+feature dynamic-literals
package token        

import "base:builtin"
Token_Type :: enum {
	Illegal,
	EOF,

	Assign,
    START_OPERATOR,
    // int/float
	Plus,
	Minus,
	Asteriks,
	Slash,
    Rem,
    // bool
    Equal,
    Not_Equal,
    LT,
    LE,
    GT,
    GE,
    Bang,
    END_OPERATOR,

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
    literal: Literal, // maybe make only string
}

Literal :: union {
    string,
    rune,
}

new :: proc(type: Token_Type, literal: Literal) -> Token {
    return Token{type = type, literal = literal}
}

is_operator :: proc(type: Token_Type) -> bool {
    return type > Token_Type.START_OPERATOR && type < Token_Type.END_OPERATOR
}

is_arithm_operator :: proc(type: Token_Type) -> bool {
    #partial switch type {
    case .Plus, .Minus, .Asteriks, .Slash:
        return true
    }

    return false
}
