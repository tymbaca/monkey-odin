package lexer

import "core:testing"
import "src:misc"

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
