# Episode 1 - Hello World!

In this first episode we will learn how to select different notes to play.
This will be the "Hello World" for the YM2151!

## Communicating with the YM2151 on the Commander X16.
The Commander X16 assigns two I/O ports for communicating with the YM2151:
$9FE0 and $9FE1. The YM2151 internally has a 256-byte virtual memory map. To
write a value to the YM2151, first the register address must be written to
$9FE0, and then the register value must be written to $9FE1.

For instance, the following sequence
```
POKE $9FE0, $28: POKE $9FE1, $4A
```
writes the value $4A to the virtual register address $28 within the YM2151..

## Configuring channel 0 to play a simple sine save.
As noted in the introduction the waveform generator and envelope generator must
be configured before the YM2151 will output any sounds. The bare minimum is
the following sequence of commands, which configures channel 0 to generate
a simple sine wave:
```
POKE $9FE0, $20: POKE $9FE1, $C7
POKE $9FE0, $80: POKE $9FE1, $1F
POKE $9FE0, $E0: POKE $9FE1, $0F
POKE $9FE0, $08: POKE $9FE1, $08
```
The above commands will all be explained in the following episodes of this
tutorial.  In this episode, we will focus on selecting which note to play.

## The note selector.
The key (base frequency) is made up of an octave selector (bits 6-4 of register
$28) and a semitone selector (bits 3-0 of register $28).  The chip supports 8
octaves with 12 semitones within each octave.

The semitone selector is encoded as follows:

|  Note |  Value |
| ----- | ------ |
|   C#  |    0   |
|   D   |    1   |
|   D#  |    2   |
|   E   |    4   |
|   F   |    5   |
|   F#  |    6   |
|   G   |    8   |
|   G#  |    9   |
|   A   |   10   |
|   A#  |   12   |
|   B   |   13   |
|   C   |   14   |

The tone A4 (frequency of 440 Hz) is achieved by using the value 4 for the
octave selector and the value 10 for the semitone selector.  This corresponds
to writing the value $4A to the register $28, which is achieved by the
following command:
```
POKE $9FE0, $28: POKE $9FE1, $4A
```

To play the slightly higher pitched E5 note, use the command:
```
POKE $9FE0, $28: POKE $9FE1, $54
```

All this is shown in the BASIC source file [tutorial1.bas](tutorial1.bas)

Now you can play individual notes on the YM2151!

