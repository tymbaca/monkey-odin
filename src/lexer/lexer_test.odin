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
                token.by_type[.Assign],
				token.by_type[.Plus],
				token.by_type[.LBrace],
				token.by_type[.RBrace],
				token.by_type[.LParen],
				token.by_type[.RParen],
				token.by_type[.Comma],
				token.by_type[.Semicolon],
				token.by_type[.EOF],
			},
		},
		{
			input = "let n = fn;\n let double = n + n",
			want = {
                token.by_type[.Let],
				{.Ident, "n"},
                token.by_type[.Assign],
                token.by_type[.Function],
                token.by_type[.Semicolon],
                token.by_type[.Let],
				{.Ident, "double"},
                token.by_type[.Assign],
				{.Ident, "n"},
                token.by_type[.Plus],
				{.Ident, "n"},
                token.by_type[.EOF],
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
