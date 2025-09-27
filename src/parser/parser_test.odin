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
			input = `let a = 5; let foo = 12; let bar = foo`,
			want = {
				Let{name = Identifier{"a"}, val = Int_Literal{5}},
				Let{name = Identifier{"foo"}, val = Int_Literal{12}},
				Let{name = Identifier{"bar"}, val = Identifier{"foo"}},
			},
		},
		{
			input = `
                return 5;
                return 43;
                return foo;
            `,
			want = {
                Return{val = Int_Literal{val = 5}},
                Return{val = Int_Literal{val = 5}},
                Return{val = Identifier{"foo"}},
			},
		},
	}

	for tt in tts {
		misc.run_tt(t, tt.input, tt, proc(t: ^testing.T, tt: Test_Case) -> bool {
			defer free_all(context.allocator)

			l := lexer.new(tt.input, context.allocator)
			p := new(&l)

			program, err := parse(&p)
            testing.expect_value(t, err, nil) or_return
			misc.expect_slice(t, program.stmts[:], tt.want, log_values = true) or_return
			return true
		}) or_break
	}
}
