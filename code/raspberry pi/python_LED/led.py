import RPi.GPIO as GPIO
from time import sleep
import sys

import datetime



GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
segmentpins = [32,12,29,5,3,23,31,38] #数字盤側
digitpins = [11,21,19,33] #桁数側
GPIO.setup(segmentpins, GPIO.OUT)
GPIO.setup(digitpins, GPIO.OUT)

numbers = [
    #a,b,c,d,e,f,g,p
    [1,1,1,1,1,1,0], #0
    [0,1,1,0,0,0,0], #1
    [1,1,0,1,1,0,1], #2
    [1,1,1,1,0,0,1], #3
    [0,1,1,0,0,1,1], #4
    [1,0,1,1,0,1,1], #5
    [1,0,1,1,1,1,1], #6
    [1,1,1,0,0,1,0], #7
    [1,1,1,1,1,1,1], #8
    [1,1,1,0,0,1,1], #9
    ]

def displayNumber(n):
    ns = numbers[n]
    for i,n in enumerate(ns):
        n = 1 if n == 0 else 0
        GPIO.output(segmentpins[i],n)

def displayNumbers(vs):
    for i in range(4):
        GPIO.output(digitpins[i], 1)
        displayNumber(vs % 10)
        digitalclear()
        GPIO.output(digitpins[i], 0)
        vs = vs // 10

def digitalclear():
    for i in range(8):
        GPIO.output(segmentpins[i], 1)


def main() :
    try:
        while True:
            dt_now = datetime.datetime.now()
            no = int(dt_now.hour*100+dt_now.minute)
            displayNumbers(no)
    finally:
        GPIO.cleanup()


if __name__ == "__main__":
    sys.exit(main())
