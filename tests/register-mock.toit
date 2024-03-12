import serial

class RegistersMock extends serial.Registers:
  
  read-bytes address/int count/int -> ByteArray:
    return #[0x00]

  read-bytes register/int count/int [failure] -> ByteArray:
    return #[0x00]
  
  write-bytes address data:
    return