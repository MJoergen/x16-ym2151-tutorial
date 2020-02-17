# Episode 3 - Playing music!
In this episode we will be controlling multiple channels simultaneously.
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
statements in lines 1000-1310. Each line consists of five values that are
written to the above registers.

The actual writing to the YM2151 takes place in lines 800-960.

## Musical Score
The musical score is written in DATA statements in lines 2000-2700. To make it
easy to read and modify the music, I've chosen the following representation:
* Each line consists of the notes to play for each of the four channels.
* Eight lines represent one bar of the music.
* A note is represented in [scientific pitch
  notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation)
* An empty string means the note continues from the previous line.

The above representation requires some processing to convert it into equivalent
writes to the YM2151.

First of all, reading each line of the musical score takes place in lines
1500-1580. The variable TI is the jiffie counter, which automatically
increments 60 times a second. The variable NT denotes when to proceed to the
next line, and this is updated in line 1570. In other words, this is where the
pace of the music is controlled.

Lines 1520-1560 loop over the four channels, and checks whether a new note is
to be processed, in which case it jumps to the routine in lines 1600-1670.
Here the note is expected to be in the variable N$ and the channel number in
the variable C.

Lines 1610-1630 serve to convert the string into a key code number. This is
done in comjunction with the array N() defined in lines 1400-1460.  The trick
is that the semitone variable K is a number from 0 to 6 corresponding to the
notes A to G. Each number is then mapped to the corresponding key code for the
YM2151. Finally, the note C is special in that the YM2151 considers it to
belong to a previous octave, and therefore we must decrement the octave number
in line 1630.

And that is it! You can now program the YM2151 to play any tune you like.

