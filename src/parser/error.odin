package parser

import "src:token"

Error :: union {
    Unexpected_Token_Error,
}

Unexpected_Token_Error :: struct {
    expected, got: token.Token,
}
