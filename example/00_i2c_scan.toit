import gpio
import i2c

main:
  scl := gpio.Pin 22
  sda := gpio.Pin 21
  frequency := 100_000

  bus := i2c.Bus --sda=sda --scl=scl --frequency=frequency

  devices := bus.scan
  devices.do: print ("0x" + (it.stringify 16))