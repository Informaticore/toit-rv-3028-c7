import gpio
import i2c
import rv-3028-c7

main:
  bus := i2c.Bus
      --sda=gpio.Pin 21
      --scl=gpio.Pin 22

  device := bus.device rv-3028-c7.I2C_ADDRESS
  rtc := rv-3028-c7.RV-3028-C7 device.registers

  print "ProductId:  $rtc.productId"
