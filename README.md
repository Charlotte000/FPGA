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

## Task 3 Delay line
[delay_15](./delay_15)

| Signal       | Direction | Bit size | Comment                                            |
|--------------|-----------|----------|----------------------------------------------------|
| clk_i        | input     | 1        | Clock signal                                       |
| rst_i        | input     | 1        | Asynchronous reset                                 |
| data_i       | input     | 1        | Input data                                         |
| data_delay_i | input     | 4        | Number of clock cycles for delay                   |
| data_o       | output    | 1        | data_i signal delayed by data_delay_i clock cycles |

## Task 4 CRC-16-ANSI
[crc_16_ansi](./crc_16_ansi)

| Signal       | Direction | Bit size | Comment                                 |
|--------------|-----------|----------|-----------------------------------------|
| clk_i        | input     | 1        | Clock signal                            |
| rst_i        | input     | 1        | Asynchronous reset                      |
| data_i       | input     | 1        | Input data                              |
| data_o       | output    | 16       | The result of the CRC-16-ANSI algorithm |

# Lab1

## Task 1 Serializer
[serializer](./serializer)

| Signal         | Direction | Bit size | Comment                      |
|----------------|-----------|----------|------------------------------|
| clk_i          | input     | 1        | Clock signal                 |
| srst_i         | input     | 1        | Synchronous reset            |
| data_i         | input     | 16       | Input data                   |
| data_mod_i     | input     | 4        | The number of valid bits     |
| data_val_i     | input     | 1        | Is data valid                |
| ser_data_o     | output    | 1        | Serialized data              |
| ser_data_val_o | output    | 1        | Is ser_data_o valid          |
| busy_o         | output    | 1        | Is serialization module busy |

## Task 2 Deserializer
[deserializer](./deserializer)

| Signal           | Direction | Bit size | Comment               |
|------------------|-----------|----------|-----------------------|
| clk_i            | input     | 1        | Clock signal          |
| srst_i           | input     | 1        | Synchronous reset     |
| data_i           | input     | 1        | Input data            |
| data_val_i       | input     | 1        | Is data valid         |
| deser_data_o     | output    | 16       | Deserialized data     |
| deser_data_val_o | output    | 1        | Is deser_data_o valid |

## Task 3 Priority Encoder
[priority_encoder](./priority_encoder)

| Parameter | Comment    |
|-----------|------------|
| WIDTH     | Data width |

| Signal       | Direction | Bit size | Comment                  |
|--------------|-----------|----------|--------------------------|
| clk_i        | input     | 1        | Clock signal             |
| srst_i       | input     | 1        | Synchronous reset        |
| data_i       | input     | WIDTH    | Input data               |
| data_val_i   | input     | 1        | Is data valid            |
| data_left_o  | output    | WIDTH    | The output leftmost bit  |
| data_right_o | output    | WIDTH    | The output rightmost bit |
| data_val_o   | output    | 1        | Is data_o valid          |

## Task 4 Bit Population Counter
[bit_population_counter](./bit_population_counter)

| Parameter | Comment    |
|-----------|------------|
| WIDTH     | Data width |

| Signal     | Direction | Bit size          | Comment           |
|------------|-----------|-------------------|-------------------|
| clk_i      | input     | 1                 | Clock signal      |
| srst_i     | input     | 1                 | Synchronous reset |
| data_i     | input     | WIDTH             | Input data        |
| data_val_i | input     | 1                 | Is data_i valid   |
| data_o     | output    | $clog2(WIDTH) + 1 | Output data       |
| data_val_o | output    | 1                 | Is data_o valid   |

## Task 5 Debouncer
[debouncer](./debouncer)

| Parameter      | Comment                        |
|----------------|--------------------------------|
| CLK_FREQ_MHZ   | clk_i frequency, MHz           |
| GLITCH_TIME_NS | The max time of the glitch, ns |

| Signal            | Direction | Bit size          | Comment                                  |
|-------------------|-----------|-------------------|------------------------------------------|
| clk_i             | input     | 1                 | Clock signal                             |
| key_i             | input     | 1                 | Button signal. 0 - pressed, 1 - released |
| key_pressed_stb_o | output    | 1                 | Is button pressed                        |

## Task 6 Traffic Lights
[traffic_lights](./traffic_lights)

| Parameter             | Comment                                            |
|-----------------------|----------------------------------------------------|
| BLINK_HALF_PERIOD_MS  | The half-cycle of blinking of yellow and green, ms |
| BLINK_GREEN_TIME_TICK | The time spent flashing green, number of blinks    |
| RED_YELLOW_MS         | The time spent in the red and yellow state, ms     |

| Signal            | Direction | Bit size | Comment            |
|-------------------|-----------|----------|--------------------|
| clk_i             | input     | 1        | Clock signal, 2KHz |
| srst_i            | input     | 1        | Synchronous reset  |
| cmd_type_i        | input     | 3        | Command type       |
| cmd_valid_i       | input     | 1        | Is command valid   |
| cmd_data_i        | input     | 16       | Command data       |
| red_o             | output    | 1        | Is red signal      |
| yellow_o          | output    | 1        | Is yellow signal   |
| green_o           | output    | 1        | Is green signal    |

| cmd_type_i | Comment                         |
|------------|---------------------------------|
| 0          | Enable/switch to standard mode  |
| 1          | Turn off                        |
| 2          | Switch to the uncontrolled mode |
| 3          | Set green time                  |
| 4          | Set red time                    |
| 5          | Set yellow time                 |

# Lab2

## Task 1 FIFO
[fifo](./fifo)

[Documentation](https://faculty-web.msoe.edu/johnsontimoj/EE3921/files3921/ug_fifo.pdf)

| Parameter          | Comment                                           |
|--------------------|---------------------------------------------------|
| DWIDTH             | The width of the data_i and q_o signal            |
| AWIDTH             | The width of the usedw_o signal                   |
| SHOWAHEAD          | Whether the FIFO is in Show-Ahead or Normal mode  |
| ALMOST_FULL_VALUE  | The threshold value for the almost_full_o signal  |
| ALMOST_EMPTY_VALUE | The threshold value for the almost_empty_o signal |
| REGISTER_OUTPUT    | Whether to register the q_o output                |

| Signal         | Direction | Bit size | Comment                                |
|----------------|-----------|----------|----------------------------------------|
| clk_i          | input     | 1        | Posedge-triggered clock                |
| srst_i         | input     | 1        | Synchronous reset                      |
| data_i         | input     | DWIDTH   | Data to be written in the FIFO         |
| wrreq_i        | input     | 1        | Write operation request                |
| rdreq_i        | input     | 1        | Read operation request                 |
| q_o            | output    | DWIDTH   | The data read from the read request    |
| empty_o        | output    | 1        | Is FIFO empty                          |
| full_o         | output    | 1        | Is FIFO full                           |
| usedw_o        | output    | AWIDTH+1 | The number of words stored in the FIFO |
| almost_full_o  | output    | 1        | Is FIFO almost full                    |
| almost_empty_o | output    | 1        | Is FIFO almost empty                   |

## Task 2 Sorting
[sorting](./sorting)

[Specification](https://schaumont.dyn.wpi.edu/ece4530f19/pdf/mnl_avalon_spec.pdf)

| Parameter   | Comment                            |
|-------------|------------------------------------|
| DWIDTH      | The width of the data              |
| MAX_PKT_LEN | The maximum number of transactions |

| Signal              | Direction | Bit size | Comment                                                      |
|---------------------|-----------|----------|--------------------------------------------------------------|
| clk_i               | input     | 1        | Posedge-triggered clock                                      |
| srst_i              | input     | 1        | Synchronous reset                                            |
| snk_data_i          | input     | DWIDTH   | Input data                                                   |
| snk_startofpacket_i | input     | 1        | The start of the transaction                                 |
| snk_endofpacket_i   | input     | 1        | The end of the transaction                                   |
| snk_valid_i         | input     | 1        | Are snk_data_i, snk_startofpacket_i, snk_endofpacket_i valid |
| snk_ready_o         | output    | 1        | If 0, the module is not ready to accept new data             |
| src_data_o          | output    | DWIDTH   | Output data                                                  |
| src_startofpacket_o | output    | 1        | The start of the transaction                                 |
| src_endofpacket_o   | output    | 1        | The end of the transaction                                   |
| src_valid_o         | output    | 1        | Are src_data_o, src_startofpacket_o, src_endofpacket_o valid |
| src_ready_i         | input     | 1        | Feedback, to stop the output stream                          |

# Lab3

## Task 1 LIFO
[lifo](./lifo)

| Parameter          | Comment                                           |
|--------------------|---------------------------------------------------|
| DWIDTH             | The width of the data                             |
| AWIDTH             | The width of the address data                     |
| ALMOST_FULL_VALUE  | The threshold value for the almost_full_o signal  |
| ALMOST_EMPTY_VALUE | The threshold value for the almost_empty_o signal |

| Signal         | Direction | Bit size | Comment                                |
|----------------|-----------|----------|----------------------------------------|
| clk_i          | input     | 1        | Posedge-triggered clock                |
| srst_i         | input     | 1        | Synchronous reset                      |
| data_i         | input     | DWIDTH   | Data to be written in the LIFO         |
| wrreq_i        | input     | 1        | Write operation request                |
| rdreq_i        | input     | 1        | Read operation request                 |
| q_o            | output    | DWIDTH   | The data read from the read request    |
| empty_o        | output    | 1        | Is LIFO empty                          |
| full_o         | output    | 1        | Is LIFO full                           |
| usedw_o        | output    | AWIDTH+1 | The number of words stored in the LIFO |
| almost_full_o  | output    | 1        | Is LIFO almost full                    |
| almost_empty_o | output    | 1        | Is LIFO almost empty                   |

## Task 2 AST Width Extender
[ast_width_extender](./ast_width_extender)

[Specification](https://schaumont.dyn.wpi.edu/ece4530f19/pdf/mnl_avalon_spec.pdf)

| Parameter   | Comment                            |
|-------------|------------------------------------|
| DATA_IN_W   | The width of the input data        |
| DATA_OUT_W  | The width of the output data       |
| EMPTY_IN_W  | The width of the empty input data  |
| EMPTY_OUT_W | The width of the empty output data |
| CHANNEL_W   | The width of channel signals       |

| Signal              | Direction | Bit size    | Comment                                                      |
|---------------------|-----------|-------------|--------------------------------------------------------------|
| clk_i               | input     | 1           | Posedge-triggered clock                                      |
| srst_i              | input     | 1           | Synchronous reset                                            |
| ast_data_i          | input     | DATA_IN_W   | Input data                                                   |
| ast_startofpacket_i | input     | 1           | The start of the input transaction                           |
| ast_endofpacket_i   | input     | 1           | The end of the input transaction                             |
| ast_valid_i         | input     | 1           | Are ast_data_i, ast_startofpacket_i, ast_endofpacket_i valid |
| ast_empty_i         | input     | EMPTY_IN_W  | How many empty bytes/characters are in a word                |
| ast_channel_i       | input     | CHANNEL_W   | Accompanying information                                     |
| ast_ready_o         | output    | 1           | If 0, the module is not ready to accept new data             |
| ast_data_o          | output    | DATA_OUT_W  | Output data                                                  |
| ast_startofpacket_o | output    | 1           | The start of the output transaction                          |
| ast_endofpacket_o   | output    | 1           | The end of the output transaction                            |
| ast_valid_o         | output    | 1           | Are ast_data_o, ast_startofpacket_o, ast_endofpacket_o valid |
| ast_empty_o         | output    | EMPTY_OUT_W | How many empty bytes/characters are in a word                |
| ast_channel_o       | output    | CHANNEL_W   | Accompanying information                                     |
| ast_ready_i         | input     | 1           | Feedback, to stop the output stream                          |

## Task 3 AST Demultiplexer
[ast_dmx](./ast_dmx)

[Specification](https://schaumont.dyn.wpi.edu/ece4530f19/pdf/mnl_avalon_spec.pdf)

| Parameter     | Comment                            |
|---------------|------------------------------------|
| DATA_WIDTH    | The width of the input data        |
| EMPTY_WIDTH   | The width of the empty input data  |
| CHANNEL_WIDTH | The width of channel signals       |
| TX_DIR        | The number of output signals       |

| Signal              | Direction | Bit size      | Comment                                                      |
|---------------------|-----------|---------------|--------------------------------------------------------------|
| clk_i               | input     | 1             | Posedge-triggered clock                                      |
| srst_i              | input     | 1             | Synchronous reset                                            |
| dir_i               | input     | clog2(TX_DIR) | The number of the output interface                           |
| ast_data_i          | input     | DATA_WIDTH    | Input data                                                   |
| ast_startofpacket_i | input     | 1             | The start of the input transaction                           |
| ast_endofpacket_i   | input     | 1             | The end of the input transaction                             |
| ast_valid_i         | input     | 1             | Are ast_data_i, ast_startofpacket_i, ast_endofpacket_i valid |
| ast_empty_i         | input     | EMPTY_WIDTH   | How many empty bytes/characters are in a word                |
| ast_channel_i       | input     | CHANNEL_WIDTH | Accompanying information                                     |
| ast_ready_o         | output    | 1             | If 0, the module is not ready to accept new data             |
| ast_data_o          | output    | DATA_WIDTH    | Output data                                                  |
| ast_startofpacket_o | output    | 1             | The start of the output transaction                          |
| ast_endofpacket_o   | output    | 1             | The end of the output transaction                            |
| ast_valid_o         | output    | 1             | Are ast_data_o, ast_startofpacket_o, ast_endofpacket_o valid |
| ast_empty_o         | output    | EMPTY_WIDTH   | How many empty bytes/characters are in a word                |
| ast_channel_o       | output    | CHANNEL_WIDTH | Accompanying information                                     |
| ast_ready_i         | input     | 1             | Feedback, to stop the output stream                          |
