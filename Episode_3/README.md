# Episode 3 - Playing music!
In this episode we will be controlling multiple channels simultaneously in
order to create music with melody and chords. The accompanying
[program](tutorial3.bas) is considerably longer than the previous examples, but
may be used as a template for your own programs.

The YM2151 has eight independent channels (numbered 0 - 7), but the addressing
of these channels is somewhat convoluted. For most registers the lowest three
address bits determine the channel number. So for instance, the Key Code selector
for the eight channels are located in addresses $28 to $2F.

The one major difference is the Key On/Off register, where it is bits 2-0 of
the *value* that determines the channel. The register address is always the
same, i.e. $08.  So to send a Key On event to channel 1 you must write the
value $09 to register $08.

In this episode I will show a little [program](tutorial3.bas) that can play a
simple tune on the YM2151 using four channels.  One channel is for the melody
and the other three channels are for the accompaning chord. The idea with this
program is that it should be easy to modify for your own needs.

The program consists of two parts: Initialization and Musical Score. We'll
discuss each of these in the following:

## Initialization.
So far we have considered the following five registers for initializing a
channel:
* $2x : Waveform configuration. Set to $C7 for a simple sine wave.
* $8x : Attack Rate.
* $Ax : Decay Rate.
* $Cx : Sustain Rate.
* $Ex : Sustain Level and Release Rate.

where x is the channel number 0-7.

Since each of the four channels can have a separate configuration, and to make
the initialization generic, I've written the values in a number of DATA
statements in lines 1000-1310.
```
1000 REM INITIALIZE CHANNEL 0
1010 DATA $C7, $1F, $0A, $00, $FF
1100 REM INITIALIZE CHANNEL 1
1110 DATA $C7, $1F, $0A, $00, $FF
1200 REM INITIALIZE CHANNEL 2
1210 DATA $C7, $1F, $0A, $00, $FF
1300 REM INITIALIZE CHANNEL 3
1310 DATA $C7, $1F, $0A, $00, $FF
```
Each line consists of five values that are written to the above registers.

The actual writing to the YM2151 takes place in lines 800-960:
```
800 REM INITIALIZE ALL THE CHANNELS
810 FOR C=0 TO 3
820 GOSUB 900
830 NEXT C
840 RETURN

900 REM INTIALIZE A SINGLE CHANNEL (NUMBER IN C)
910 READ V: POKE $9FE0, $20+C: POKE $9FE1, V: REM WAVEFORM
920 READ V: POKE $9FE0, $80+C: POKE $9FE1, V: REM ATTACK RATE
930 READ V: POKE $9FE0, $A0+C: POKE $9FE1, V: REM DECAY RATE
940 READ V: POKE $9FE0, $C0+C: POKE $9FE1, V: REM SUSTAIN RATE
950 READ V: POKE $9FE0, $E0+C: POKE $9FE1, V: REM RELEASE RATE + SUSTAIN LEVEL
960 RETURN
```

## Musical Score
The musical score is written in DATA statements in lines 2000-2700:
```
2000 REM THE MUSICAL SCORE STARTS HERE.
2010 REM FOUR VALUES IN EACH LINE, ONE FOR EACH CHANNEL.
2020 REM EACH LINE CORRESPONDS TO 1/8 OF A BAR.
2030 REM "" MEANS CONTINUE PREVIOUS NOTE.

2100 REM TWINKLE, TWINKLE LITTLE STAR. (C C F C)
2110 DATA "C5", "C4", "E4", "G4"
2120 DATA "C5", "",   "",   ""
2130 DATA "G5", "C4", "E4", "G4"
2140 DATA "G5", "",   "",   ""
2150 DATA "A5", "F4", "A4", "C5"
2160 DATA "A5", "",   "",   ""
2170 DATA "G5", "C4", "E4", "G4"
2180 DATA "",   "",   "",   ""
etc.
```
To make it easy to read and modify the music, I've chosen the following
representation:
* Each line consists of the notes to play for each of the four channels.
* Eight lines represent one bar of the music.
* A note is represented in [scientific pitch
  notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation)
* An empty string means the note continues from the previous line.

The above representation requires some processing to convert each note into
equivalent writes to the YM2151.  First of all, reading each line of the
musical score takes place in lines 1500-1580. 
```
1500 NT=TI+2
1510 IF TI<>NT THEN GOTO 1510
1520 FOR C=0 TO 3
1530 READ N$
1540 IF N$="X" THEN RETURN
1550 IF N$<>"" THEN GOSUB 1600
1560 NEXT C
1570 NT=NT+30
1580 GOTO 1510
```

The system variable TI is the jiffie counter, which automatically increments 60
times a second. The variable NT denotes when to proceed to the next line, and
this is updated in line 1570. In other words, this is where the pace of the
music is controlled.  Lines 1520-1560 loop over the four channels, and checks
whether a new note is to be processed, in which case it jumps to the routine in
lines 1600-1670:
```
1600 REM THIS PLAYS THE NOTE IN N$ ON CHANNEL C.
1610 K=ASC(N$)-ASC("A")                         : REM SEMITONE
1620 O=ASC(MID$(N$,2))-ASC("0")                 : REM OCTAVE
1630 IF K=2 THEN O=O-1                          : REM ADJUST FOR C
1640 POKE $9FE0, $08: POKE $9FE1, C             : REM KEY OFF
1650 POKE $9FE0, $28+C: POKE $9FE1, O*16+N(K)   : REM SET KEY CODE
1660 POKE $9FE0, $08: POKE $9FE1, C+8           : REM KEY ON
1670 RETURN
```

Here the note is expected to be in the variable N$ and the channel number in
the variable C.  Lines 1610-1630 serve to convert the string into a key code
number. This is done in comjunction with the array N() defined in lines
1400-1460.  The trick is that the semitone variable K is a number from 0 to 6
corresponding to the notes A to G. Each number is then mapped to the
corresponding key code for the YM2151. Finally, the note C is special in that
the YM2151 considers it to belong to a previous octave, and therefore we must
decrement the octave number in line 1630.

And that is it! You can now program the YM2151 to play any tune you like.  All
you need to do is to change the contents of the DATA statements from line 2000
onwards, and possibly the channel configuration in lines 1000-1310.

