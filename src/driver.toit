import serial
import .registers as reg
import .utils as utils
import .status
import .control
import .alarm

I2C_ADDRESS ::= 0x52

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

  seconds:
    return _read_bcd reg.SECONDS

  seconds value:
    _write reg.SECONDS (_dec_to_bcd value)

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

  alarm alarm/Alarm:
    //disable the alarm interrupt
    control_ := control
    control_.enable-alarm-interrupt false
    control control_
    //clear the alarm interrupt
    status_ := status
    status_.clear-alarm-interrupt
    status status_

    if alarm.minutes >= 0:
      minutes := _dec-to-bcd alarm.minutes
      if alarm.is-minutes-alarm-enabled:
        minutes |= 0x80 // if minutes alarm is enabled, set the MSB to 1
      else:
        minutes &= 0x7F // if minutes alarm is disabled, set the MSB to 0
      _write reg.MINUTES-ALARM minutes
    if alarm.hours >= 0:
      hours := _dec-to-bcd alarm.hours
      if alarm.is-hours-alarm-enabled:
        hours |= 0x80 // if hours alarm is enabled, set the MSB to 1
      else:
        hours &= 0x7F // if hours alarm is disabled, set the MSB to 0
      _write reg.HOURS-ALARM hours
    if alarm.weekday_date >= 0:
      weekday-date := _dec-to-bcd alarm.weekday-date
      if alarm.is-weekday-date-alarm-enabled:
        weekday-date |= 0x80 // if weekday-date alarm is enabled, set the MSB to 1
      else:
        weekday-date &= 0x7F // if weekday-date alarm is disabled, set the MSB to 0
      _write-bcd reg.WEEKDAY-DATE-ALARM weekday-date

    // enable the alarm interrupt
    control_ = control
    control_.enable-alarm-interrupt true
    control control_