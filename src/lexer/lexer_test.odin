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
			input = `
                fn add(n1, n2) {
                    return n1 + n2;
                }`,
			want = {
				token.by_type[.Function],
                {.Ident, "add"},
				token.by_type[.LParen],
                {.Ident, "n1"},
				token.by_type[.Comma],
                {.Ident, "n2"},
				token.by_type[.RParen],

				token.by_type[.LBrace],
				token.by_type[.Return],
                {.Ident, "n1"},
				token.by_type[.Plus],
                {.Ident, "n2"},
				token.by_type[.Semicolon],
				token.by_type[.RBrace],
				{.EOF, 0},
			},
		},
        {
            input = `
                fn isEven(n) {
                    if n % 2 == 0 {
                        return true;
                    } else {
                        return false;
                    }
                }`,
            want = {
				token.by_type[.Function],
                {.Ident, "isEven"},
				token.by_type[.LParen],
                {.Ident, "n"},
				token.by_type[.RParen],

                token.by_type[.LBrace],

                token.by_type[.If],
                {.Ident, "n"},
                token.by_type[.Rem],
                {.Int, "2"},
                token.by_type[.Equal],
                {.Int, "0"},
                token.by_type[.LBrace],
                token.by_type[.Return],
                token.by_type[.True],
                token.by_type[.Semicolon],
                token.by_type[.RBrace],

                token.by_type[.Else],
                token.by_type[.LBrace],
                token.by_type[.Return],
                token.by_type[.False],
                token.by_type[.Semicolon],
                token.by_type[.RBrace],

                token.by_type[.RBrace],

                token.by_type[.EOF],
            },
        },
		{
			input = "=\t+{} (),\n;\n\r < <= > >= ! != == =", // last '=' to check if peek will go out of bounds
			want = {
                token.by_type[.Assign],
				token.by_type[.Plus],
				token.by_type[.LBrace],
				token.by_type[.RBrace],
				token.by_type[.LParen],
				token.by_type[.RParen],
				token.by_type[.Comma],
				token.by_type[.Semicolon],             

                token.by_type[.LT],
                token.by_type[.LE],
                token.by_type[.GT],
                token.by_type[.GE],
                token.by_type[.Bang],
                token.by_type[.Not_Equal],
                token.by_type[.Equal],

                token.by_type[.Assign],

				token.by_type[.EOF],
			},
		},
		{
			input = "let n = 432;\n let num = 56.387 + n; num = num + 5;",
			want = {
                token.by_type[.Let],
				{.Ident, "n"},
                token.by_type[.Assign],
                {.Int, "432"},
                token.by_type[.Semicolon],
                
                token.by_type[.Let],
				{.Ident, "num"},
                token.by_type[.Assign],
				{.Float, "56.387"},
                token.by_type[.Plus],
				{.Ident, "n"},
                token.by_type[.Semicolon],

				{.Ident, "num"},
                token.by_type[.Assign],
				{.Ident, "num"},
                token.by_type[.Plus],
				{.Int, "5"},
                token.by_type[.Semicolon],

                token.by_type[.EOF],
			},
		},
		{
			input = ".3, .190, 1.9, 99.999",
			want = {
                {.Float, ".3"},
                token.by_type[.Comma],
                {.Float, ".190"},
                token.by_type[.Comma],
                {.Float, "1.9"},
                token.by_type[.Comma],
                {.Float, "99.999"},
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
		}) or_break
	}
}
