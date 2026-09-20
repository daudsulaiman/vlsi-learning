## Problem 01 Two Input Signal Selector

Design a 2-to-1 multiplexer: a combinational circuit that selects one of two signals and sends it to the output.

Write your design in verilog/01-mux/rtl/mux2.v

## Interface
Module name: mux2
| Port |Direction|Width|   Description   |
|------|---------|-----|-----------------|
|  a   |  Input  |1 bit|First data input |
|  b   |  Input  |1 bit|Second data input|
| sel  |  Input  |1 bit|  Select signal  |
|  y   |  Output |1 bit|  Selected data  |

## Required behavior
- when sel = 0, y must equal a.
- when sel = 1, y must equal b.
- the circuit has no clock and no stored state.

## Constraint
- Write the entire module yourself, including its ports.
- Use a continuous assignment (assign).
- You may use either Boolean operators or the conditional operator.
- Keep the module and port names exactly as specified so your existing testbench can connect to them.

## before simulation
Predict the output for each case:
|Case|a|b|sel|y|
|----|-|-|---|-|
| 1  |0|1| 0 |?|
| 2  |0|1| 1 |?|
| 3  |1|0| 0 |?|
| 4  |1|0| 1 |?|
| 5  |1|1| 0 |?|
| 6  |0|0| 1 |?|

Then answer this question:
if sel = 0 and only b changes, should y change? expalin why.
