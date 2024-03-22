# Toit Library for RTC RV-3028-C7
Library to control a RV-3028-C7 RTC with toitlang

## TODO

- [] Implement UNIX Time
- [] Password protection
- [] Timer Status / Status Shadow
- [] Test event control 
- [] Test Clock Interrupt Mask for Clock Output
- [] Implement Clock Output options
- [] General Purpose register
- [] implement Timestamp?
 
## Install
To install the package run
```
jag pkg install rv-3028-c7
```

## Getting Started
You can find a bunch of example codein the example folder

## Run tests
To run all tests you can use
```
toit run --no-device tests/run_all.toit
```