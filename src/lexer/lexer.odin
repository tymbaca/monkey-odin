package lexer

import "base:runtime"
import "core:io"
import "core:mem"
import "core:testing"
import "src:misc"
import "src:token"

Lexer :: struct {
	ch:        rune,
	r:         io.Reader,
	allocator: mem.Allocator, // owns all token string literals
}

new :: proc(input: io.Reader, allocator := context.allocator) -> (l: Lexer) {
	l = Lexer {
		r         = input,
		allocator = allocator,
	}

	return l
}

read_all_tokens :: proc(l: ^Lexer) -> (result: []token.Token, err: Error) {
    toks := make([dynamic]token.Token, allocator = l.allocator)
    for {
        tok := next_token(l) or_return
        append(&toks, tok)
        
        if tok.type == .EOF {
            break
        }
    }

    return toks[:], nil
}

next_token :: proc(l: ^Lexer) -> (tok: token.Token, err: Error) {
    err = step(l)
    if err == .EOF {
		return token.new(.EOF, 0), nil
    }
    if err != nil {
        return token.Token{}, err
    }

	switch l.ch {
	case '(':
		return token.new(.LParen, l.ch), nil
	case ')':
		return token.new(.RParen, l.ch), nil
	case '{':
		return token.new(.LBrace, l.ch), nil
	case '}':
		return token.new(.RBrace, l.ch), nil
	case '=':
		return token.new(.Assign, l.ch), nil
	case '+':
		return token.new(.Plus, l.ch), nil
	case ',':
		return token.new(.Comma, l.ch), nil
	case ';':
		return token.new(.Semicolon, l.ch), nil
	case:
		return token.new(.Illegal, l.ch), nil
	}
}

@(test)
next_token_test :: proc(t: ^testing.T) {
	Test_Case :: struct {
		input: string,
		want:  []token.Token,
	}

	tts := []Test_Case {
		{
			input = "=+{}(),;",
			want = {
				{.Assign, '='},
				{.Plus, '+'},
				{.LBrace, '{'},
				{.RBrace, '}'},
				{.LParen, '('},
				{.RParen, ')'},
				{.Comma, ','},
				{.Semicolon, ';'},
				{.EOF, 0},
			},
		},
	}

	for tt in tts {
		misc.run_tt(t, tt.input, tt, proc(t: ^testing.T, tt: Test_Case) -> bool {
            defer free_all(context.allocator)

			r := misc.string_to_stream(tt.input, context.allocator)
			l := new(r, context.allocator)

            got, read_err := read_all_tokens(&l)
            testing.expect(t, read_err == nil) or_return
            misc.expect_slice(t, got, tt.want, log_values = true) or_return
            return true
		})
	}
}

// called just before reading a token
step :: proc(l: ^Lexer) -> (err: Error) {
	ch, _ := io.read_rune(l.r) or_return
    l.ch = ch
    return nil
}

Error :: union {
	io.Error,
}
