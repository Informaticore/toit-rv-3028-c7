import serial
import .registers as reg
import .utils as utils
import .status
import .control
import .alarm
import .eeprom-backup
import .clock-interrupt-mask

I2C_ADDRESS ::= 0x52
COUNT-DOWN-TIMER-MAX ::= 0x0000_ffff_ffff_ffff

class RV-3028-C7:

  registers_/serial.Registers

  constructor .registers_/serial.Registers:

  productId -> string:
    version := registers_.read_u8 reg.ID
    hid := utils.read_bits version 7 4 //Hardware Identification number
    vid := utils.read_bits version 3 0 //Version Identification number.
    return "$hid.$vid"

  now -> Time:
    return Time.local --year=year --month=month --day=date --h=hours --m=minutes --s=seconds

  set time/Time:
    print "Set time to: $time.local.to-iso8601-string "
    seconds time.local.s
    minutes time.local.m
    hours time.local.h
    date time.local.day
    month time.local.month
    year time.local.year
    
  _read register:
    return registers_.read_u8 register
  
  _write register value:
    registers_.write_u8 register value

  _write-bcd register value:
    value = _dec-to-bcd value
    registers_.write_u8 register value

  _read-bcd register:
    value := registers_.read_u8 register
    return _bcd-to-dec value

  _bcd-to-dec value:
    tens := (value & 0xF0) >> 4  // Get the tens place (bits 4-7)
    ones := value & 0x0F  // Get the ones place (bits 0-3)
    return tens * 10 + ones  // Convert from BCD to decimal

  _dec-to-bcd value:
    tens := value / 10  // Get the tens place
    ones := value % 10  // Get the ones place
    return (tens << 4) | ones  // Convert to BCD

  reset:
    print "Resetting RV-3028-C7"
    control_ := control
    control_.reset
    control control_

  seconds:
    return _read_bcd reg.SECONDS

  seconds value:
    _write_bcd reg.SECONDS value

  minutes:
    return _read_bcd reg.MINUTES

  minutes value:
    _write-bcd reg.MINUTES value

  minutes-alarm value:
    _write-bcd reg.MINUTES_ALARM value

  hours:
    return _read_bcd reg.HOURS

  hours value:
    _write_bcd reg.HOURS value

  hours-alarm value:
    _write_bcd reg.HOURS_ALARM value

  date:
    return _read_bcd reg.DATE

  date value:
    _write_bcd reg.DATE value

  weekday:
    return _read_bcd reg.WEEKDAY

  weekday value:
    _write_bcd reg.WEEKDAY value

  weekday-date-alarm value:
    _write_bcd reg.WEEKDAY-DATE-ALARM value

  month:
    return _read_bcd reg.MONTH

  month value:
    _write_bcd reg.MONTH value

  year:
    return (2000 + (_read_bcd reg.YEAR))

  year value:
    _write_bcd reg.YEAR (value - 2000)

  status -> Status:
    status := registers_.read_u8 reg.STATUS
    return Status status

  status value/Status:
    registers_.write_u8 reg.STATUS value.status

  control -> Control:
    control1 := registers_.read_u8 reg.CONTROL_1
    control2 := registers_.read_u8 reg.CONTROL_2
    return Control control1 control2

  control value/Control:
    registers_.write_u8 reg.CONTROL_1 value.control1
    registers_.write_u8 reg.CONTROL_2 value.control2

  clock-interrupt-mask -> ClockInterruptMask:
    return ClockInterruptMask (_read reg.CLOCK_INT_MASK)

  clock-interrupt-mask obj/ClockInterruptMask:
    _write reg.CLOCK_INT_MASK obj.clock-interrupt-mask

  enable-alarm-interrupt enable/bool:
    control_ := control
    control_.enable-alarm-interrupt enable
    control control_

  clear-alarm-interrupt:
    status_ := status
    status_.clear-alarm-interrupt
    status status_

  alarm alarm/Alarm:
    enable-alarm-interrupt false
    clear-alarm-interrupt

    if alarm.minutes >= 0:
      minutes := _dec-to-bcd alarm.minutes
      if alarm.is-minutes-alarm-enabled:
        minutes &= 0x7F // if minutes alarm is enabled, set the MSB to 1
      else:
        minutes |= 0x80 // if minutes alarm is disabled, set the MSB to 0
      _write reg.MINUTES-ALARM minutes
    if alarm.hours >= 0:
      hours := _dec-to-bcd alarm.hours
      if alarm.is-hours-alarm-enabled:
        hours &= 0x7F // if hours alarm is enabled, set the MSB to 1
      else:
        hours |= 0x80 // if hours alarm is disabled, set the MSB to 0
      _write reg.HOURS-ALARM hours
    if alarm.weekday_date >= 0:
      weekday-date := _dec-to-bcd alarm.weekday-date
      if alarm.is-weekday-date-alarm-enabled:
        weekday-date &= 0x7F // if weekday-date alarm is enabled, set the MSB to 1
      else:
        weekday-date |= 0x80 // if weekday-date alarm is disabled, set the MSB to 0
      _write-bcd reg.WEEKDAY-DATE-ALARM weekday-date

    enable-alarm-interrupt true

  enable-periodic-countdown-timer enable/bool:
    control_ := control
    control_.enable-periodic-countdown-timer enable
    control control_

  enable-periodic-countdown-timer-interrupt enable/bool:
    control_ := control
    control_.enable-periodic-countdown-timer-interrupt enable
    control control_

  eeprom-backup -> EEPROMBackup:
    return EEPROMBackup (_read reg.EEPROM-BACKUP)

  eeprom-backup value/EEPROMBackup:
    _write reg.EEPROM-BACKUP value.eeprom-backup

  clear-periodic-countdown-timer-interrupt:
    status_ := status
    status_.clear-periodic-countdown-timer-interrupt
    status status_

  clear-all-interrupts:
    status_ := status
    status_.clear-all-interrupts
    status status_

  count-down-timer --ms/int=0 --s/int=0 --m/int=0 --repeat/bool=false --enable-interrupt/bool=false:
    enable-periodic-countdown-timer false
    enable-periodic-countdown-timer-interrupt false
    clear-periodic-countdown-timer-interrupt

    time-value-frequencs := calculate-time-value-frequency ms s m
    time-value := time-value-frequencs[0]
    frequency := time-value-frequencs[1]

    lower_part := time-value & 0xFF  // Extract lower 8 bits
    upper_part := (time-value >> 8) & 0xFF  // Extract upper 4 bits
    _write reg.TIMER-VALUE-0 lower_part
    _write reg.TIMER-VALUE-1 upper_part

    control_ := control 
    control_.periodic-countdown-mode (repeat ? Control.COUNTDOWN_MODE_REPEAT : Control.COUNTDOWN_MODE_SINGLE)
    control_.timer-clock-frequency frequency
    control control_

    clear-alarm-interrupt
    status_ := status
    print "Status: $(%b status_.status)"
    enable-periodic-countdown-timer-interrupt enable-interrupt
    enable-periodic-countdown-timer true

  calculate-time-value-frequency ms/int=0 s/int=0 m/int=0:
    count-down-timer-seconds/float := (ms.to-float / 1000.0) + s.to-float + (m.to-float * 60.0)
    frequency-value := [4096.0, 64.0, 1.0, 1.0/60.0]
    frequency := 0
    time-value/float := 0.0
    for i := 0; i <= 3; i++:
      frequency = i
      time-value = count-down-timer-seconds * frequency-value[i]
      if time-value <= 4096.0:
        break

    if time-value > 4096.0:
      throw "Count down timer value $time-value exceeds maximum value"
    
    time-value-int := time-value.to-int
    print "Time-Value: $time-value-int ($(%b time-value-int))"
    print "Time-Value (seconds): $(time-value-int / frequency-value[frequency])s"
    print "Frequency: $frequency-value[frequency]"
    return [time-value-int, frequency]