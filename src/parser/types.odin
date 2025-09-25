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
}

Identifier :: struct {
	name: string,
}

Int_Literal :: struct {
	val: int,
}

Let :: struct {
	name: Identifier,
	val:  Expression,
}
