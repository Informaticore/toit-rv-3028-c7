import .utils as utils

class ClockInterruptMask:
  static CEIE     ::= 3
  static CAIE     ::= 2
  static CTIE    ::= 1
  static CUIE   ::= 0

  clock-interrupt-mask/int := ?

  constructor .clock-interrupt-mask/int=0:

  is-clock-output-periodic-time-update-enabled -> bool:
    return utils.is-bit-set clock-interrupt-mask CUIE

  enable-clock-output-periodic-time-update enable/bool:
    clock-interrupt-mask = utils.set-bit clock-interrupt-mask CTIE enable

  is-clock-output-periodic-countdown-timer-enabled -> bool:
    return utils.is-bit-set clock-interrupt-mask CTIE

  enable-clock-output-alarm enable/bool:
    clock-interrupt-mask = utils.set-bit clock-interrupt-mask CAIE enable
  
  is-clock-output-alarm-enabled -> bool:
    return utils.is-bit-set clock-interrupt-mask CAIE

  enable-clock-output-event enable/bool:
    clock-interrupt-mask = utils.set-bit clock-interrupt-mask CEIE enable

  is-clock-output-event-enabled -> bool:
    return utils.is-bit-set clock-interrupt-mask CEIE