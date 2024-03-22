import .utils as utils

class Status:
  static EEBUSY_BIT ::= 7
  static CLKF_BIT   ::= 6
  static BSF_BIT    ::= 5
  static UF_BIT     ::= 4
  static TF_BIT     ::= 3
  static AF_BIT     ::= 2
  static EVF_BIT    ::= 1
  static PORF_BIT   ::= 0

  status/int := 0

  constructor .status:

  eeprom-busy -> bool:
    return utils.is-bit-set status EEBUSY-BIT

  eeprom-busy enable/bool:
    status = utils.set-bit status EEBUSY-BIT enable

  clock-output-interrupt -> bool:
    return utils.is-bit-set status CLKF_BIT
  
  clear-output-clock-interrupt:
    status = utils.set-bit status CLKF_BIT false

  backup-switchover -> bool:
    return utils.is-bit-set status BSF_BIT

  clear-backup-switchover:
    status = utils.set-bit status BSF_BIT false

  periodic-time-update-interrupt -> bool:
    return utils.is-bit-set status UF_BIT

  clear-periodic-time-update-interrupt:
    status = utils.set-bit status UF_BIT false

  periodic-countdown-timer-interrupt -> bool:
    return utils.is-bit-set status TF_BIT

  clear-periodic-countdown-timer-interrupt:
    status = utils.set-bit status TF_BIT false

  alarm-interrupt -> bool:
    return utils.is-bit-set status AF_BIT

  clear-alarm-interrupt:
    status = utils.set-bit status AF_BIT false

  event-interrupt -> bool:
    return utils.is-bit-set status EVF_BIT

  clear-event-interrupt:
    status = utils.set-bit status EVF_BIT false

  power-on-reset -> bool:
    return utils.is-bit-set status PORF_BIT

  clear-power-on-reset:
    status = utils.set-bit status PORF_BIT false

  clear-all-interrupts:
    status = 0
    return status
