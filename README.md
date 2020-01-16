# What is the goal of this repository?

I recently encounter an issue to efficiently techmap a fifo into a 1-clock Dual-Port RAM *(DPRAM)*. 

I provide 2 cases, a small one with a fifo and his wrapper and a larger one with a real design and a wrapper on top to merge read-clock and write-clock. Scripts, netlists and libraries used can respectively be found at **./yosys_script**, **Verilog_netlists** and **my_lib**.

## Small case

Small case synthesys can be run without any modification to the script with the command:
```bash
yosys -s yosys_script/small_case.ys
```

This case perfectly works and provide results at **./results/small_case**.

## Larger case

This case integrates a complete design on top of which a wrapper as been set to merge read-clock and write-clock.

Small case synthesys can be run without any modification to the script with the command:
```bash
yosys -s yosys_script/larger_case.ys
```

This case fails at flattening (through synth command) and provides the following error message:
"ERROR: Technology map yielded processes -> this is not supported (use -autoproc to run 'proc' automatically)."

According to the [documentation](http://www.clifford.at/yosys/cmd_flatten.html), flattening is quite similar to techmapping and it could explain why this message appears.

I absolutely need to flatten to be able to techmap the fifo to my DPRAM, otherwise the fifo is syntesized as an independant module and do not care about the clock merging.
