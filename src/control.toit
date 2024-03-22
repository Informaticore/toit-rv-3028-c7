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
    return COUNTDOWN_MODE_SINGLE

  periodic-countdown-mode mode/int:
    if mode != COUNTDOWN_MODE_SINGLE and mode != COUNTDOWN_MODE_REPEAT: throw "Periodic countdown mode must be either Control.COUNTDOWN_MODE_SINGLE or Control.COUNTDOWN_MODE_REPEAT"
    control1 = utils.set-bit control1 TRPT (mode == 1)

  weekday-date-alarm -> int:
    if utils.is-bit-set control1 WADA:
      return DATE_ALARM
    return WEEKDAY_ALARM

  weekday-date-alarm mode:
    if mode != WEEKDAY_ALARM and mode != DATE_ALARM: throw "Weekday/date alarm mode must be either Control.WEEKDAY_ALARM or Control.DATE_ALARM"
    control1 = utils.set-bit control1 WADA (mode == 1)

  periodic-time-update-mode -> int:
    if utils.is-bit-set control1 USEL:
      return PERIODIC_TIME_UPDATE_MINUTES
    return PERIODIC_TIME_UPDATE_SECONDS

  periodic-time-update-mode mode:
    if mode != PERIODIC_TIME_UPDATE_SECONDS and mode != PERIODIC_TIME_UPDATE_MINUTES: throw "Periodic time update mode must be either Control.PERIODIC_TIME_UPDATE_SECONDS or Control.PERIODIC_TIME_UPDATE_MINUTES"
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

  timer-clock-frequency-value -> int:
    frequency := timer-clock-frequency
    print "Frequency: $frequency"
    if frequency == 0:
      return 4096
    else if frequency == 1:
      return 64
    else if frequency == 2:
      return 1
    else if frequency == 3:
      return 1/60
    else:
      return 4096

  timer-clock-frequency frequency:
    if frequency != 0 and frequency > 3: throw "Timer clock frequency must be one of Control.TIMER_CLOCK_FREQUENCY_4096HZ, Control.TIMER_CLOCK_FREQUENCY_64HZ, Control.TIMER_CLOCK_FREQUENCY_1HZ, or Control.TIMER_CLOCK_FREQUENCY_1_60HZ"
    print "Frequency: $frequency"
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
    return HOUR_MODE_24

  hour-mode mode/int:
    if mode != HOUR_MODE_24 or mode != HOUR_MODE_12: throw "Hour mode must be either Control.HOUR_MODE_24 or Control.HOUR_MODE_12"
    control2 = utils.set-bit control2 HOUR_MODE (mode == 1)
  
  reset:
    control2 = utils.set-bit control2 RESET true