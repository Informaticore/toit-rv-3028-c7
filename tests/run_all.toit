import .testoiteron
import .test_utils
import .test-rv3028c7
import .test-rv3028c7-control
import .test-rv3028c7-status

main:
  print "Run all test"
  testcases := [TestUtils, TestRV3028C7, TestRV3028C7Control, TestRV3028C7Status]
  testcases.do: | test_case/TestCase |
    test_case.run
      
  print ""
  print "(｡◕‿◕｡) -ALL TESTS OKAY"
