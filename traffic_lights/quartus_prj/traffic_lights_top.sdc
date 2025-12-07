set_time_format -unit ms -decimal_places 3

create_clock -name {clk_2k} -period 0.500 [get_ports {clk_2k_i}]

derive_clock_uncertainty
