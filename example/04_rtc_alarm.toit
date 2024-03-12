import gpio
import i2c
import ntp
import esp32 show adjust-real-time-clock
import rv-3028-c7
import rv-3028-c7.alarm show Alarm

rtc := ?

adjust-ntp:
  result ::= ntp.synchronize
  if result:
    adjust-real-time-clock result.adjustment
    print "Set time to $Time.now by adjusting $result.adjustment"
  else:
    throw "ntp: synchronization request failed"

init-rtc:
  bus := i2c.Bus
    --sda=gpio.Pin 21
    --scl=gpio.Pin 22

  device := bus.device rv-3028-c7.I2C_ADDRESS
  rtc = rv-3028-c7.RV-3028-C7 device.registers

  //adjusting esp32-rtc to ntp
  adjust-ntp
  //set RV-3028-C7 to adjusted time
  rtc.set Time.now

main:
  init-rtc

  interrupt-pin := gpio.Pin 19 --input=true --pull-up=true
  alarm := Alarm --minutes=Time.now.local.m + 1
  print "Set alarm to $alarm"
  rtc.alarm alarm
  print "Waiting for interrupt on pin 19. $interrupt-pin.get"
  with-timeout --ms=60100: 
    interrupt-pin.wait-for 0



