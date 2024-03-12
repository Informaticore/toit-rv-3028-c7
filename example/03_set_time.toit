import gpio
import i2c
import ntp
import esp32 show adjust-real-time-clock
import rv-3028-c7

main:
  bus := i2c.Bus
    --sda=gpio.Pin 21
    --scl=gpio.Pin 22

  device := bus.device rv-3028-c7.I2C_ADDRESS
  rtc := rv-3028-c7.RV-3028-C7 device.registers

  print "Current RTC time: $rtc.now.local"

  now := Time.now
  result ::= ntp.synchronize
  if result:
    adjust-real-time-clock result.adjustment
    print "Set time to $Time.now by adjusting $result.adjustment"
  else:
    print "ntp: synchronization request failed"

  rtc.set Time.now
  print "RTC Time set to: $rtc.now.local"
  sleep --ms=2000
  print "RTC Time set to: $rtc.now.local"