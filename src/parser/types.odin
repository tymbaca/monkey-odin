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
	// If,
	Let,
}

Identifier :: struct {
	name: string,
}

Int_Literal :: struct {
	val: int,
}

// If :: struct {
//     cond: Expression,
//     body: ^Statement,
//     alt: Maybe(^Statement),
// }

Let :: struct {
	name: Identifier,
	val:  Expression,
}
