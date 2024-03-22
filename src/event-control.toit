import .utils as utils

class EventControl:

  static EHL   ::= 6
  // static ET   ::= 3
  static TSR   ::= 2
  static TSOW  ::= 1
  static TSS   ::= 0

  static SOURCE-EXTERNAL-EVENT ::= 0
  static SOURCE-AUTOMATIC-BACKUP-SWITCHOVER ::= 1

  static EVENT-EDGE-FALLING  ::= 0
  static EVENT-EDGE-RISING   ::= 1

  static EVI-SAMPLING-NONE  ::= 0
  static EVI-SAMPLING-256HZ ::= 1
  static EVI-SAMPLING-64HZ  ::= 2
  static EVI-SAMPLING-8HZ   ::= 3

  event-control/int := ?

  constructor .event-control/int=0:

  reset-timestamp:
    event-control = utils.set-bit event-control TSR true

  timestamp-source-selection value/int:
    assert: value == SOURCE-EXTERNAL-EVENT or value == SOURCE-AUTOMATIC-BACKUP-SWITCHOVER
    event-control = utils.set-bit event-control TSS (value == 1)

  timestamp-source-selection -> int:
    if utils.is_bit_set event_control TSS:
      return SOURCE-AUTOMATIC-BACKUP-SWITCHOVER
    return SOURCE-EXTERNAL-EVENT

  /**
  * Enable or disable the timestamp override feature.
  * When enabled, the timestamp of the last occurred event is recorded
  * When disabled, the timestamp of the first occurred event is recorded and remains
  */
  enable-timestamp-override:
    event-control = utils.set-bit event-control TSOW true

  is-timestamp-override-enabled -> bool:
    return utils.is-bit-set event-control TSOW

  event-filtering-time-interval sampling/int:
    assert: sampling == 0 and sampling <= 3
    event-control = (event-control & 0xCF) | sampling

  event-filtering-time-interval -> int:
    return event-control & 0x03
  
  event-edge -> int:
    if utils.is-bit-set event-control EHL:
      return EVENT-EDGE-RISING
    else:
      return EVENT-EDGE-FALLING

  event-edge edge/int:
    assert: edge == EVENT-EDGE-FALLING or edge == EVENT-EDGE-RISING
    event-control = utils.set-bit event-control EHL (edge == 1)