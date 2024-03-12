import .testoiteron
import rv-3028-c7
import i2c
import gpio
import .register-mock

class TestRV3028C7 implements TestCase:

  run:
    test-bcd-to-dec-value

  test-bcd-to-dec-value:
    print "test-bcd-to-dec-value"
    rtc := rv-3028-c7.RV-3028-C7 RegistersMock

    //80 40 20 10 8 4 2 1
    assertEquals (rtc._bcd_to_dec 0xff) (80+40+20+10+8+4+2+1)
    assertEquals (rtc._bcd_to_dec 0b11110000) (80+40+20+10)
    assertEquals (rtc._bcd_to_dec 0b00001111) (8+4+2+1)
    assertEquals (rtc._bcd_to_dec 0b01000010) (40+2)

main:
  test := TestRV3028C7
  test.run