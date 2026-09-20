## P02 — Make the data four bits wide

**Goal:** preserve mux behavior when each input is a bus.
**Prerequisites:** reviewed P01; vector width; ternary operator; notes C1–C2.
**Difficulty:** one variation: data width.

**Module:** `p02_mux4`
**RTL:** `rtl/p02_mux4.v`
**Testbench:** `tb/p02_mux4_tb.v` / module `p02_mux4_tb`

| Port | Direction |   Width    |
|------|-----------|------------|
| `a`  |   input   | 4, `[3:0]` |
| `b`  |   input   | 4, `[3:0]` |
| `sel`|   input   | 1          |
| `y`  |  output   | 4, `[3:0]` |

**Expected behavior:** `sel=0` selects all four bits of `a`. `sel=1` selects all four bits of `b`. One select controls the full bus.

**Constraints:** use a continuous assignment and `?:`. Keep every data port four bits wide. No child RTL module.

**Testing tasks:**

1. Predict the six supplied stimulus results before running the TB.
2. Add four distinct tests to the marked section. Include equal data inputs, different data inputs, a selected MSB of 1, and a change to an unselected input while select stays fixed.
3. Print each added result after a delay. Record your expected values in notes.
4. Explain the number of data-selection lanes and why the control is still one bit.

**Review evidence:** RTL, edited TB, at least ten observed cases, and one explanation of an output that stayed unchanged. This TB does not report automatic PASS.
