Для запуска тестов достаточно запустить `make.do` скрипт

Ошибки выводятся в формате: `{time} ns: {error}`. Например `{time} ns: {name} expected {ref_val} but got {dut_val}`

Для наглядности и чтобы не загромождать консоль вывода я рекомендую проводить один тест за раз. Для этого в файле [byte_inc_environment.sv](./tb/byte_inc_environment.sv#86) необходимо закомментировать все тесты кроме одного желаемого. Далее все тайминги будут приведены именно в таком формате

- `send_different_lengths`:
    - (1) при `length_i = 0` модуль инкрементирует всю память. очень длинный лог ошибок `38845 ns:   data expected 05050505572f52e4 but got 06060606583053e5 (addr=   0) (base_addr=   0, length=   0)` и так далее
    - (2) `amm_wr_writedata_o` пытается записать значение `x` в память. `2525 ns:        amm_wr_writedata_o is unknown`. из-за того, что в памяти теперь находится `x`, чередой сыпятся связанные с этим ошибки
- `send_overflow`:
    - (3) при превышении максимального адреса происходит ошибка записи последнего слова `125 ns:   data expected 0101010113f938e8 but got 0000000012f837e7 (addr=1023) (base_addr=1022, length=  24)`
    - (4) при максимально допустимой задержке между запросом на чтение и ответом (64 такта), DUT перестаёт отправлять какиe-либо запросы и бесконечно висит в занятом состоянии `waitrequest_o = 1`. в конце концов модуль превышает timeout и tb выдаёт ошибку `Not all transactions were sent (1)`. Для симуляции задержек в файле [byte_inc_environment.sv](./tb/byte_inc_environment.sv#80) необходимо заменить значение переменной `amm_package::ram_speed` на `SLOW`
- `send_random`:
    - (5) если случайно возводить `amm_wr_waitrequest_i`, DUT как и в (4) бесконечно висит в `waitrequest_o = 1`, выдавая ошибку `Not all transactions were sent (100)`. для этого в файле [byte_inc_environment.sv](./tb/byte_inc_environment.sv#82) необходимо заменить значение переменной `amm_package::WR_WAITREQUEST_CHANCE` на `50`