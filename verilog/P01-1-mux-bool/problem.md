**Goal:** derive a mux from its behavior without the ternary operator.
**Prerequisites:** the earlier 1-bit mux; `assign`; NOT, AND, OR; notes A–C and D1.
**Difficulty:** basic; the interface and behavior stay the same.

**Module:** `p01_mux_bool`
**RTL:** `rtl/p01_mux_bool.v`
**Testbench:** `tb/p01_mux_bool_tb.v` / module `p01_mux_bool_tb`

| Port | Direction | Width |
|------|-----------|-------|
|   a  |   input   |   1   |
|   b  |   input   |   1   |
|  sel |   input   |   1   |
|   y  |   output  |   1   |

**Expected behavior:** when `sel` is 0, `y` equals `a`. When `sel` is 1, `y` equals `b`. There is no stored value.

**Constraints:** use `assign`, `~`, `&`, and `|` for the logic. Parentheses and internal wire declarations are allowed. Do not use `?:`, `!`, `&&`, or `||`. Do not instantiate another RTL module.

**Testing tasks:**

1. Fill all eight rows of the P01 prediction table in `notes.md` before writing RTL.
2. Write your expression and explain how it meets both select conditions.
3. Run the supplied display-only TB. Compare every row manually and record any mismatch.
4. Explain why testing only cases where `a` equals `b` is weak.

**Review evidence:** truth table, RTL, output log or copied results, and a short gate-level explanation. No waveform or synthesis is required.
