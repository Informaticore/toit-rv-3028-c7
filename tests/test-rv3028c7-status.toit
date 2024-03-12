import .testoiteron
import status show Status
import i2c
import gpio
import .register-mock

class TestRV3028C7Status implements TestCase:

  run:
    test-eebusy
    test-clock-output-interrupt
    test-backup-switch
    test-periodic-time-update
    test-periodic-countdown-timer
    test-alarm-interrupt
    test-event-interrupt
    test-power-on-reset

  test-eebusy:
    print "Test rv-3028-c7 status eeprom busy interrupt"
    status := Status 0
    assertFalse status.eeprom-busy
    status.eeprom-busy true
    assertTrue status.eeprom-busy

  test-clock-output-interrupt:
    print "Test rv-3028-c7 status clock output interrupt"
    status := Status 0b01000000
    assertTrue status.clock-output-interrupt
    status.clear-output-clock-interrupt
    assertFalse status.clock-output-interrupt
  
  test-backup-switch:
    print "Test rv-3028-c7 status backup switch interrupt"
    status := Status 0b00100000
    assertTrue status.backup-switchover
    status.clear-backup-switchover
    assertFalse status.backup-switchover

  test-periodic-time-update:
    print "Test rv-3028-c7 status periodic time update interrupt"
    status := Status 0b00010000
    assertTrue status.periodic-time-update-interrupt
    status.clear-periodic-time-update-interrupt
    assertFalse status.periodic-time-update-interrupt

  test-periodic-countdown-timer:
    print "Test rv-3028-c7 status periodic countdown timer interrupt"
    status := Status 0b00001000
    assertTrue status.periodic-countdown-timer-interrupt
    status.clear-periodic-countdown-timer-interrupt
    assertFalse status.periodic-countdown-timer-interrupt

  test-alarm-interrupt:
    print "Test rv-3028-c7 status alarm interrupt"
    status := Status 0b00000100
    assertTrue status.alarm-interrupt
    status.clear-alarm-interrupt
    assertFalse status.alarm-interrupt

  test-event-interrupt:
    print "Test rv-3028-c7 status event interrupt"
    status := Status 0b00000010
    assertTrue status.event-interrupt
    status.clear-event-interrupt
    assertFalse status.event-interrupt

  test-power-on-reset:
    print "Test rv-3028-c7 status power-on reset"
    status := Status 0b00000001
    assertTrue status.power-on-reset
    status.clear-power-on-reset
    assertFalse status.power-on-reset

main:
  test := TestRV3028C7Status
  test.run