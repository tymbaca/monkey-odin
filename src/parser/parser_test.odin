package parser

import "core:testing"
import "src:lexer"
import "src:misc"

@(test)
parse_test :: proc(t: ^testing.T) {
	Test_Case :: struct {
		input: string,
		want:  []Statement,
	}

	tts := []Test_Case {
		{
			input = `let a = 5; let foo = 12; let bar = 123;`,
			want = {
				Let{name = Identifier{name = "a"}, val = Int_Literal{val = 5}},
				Let{name = Identifier{name = "foo"}, val = Int_Literal{val = 12}},
				Let{name = Identifier{name = "bar"}, val = Int_Literal{val = 123}},
			},
		},
	}

	for tt in tts {
		misc.run_tt(t, tt.input, tt, proc(t: ^testing.T, tt: Test_Case) -> bool {
			defer free_all(context.allocator)

			l := lexer.new(tt.input, context.allocator)
			p := new(&l)

			program := parse(&p)
			misc.expect_slice(t, program.stmts[:], tt.want, log_values = true) or_return
			return true
		}) or_break
	}
}
