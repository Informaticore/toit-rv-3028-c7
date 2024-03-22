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
  scl := gpio.Pin 17
  sda := gpio.Pin 18
  bus := i2c.Bus
    --sda=sda
    --scl=scl

  device := bus.device rv-3028-c7.I2C_ADDRESS
  rtc = rv-3028-c7.RV-3028-C7 device.registers
  rtc.reset

  //adjusting esp32-rtc to ntp
  adjust-ntp
  //set RV-3028-C7 to adjusted time
  rtc.set Time.now

main:
  init-rtc

  interrupt-pin := gpio.Pin 1 --input=true      //we setup the interrupt pin with pull-up
  rtc.count-down-timer 
    --s=6
    --ms=406
    --enable-interrupt=true

  print "Waiting for interrupt on pin $interrupt-pin.num. $interrupt-pin.get"
  with-timeout --ms=6500:                                       //wait for 61 seconds
    interrupt-pin.wait-for 0                                     //wait for interrupt
    rtc.clear-periodic-countdown-timer-interrupt
    print "Interrupt detected on pin $interrupt-pin.num"
