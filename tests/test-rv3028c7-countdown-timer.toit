import .testoiteron
import rv-3028-c7
import i2c
import gpio
import .register-mock

class TestRV3028C7ct implements TestCase:

  run:
    test-bcd-to-dec-value

  test-bcd-to-dec-value:
    print "test-bcd-to-dec-value"
    count-down-timer-seconds := 3.203
    frequency-value := 4096 
    count-down-timer-value/int := (count-down-timer-seconds * frequency-value).to-int
    print "Count down timer value: $count-down-timer-value"


main:
  test := TestRV3028C7ct
  test.run