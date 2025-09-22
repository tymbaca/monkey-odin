package lexer

import "core:testing"
import "src:misc"
import "src:token"

@(test)
next_token_test :: proc(t: ^testing.T) {
	Test_Case :: struct {
		input: string,
		want:  []token.Token,
	}

	tts := []Test_Case {
		{
			input = "=\t+{} (),\n;\n\r",
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
		{
			input = "let num = fn;\n let double = num + num",
			want = {
				{.Let, "let"},
				{.Ident, "num"},
				{.Assign, '='},
				{.Function, "fn"},
				{.LBrace, '{'},
				{.RBrace, '}'},
				{.LParen, '('},
				{.RParen, ')'},
				{.Comma, ','},
				{.Semicolon, ';'},
				{.EOF, 0},
			},
		},
		{
			input = "",
			want = {
				{.EOF, 0},
			},
		},
		{
			input = "   \t \n\n\r \t",
			want = {
				{.EOF, 0},
			},
		},
	}

	for tt in tts {
		misc.run_tt(t, tt.input, tt, proc(t: ^testing.T, tt: Test_Case) -> bool {
			defer free_all(context.allocator)

			l := new(tt.input, context.allocator)

			got := read_all_tokens(&l)
			misc.expect_slice(t, got, tt.want, log_values = true) or_return
			return true
		})
	}
}
