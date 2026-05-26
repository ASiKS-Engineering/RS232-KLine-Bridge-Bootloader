:: batch file for automatic compilation of mcu specific and uart specific versions
:: --------------------------------------------------------------------------------------------------------------------
:: compiler version: gcc version 4.3.2 (WinAVR 20090313)


:: get parameters for RS485 versions
set DEF485=%1
set NAME485=%2

::goto test


:: ATmega162
:: --------------------------------------------------------
set MCU=atmega162
set BOOTADDR=0x3800
set FREQ=14745600

for %%P in (0 1) do (
avr-gcc.exe  -mmcu=%MCU% -Wall -gdwarf-2 -std=gnu99 -DSERIALPORT=%%P -DF_CPU=%FREQ% -DBOOTADDR=%BOOTADDR% %DEF485% -Os -fsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -MD -MP -MT main.o -MF main.o.d  -c  main.c
avr-gcc.exe  -mmcu=%MCU% -Wall -gdwarf-2 -std=gnu99 -DSERIALPORT=%%P -DF_CPU=%FREQ% -Os -fsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -MD -MP -MT usart.o -MF usart.o.d  -c  usart.c
avr-gcc.exe -mmcu=%MCU% -nostartfiles  -Wl,-Map=RS232KLineBridgeBoot.map -Wl,-section-start=.text=%BOOTADDR% main.o usart.o -o RS232KLineBridgeBoot.elf
avr-objcopy -O ihex -R .eeprom RS232KLineBridgeBoot.elf build/RS232KLineBridgeBoot_%MCU%_uart%%P_%NAME485%v%REV%.hex
)
:: --------------------------------------------------------

:ende