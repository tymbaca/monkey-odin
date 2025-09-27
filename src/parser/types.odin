package parser

import "core:dynlib"

Program :: struct {
	stmts: [dynamic]Statement,
}

Expression :: union {
	Int_Literal,
	Identifier,
}

Statement :: union {
	Let,
    Return,
}

Identifier :: struct {
	name: string,
}

Int_Literal :: struct {
	val: int,
}

Infix_Operator :: struct {
    op: string,
    left, right: Expression,
}

Prefix_Operator :: struct {
    op: string,
    right: Expression,
}

Let :: struct {
	name: Identifier,
	val:  Expression,
}

Return :: struct {
	val:  Expression,
}
