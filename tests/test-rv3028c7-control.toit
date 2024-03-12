import .testoiteron
import control show Control
import i2c
import gpio
import .register-mock


class TestRV3028C7Control implements TestCase:

  run:
    test-timer-repeat-mode
    test-weekday-date-alarm
    test-periodic-time-update-mode
    test-eeprom-memory-refresh-disabled
    test-periodic-countdown-timer-enabled
    test-timer-clock-frequency
    test-is-timestamp-enabled
    test-is-controlled-clock-output-interrupt-enabled
    test-is-periodic-time-update-interrupt-enabled
    test-is-periodic-countdown-timer-interrupt-enabled
    test-is-alarm-interrupt-enabled
    test-is-event-interrupt-enabled
    test-hour-mode
    test-reset

  test-timer-repeat-mode:
    print "test-timer-repeat-mode"
    control := Control 0 0
    assertEquals control.periodic-countdown-mode Control.COUNTDOWN-MODE-SINGLE
    control.periodic-countdown-mode Control.COUNTDOWN-MODE-REPEAT
    assertEquals control.periodic-countdown-mode Control.COUNTDOWN-MODE-REPEAT
    
  test-weekday-date-alarm:
    print "test-weekday-date-alarm"
    control := Control 0 0
    assertEquals control.weekday-date-alarm Control.WEEKDAY-ALARM
    control.weekday-date-alarm Control.DATE-ALARM
    assertEquals control.weekday-date-alarm Control.DATE-ALARM

  test-periodic-time-update-mode:
    print "test-periodic-time-update-mode"
    control := Control 0 0
    assertEquals control.periodic-time-update-mode Control.PERIODIC_TIME_UPDATE_SECONDS
    control.periodic-time-update-mode Control.PERIODIC-TIME-UPDATE-MINUTES
    assertEquals control.periodic-time-update-mode Control.PERIODIC-TIME-UPDATE-MINUTES
  
  test-eeprom-memory-refresh-disabled:
    print "test-eeprom-memory-refresh-disabled"
    control := Control 0 0
    assertFalse control.is-eeprom-memory-refresh-disabled 
    control.disable-eeprom-memory-refresh true
    assertTrue control.is-eeprom-memory-refresh-disabled

  test-periodic-countdown-timer-enabled:
    print "test-periodic-countdown-timer-enabled"
    control := Control 0 0
    assertFalse control.is-periodic-countdown-timer-enabled
    control.enable-periodic-countdown-timer true
    assertTrue control.is-periodic-countdown-timer-enabled

  test-timer-clock-frequency:
    print "test-timer-clock-frequency"
    control := Control 0 0
    assertEquals control.timer-clock-frequency Control.TIMER_CLOCK_FREQUENCY_4096HZ
    control.timer-clock-frequency Control.TIMER_CLOCK_FREQUENCY_64HZ
    assertEquals control.timer-clock-frequency Control.TIMER_CLOCK_FREQUENCY_64HZ
    control.timer-clock-frequency Control.TIMER-CLOCK-FREQUENCY-1-60HZ
    assertEquals control.timer-clock-frequency Control.TIMER-CLOCK-FREQUENCY-1-60HZ

  test-is-timestamp-enabled:
    print "test-is-timestamp-enabled"
    control := Control 0 0
    assertFalse control.is-timestamp-enabled
    control.enable-timestamp true
    assertTrue control.is-timestamp-enabled

  test-is-controlled-clock-output-interrupt-enabled:
    print "test-is-controlled-clock-output-interrupt-enabled"
    control := Control 0 0
    assertFalse control.is-controlled-clock-output-interrupt-enabled
    control.enable-controlled-clock-output-interrupt true
    assertTrue control.is-controlled-clock-output-interrupt-enabled

  test-is-periodic-time-update-interrupt-enabled:
    print "test-is-periodic-time-update-interrupt-enabled"
    control := Control 0 0
    assertFalse control.is-periodic-time-update-interrupt-enabled
    control.enable-periodic-time-update-interrupt true
    assertTrue control.is-periodic-time-update-interrupt-enabled

  test-is-periodic-countdown-timer-interrupt-enabled:
    print "test-is-periodic-countdown-timer-interrupt-enabled"
    control := Control 0 0
    assertFalse control.is-periodic-countdown-timer-interrupt-enabled
    control.enable-periodic-countdown-timer-interrupt true
    assertTrue control.is-periodic-countdown-timer-interrupt-enabled

  test-is-alarm-interrupt-enabled:
    print "test-is-alarm-interrupt-enabled"
    control := Control 0 0
    assertFalse control.is-alarm-interrupt-enabled
    control.enable-alarm-interrupt true
    assertTrue control.is-alarm-interrupt-enabled

  test-is-event-interrupt-enabled:
    print "test-is-event-interrupt-enabled"
    control := Control 0 0
    assertFalse control.is-event-interrupt-enabled
    control.enable-event-interrupt true
    assertTrue control.is-event-interrupt-enabled

  test-hour-mode:
    print "test-hour-mode"
    control := Control 0 0
    assertEquals control.hour-mode Control.HOUR-MODE-24
    control.hour-mode Control.HOUR-MODE-12
    assertEquals control.hour-mode Control.HOUR_MODE_12

  test-reset:
    print "test-reset"
    control := Control 0 0
    control.reset
    assertEquals control.control2 1

main:
  test := TestRV3028C7Control
  test.run