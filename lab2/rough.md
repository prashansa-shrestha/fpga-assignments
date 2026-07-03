# Control Unit Rough Plans

## Inputs:

instruction in [19 bits]

## Outputs:
- pcsel -> in[0]
- alusel -> in[1:3]
- immediate_sel -> in[4]
- r_outsel -> in[5:7]
- r1sel -> in[13:15]
- immediateval -> in[8:15]
- r2sel -> in[16:18]

## Program Counter
- pc_output set using 2:1 mux
- pc_val1 -> pc_output + 1
- pc_val2 -> immediateval