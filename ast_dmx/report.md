Для запуска тестов достаточно запустить `make.do` скрипт

Ошибки выводятся в формате: `{time} ns: {error}`. Например `{time} ns: {name} expected {ref_val} but got {dut_val}`

Для наглядности и чтобы не загромождать консоль вывода я рекомендую проводить один тест за раз. Для этого в файле [ast_dmx_environment.sv](./tb/ast_dmx_environment.sv#70) необходимо закомментировать все тесты кроме одного желаемого. Далее все тайминги будут приведены имеено в таком формате.

- `send_different_lengths`:
    - (1) пропадают пакеты длиной `1 байт`. сообщение `980345 ns: dir expected 0 but got 1`, но сама ошибка `816795 ns` (channel = 206): `snk_channel` в `x` и `snk_valid` в `0`
    - (2) `ast_ready_i` если сигнал редко поднимать в `1`, модуль пропускает некоторые пакеты. Чтобы это проверить, в файле [ast_dmx_environment.sv](./tb/ast_dmx_environment.sv#L79) нужно изменить значение аргумента функции `this.monitor.run` на малое значение (`1` - `20`) (ошибка `Not all packets were sent`)
- `send_non_zero_empty` и `send_zero_empty`:
    - (3) `ast_channel_o` не выставляется в корректное значение (`208245 ns` и далее). есть подозрение, что `channel` не работает только при `dir = 2`. Dataflow `snk_channel` и `dir` подтверждают гипотезу
