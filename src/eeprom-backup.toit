import .utils as utils

class EEPROMBackup:
  static EEOffset  ::= 7
  static BSIE      ::= 6
  static TCE       ::= 5
  static FEDE      ::= 4

  static TCR-3k ::= 0
  static TCR-5k ::= 1
  static TCR-9k ::= 2
  static TCR-15k ::= 3

  static SWITCHOVER-DISABLED ::= 0
  static SWITCHOVER-DSM  ::= 1
  static SWITCHOVER-LSM  ::= 3

  eeprom-backup/int := 0

  constructor .eeprom-backup/int:

  enable-fast-edge-detection enable:
    eeprom-backup = utils.set-bit eeprom-backup FEDE enable

  is-fast-edge-detection-enabled:
    return utils.is-bit-set eeprom-backup FEDE

  enable-trickle-charger enable:
    eeprom-backup = utils.set-bit eeprom-backup TCE enable

  is-trickle-charger-enabled:
    return utils.is-bit-set eeprom-backup TCE

  enable-backup-switchover-interrupt enable:
    eeprom-backup = utils.set-bit eeprom-backup BSIE enable

  is-backup-switchover-interrupt-enabled:
    return utils.is-bit-set eeprom-backup BSIE

  eeprom-offset-value:
    return utils.read-bits eeprom-backup 7 7 1

  trickle-charge-series-resistor -> int:
    return eeprom-backup & 0x03
  
  trickle-charge-series-resistor value:
    if value < 0 and value > 3: throw "Trickle charge series resistor must be one of EEPROMOffset.TCR-3k, EEPROMOffset.TCR-5k, EEPROMOffset.TCR-9k, or EEPROMOffset.TCR-15k"
    eeprom-backup = (eeprom-backup & 0xFC) | (value << 2)
  
  backup-switchover-mode -> int:
    return (eeprom-backup >> 2) & 0x03
  
  backup-switchover-mode mode:
    if mode < 0 or mode > 3: throw "Backup switchover mode must be one of EEPROMOffset.SWITCHOVER-DISABLED, EEPROMOffset.SWITCHOVER-DSM, or EEPROMOffset.SWITCHOVER-LSM"
    eeprom-backup = (eeprom-backup & 0xF3) | (mode << 2)
  