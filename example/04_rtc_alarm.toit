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
  
  // eeprom-backup_ := rtc.eeprom-backup
  // eeprom-backup_.enable-trickle-charger true
  // rtc.eeprom-backup eeprom-backup_

  //adjusting esp32-rtc to ntp
  adjust-ntp
  //set RV-3028-C7 to adjusted time
  rtc.set Time.now

main:
  init-rtc

  interrupt-pin := gpio.Pin 1 --input=true --pull-up=true        //we setup the interrupt pin with pull-up
  print "Interrupt pin is $(interrupt-pin.get)"
  alarm := Alarm --minutes=Time.now.local.m + 1                  //set alarm to next minute
  rtc.alarm alarm                                                //set alarm and interrupt pin
  print "Set Alarm at $(%2d alarm.hours):$(%2d alarm.minutes) on $(%2d alarm.weekday-date)"
  print "Waiting for interrupt on pin 19. $interrupt-pin.get"
  with-timeout --ms=61000:                                       //wait for 61 seconds
    interrupt-pin.wait-for 0                                     //wait for interrupt
    rtc.clear-alarm-interrupt                                   //clear interrupt
    print "Interrupt detected"
    
  

