# FPGA

FPGA labs

# Lab0

## Task 1 Multiplexer
[mux](./mux/)

| Signal      | Direction | Bit size | Comment                                |
|-------------|-----------|----------|----------------------------------------|
| data0_i     | input     | 2        | Input data #0                          |
| data1_i     | input     | 2        | Input data #1                          |
| data2_i     | input     | 2        | Input data #2                          |
| data3_i     | input     | 2        | Input data #3                          |
| direction_i | input     | 2        | The input number for use at the output |
| data_o      | output    | 2        | Output data                            |

## Task 2 Priority Encoder
[priority_encoder_4](./priority_encoder_4)

| Signal       | Direction | Bit size | Comment                     |
|--------------|-----------|----------|-----------------------------|
| data_i       | input     | 4        | Input data                  |
| data_val_i   | input     | 1        | Validity of the input data  |
| data_left_o  | output    | 4        | The output leftmost bit     |
| data_right_o | output    | 4        | The output rightmost bit    |
| data_val_o   | output    | 1        | Validity of the output data |
