# YM2151 Tutorial

This is a tutorial on how to get started making music on a YM2151. 

## Overview

The YM2151 has eight parallel sound channels and each sound channel consists 
of the following:

* A key note selector. This selects the base frequency (pitch) to be played.
* A waveform generator. This selects the timbre of the note.
* An envelope generator. This selects the amplitude modulation of the note.

All three of the above must be configured, in order to get sound out of the
YM2151 chip.

Furthermore, the YM2151 has a dedicated noise generator as well as a vibraro
generator.

In the following each of these parts will be described briefly.

* [Episode 1 - Hello World!](Episode_1)
* [Episode 2 - Amplitude Modulation](Episode_2)
* [Episode 3 - Playing music!](Episode_3)


=====================================================================

## Episode 4 - The waveform generator (part 1)

The way the YM2151 generates the waveform is quite convoluted, so we'll start
with something easy - feedback.


Furthermore, the overall volume of the channel is controlled by the "Total level".

### The waveform generator
The timbre of the tone is controlled by four sine wave generators that can be
connected in various ways.

The four sine wave generators are named "Modulator 1", "Carrier 1", "Modulator 2",
and "Carrier 2".

They can be combined in series (composition of functions) or in parallel
(additive). Additionally, the generator "Modulator 1" has a built-in feedback
loop.

Each of the eight sound channels has a register containing the connection
function.  These are located in addresses $20 to $27, where bits 2-0 are the
connection function. In the same register, bit 7 enables the right output and
bit 6 enables the left output. Bits 5-3 control the feedback on Modulator 1.

The connection function has the following interpretation:

0. C2( M2( C1(M1) ) )
1. C2( M2(C1 + M1) )
2. C2( M2(C1) + M1 )
3. C2( M2 + C1(M1) )
4. C1(M1) + C2(M2)
5. C1(M1) + M2(M1) + C2(M1)
6. C1(M1) + M2 + C2
7. M1 + C1 + M2 + C2

To get a pure sine wave on the output, it is enough to write the value $C7 to
the register $20. This configures all four sine waves in a parallel connection,
and we will only be using the "Modulator1" generator.

## Summary
To play a single A4 note the following writes can be used:
* Write $1F to $80. Maximum Attack Rate for "Modulator1" on channel 0.
* Write $0A to $A0. First Decay Rate for "Modulator1" on channel 0.
* Write $FF to $E0. Maximum Release Rate for "Modulator1" on channel 0.
* Write $C7 to $20. Select connection mode 7 on channel 0.
* Write $4A to $28. Select key A4 on channel 0.
* Write $08 to $08. Trigger "key-on" on channel 0.

## The register interface:
| Address |  Bits  | Function | Description       | Abbreviation |
| ------- | ------ | -------- | ----------------- | ------------ |
|  $01    |   1    | Vibrato  | LFO reset         | TEST         |
|  $08    |  2-0   | Key      | Channel select    | CH #         |
|         |   3    |          | Carrier 2         | SM KON       |
|         |   4    |          | Modulator 2       | SM KON       |
|         |   5    |          | Carrier 1         | SM KON       |
|         |   6    |          | Modulator 1       | SM KON       |
|  $0F    |   7    | Noise    | NE                | NE           |
|         |  4-0   |          | Noise frequency   | NFRQ         |
|  $10    |  7-0   | General  | Timer A1          | CLKA1        |
|  $11    |  1-0   | General  | Timer A2          | CLKA2        |
|  $12    |  7-0   | General  | Timer B           | CLKB         |
|  $14    |   7    | General  | CSM               |              |
|         |  5-4   |          | F Reset           |              |
|         |  3-2   |          | IRQ Enable        |              |
|         |  1-0   |          | Load              |              |
|  $18    |  7-0   | Vibrato  | LFO frequency     | LFRQ         |
|  $19    |   7    | Vibrato  | Select            |              |
|         |  6-0   |          | Modulation depth  | PMD/AMD      |
|  $1B    |   7    | General  | CT2               |              |
|         |   6    | General  | CT1               |              |
|         |  1-0   | Vibrato  | LFO waveform      | W            |
|  $20    |   7    | Waveform | Right             |              |
|         |   6    | Waveform | Left              |              |
|         |  5-3   | Waveform | FB                |              |
|         |  2-0   | Waveform | Connect           |              |
| $28-$2F |  6-4   | Key      | Octave            | KC           |
|         |  3-0   | Key      | Note              | KC           |
| $30-$37 |  7-2   | Key      | Fraction          | KF           |
| $38-$3F |  6-4   | Vibrato  | PMS               |              |
|         |  1-0   | Vibrato  | AMS               |              |
| $40-$5F |  6-4   | Key      | Detune1           | DT1          |
|         |  3-0   | Key      | Phase Multiply    | MUL          |
| $60-$7F |  6-0   | Envelope | Total level       | TL           |
| $80-$9F |  7-6   | Envelope | Key Scale         | KS           |
|         |  4-0   | Envelope | Attack Rate       | AR           |
| $A0-$BF |   7    | Vibrato  | AM sensitivity    | AMS-EN       |
|         |  4-0   | Envelope | First Decay Rate  | D1R          |
| $C0-$DF |  7-6   | Key      | Detune2           | DT2          |
|         |  3-0   | Envelope | Second Decay Rate | D2R          |
| $E0-$FF |  7-4   | Envelope | First Decay Level | D1L          |
|         |  3-0   | Envelope | Release Rate      | RR           |


## Advanced stuff
There are a few other registers that influence the base frequency. These are:
KF, MUL, DT1, DT2, and PMS.

## References
This is based on the [original
documentation](http://map.grauw.nl/resources/sound/yamaha_ym2151_synthesis.pdf),
as well as the [MAME emulation](https://github.com/mamedev/mame/).


