set_time_format -unit ns -decimal_places 3

create_clock -name {clk_150m} -period 6.666 [get_ports {clk_i}]

derive_clock_uncertainty
