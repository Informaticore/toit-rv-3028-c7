class Alarm:

  minutes_/int := -1
  minutes-alarm-enabled_/bool := false
  hours_/int := -1
  hours-alarm-enabled_/bool := false
  weekday-date_/int := -1
  weekday-date-alarm-enabled_/bool := false

  /**  
    * Create a new alarm with the given minutes, hours, and weekday-date.
    * Weekday/Date: If the WADA bit is 0 (Bit 5 in Register 0Fh), it holds
    *   the alarm value for the weekday (weekdays assigned by the user), in two binary coded decimal (BCD) digits. Values
    *   will range from 0 to 6. If the WADA bit is 1, it holds the alarm value for the date, in two binary coded decimal (BCD)
    *   digits. Values will range from 01 to 31. Leap years are correctly handled from 2000 to 2099.
    * 
    * @param minutes The minutes of the alarm. If the value is -1, the alarm is not set.
    * @param hours The hours of the alarm. If the value is -1, the alarm is not set.
    * @param weekday-date The weekday-date of the alarm. If the value is -1, the alarm is not set. 
  */
  constructor --minutes=-1 --hours=-1 --weekday-date=-1:
    if minutes >= 0 and minutes <= 59:
      minutes_ = minutes
      minutes-alarm-enabled_ = true
    if hours >= 0 and hours <= 23:
      hours_ = hours
      hours-alarm-enabled_ = true
    if weekday-date >= 0 and weekday-date <= 31:
      weekday-date_ = weekday-date
      weekday-date-alarm-enabled_ = true

  is-minutes-alarm-enabled -> bool:
    return minutes-alarm-enabled_

  minutes-alarm-enabled enable/bool:
    minutes-alarm-enabled_ = enable
  
  is-hours-alarm-enabled -> bool:
    return hours-alarm-enabled_

  hours-alarm-enabled enable/bool:
    hours-alarm-enabled_ = enable
  
  is-weekday-date-alarm-enabled -> bool:
    return weekday-date-alarm-enabled_
  
  weekday-date-alarm-enabled enable/bool:
    weekday-date-alarm-enabled_ = enable

  minutes -> int:
    return minutes_

  minutes value/int:
    if value >= 0 and value <= 59:
      minutes_ = value

  hours -> int:
    return hours_

  hours value/int:
    if value >= 0 and value <= 23:
      hours_ = value

  weekday-date -> int:
    return weekday-date_

  weekday-date value/int:
    if value >= 0 and value <= 31:
      weekday-date_ = value

  