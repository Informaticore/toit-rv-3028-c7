import gpio
import i2c
import rv-3028-c7

main:
  scl := gpio.Pin 17
  sda := gpio.Pin 18
  bus := i2c.Bus
      --sda=sda
      --scl=scl

  device := bus.device rv-3028-c7.I2C_ADDRESS
  rtc := rv-3028-c7.RV-3028-C7 device.registers

  print rtc.now.local