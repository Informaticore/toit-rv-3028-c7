import .utils as utils

class Control:
  static TRPT  ::= 7
  static WADA  ::= 5
  static USEL  ::= 4
  static EERD  ::= 3
  static TE    ::= 2

  static TSE        ::= 7
  static CLKIE      ::= 6
  static UIE        ::= 5
  static TIE        ::= 4
  static AIE        ::= 3
  static EIE        ::= 2
  static HOUR_MODE  ::= 1
  static RESET      ::= 0

  static COUNTDOWN_MODE_SINGLE ::= 0
  static COUNTDOWN_MODE_REPEAT ::= 1

  static HOUR_MODE_24 ::= 0
  static HOUR_MODE_12 ::= 1

  static WEEKDAY_ALARM ::= 0
  static DATE_ALARM    ::= 1

  static PERIODIC_TIME_UPDATE_SECONDS ::= 0
  static PERIODIC_TIME_UPDATE_MINUTES ::= 1

  static TIMER_CLOCK_FREQUENCY_4096HZ   ::= 0
  static TIMER_CLOCK_FREQUENCY_64HZ     ::= 1
  static TIMER_CLOCK_FREQUENCY_1HZ      ::= 2
  static TIMER_CLOCK_FREQUENCY_1_60HZ   ::= 3

  control1/int := 0
  control2/int := 0

  constructor .control1/int .control2/int:

  periodic-countdown-mode -> int:
    if utils.is-bit-set control1 TRPT:
      return COUNTDOWN_MODE_REPEAT
    else:
      return COUNTDOWN_MODE_SINGLE

  periodic-countdown-mode mode:
    assert: (mode == COUNTDOWN_MODE_SINGLE or mode == COUNTDOWN_MODE_REPEAT)
    control1 = utils.set-bit control1 TRPT (mode == 1)

  weekday-date-alarm -> int:
    if utils.is-bit-set control1 WADA:
      return DATE_ALARM
    else:
      return WEEKDAY_ALARM

  weekday-date-alarm mode:
    assert: mode == WEEKDAY_ALARM or mode == DATE_ALARM
    control1 = utils.set-bit control1 WADA (mode == 1)

  periodic-time-update-mode -> int:
    if utils.is-bit-set control1 USEL:
      return PERIODIC_TIME_UPDATE_MINUTES
    else:
      return PERIODIC_TIME_UPDATE_SECONDS

  periodic-time-update-mode mode:
    assert: mode == PERIODIC_TIME_UPDATE_SECONDS or mode == PERIODIC_TIME_UPDATE_MINUTES
    control1 = utils.set-bit control1 USEL (mode == 1)

  is-eeprom-memory-refresh-disabled -> bool:
    return utils.is-bit-set control1 EERD

  disable-eeprom-memory-refresh enable/bool:
    control1 = utils.set-bit control1 EERD enable

  is-periodic-countdown-timer-enabled -> bool:
    return utils.is-bit-set control1 TE

  enable-periodic-countdown-timer enable/bool:
    control1 = utils.set-bit control1 TE enable

  timer-clock-frequency -> int:
    return control1 & 0x03

  timer-clock-frequency frequency:
    assert: frequency == 0 and frequency <= 3
    control1 = (control1 & 0xFC) | frequency

  is-timestamp-enabled -> bool:
    return utils.is-bit-set control2 TSE

  enable-timestamp enable/bool:
    control2 = utils.set-bit control2 TSE enable

  is-controlled-clock-output-interrupt-enabled -> bool:
    return utils.is-bit-set control2 CLKIE
  
  enable-controlled-clock-output-interrupt enable/bool:
    control2 = utils.set-bit control2 CLKIE enable

  is-periodic-time-update-interrupt-enabled -> bool:
    return utils.is-bit-set control2 UIE

  enable-periodic-time-update-interrupt enable/bool: 
    control2 = utils.set-bit control2 UIE enable

  is-periodic-countdown-timer-interrupt-enabled -> bool:
    return utils.is-bit-set control2 TIE
  
  enable-periodic-countdown-timer-interrupt enable/bool:
    control2 = utils.set-bit control2 TIE enable

  is-alarm-interrupt-enabled -> bool:
    return utils.is-bit-set control2 AIE
  
  enable-alarm-interrupt enable/bool:
    control2 = utils.set-bit control2 AIE enable

  is-event-interrupt-enabled -> bool:
    return utils.is-bit-set control2 EIE

  enable-event-interrupt enable/bool:
    control2 = utils.set-bit control2 EIE enable
  
  hour-mode -> int:
    if utils.is-bit-set control2 HOUR_MODE:
      return HOUR_MODE_12
    else:
      return HOUR_MODE_24

  hour-mode mode/int:
    assert: mode == HOUR_MODE_24 or mode == HOUR_MODE_12
    control2 = utils.set-bit control2 HOUR_MODE (mode == 1)
  
  reset:
    control2 = utils.set-bit control2 RESET true