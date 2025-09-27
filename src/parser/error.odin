package parser

import "src:token"

Error :: union {
    Unexpected_Token_Error,
    Unsupported_Token_Error,
    Invalid_Token_Error,
}

Unexpected_Token_Error :: struct {
    expected_type: token.Token_Type,
    got: token.Token,
}

Invalid_Token_Error :: struct {
    code: Invalid_Token_Error_Code,
    got: token.Token,
}

Invalid_Token_Error_Code :: enum {
    Invalid_Int,
}

Unsupported_Token_Error :: struct {
    got: token.Token,
}
