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

new :: proc(input: io.Reader, allocator := context.allocator) -> (l: Lexer, err: Error) {
	l = Lexer {
		r         = input,
		allocator = allocator,
	}

	step(&l) or_return
	return l, nil
}

read_all :: proc(l: ^Lexer) -> (result: []token.Token, err: Error) {
    toks := make([dynamic]token.Token, allocator = l.allocator)
    for {
        tok := next_token(l) or_return
        append(&toks, tok)
    }

    return toks[:], nil
}

next_token :: proc(l: ^Lexer) -> (tok: token.Token, err: Error) {
	defer if err == nil {
		err = step(l)
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
	case 0:
		return token.new(.EOF, l.ch), nil
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
			},
		},
	}

	for tt in tts {
		misc.run_tt(t, tt.input, tt, proc(t: ^testing.T, tt: Test_Case) -> bool {
			r := misc.string_to_stream(tt.input, context.allocator)
			l, l_err := new(r, context.allocator)
            testing.expect(t, l_err == nil) or_return
            

            got, read_err := read_all(&l)
            testing.expect(t, read_err == nil) or_return
            
            misc.expect_slice(t, got, tt.want)
            return true
		})
	}
}



step :: proc(l: ^Lexer) -> (err: Error) {
	ch, _ := io.read_rune(l.r) or_return
    l.ch = ch
    return nil
}

Error :: union {
	io.Error,
}
