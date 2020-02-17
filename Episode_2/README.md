# Episode 2 - Amplitude modulation
Each channel has an associated envelope generator that controls the amplitude
modulation of the output.

The waveform (also called "ADSR envelope") is characterized by the following
five parameters:
* Attack rate (bits 4-0 of register address $80)
* Decay rate (bits 4-0 of register address $A0)
* Sustain attenuation (bits 7-4 of register address $E0)
* Sustain rate (bits 4-0 of register address $C0)
* Release rate (bits 3-0 of register address $E0)

as well as the events "Key On" and "Key Off" (bit 3 of register address $08).

The first four parameters control the envelope after a "Key On" event, while
the last parameter controls the envelope after a "Key Off" event.

## ADSR envelope
When a "Key On" event is issued the envelope generated consists of the
following three phases:
1. "Attack phase" : The amplitude increases linearly up to the maximum at a
rate given by the "Attack Rate" parameter.
2. "Decay phase" :  The amplitude decreases exponentially at a rate given by
"Decay Rate" until the attenuation reaches the level given by "Sustain
attenuation".
3. "Sustain phase" : The amplitude decreases further at a rate given by
"Sustain Rate".

When a "Key Off" event is issued the envelope enters the last phase:
4. "Release phase" : The amplitude decreases at a rate given by "Release Rate".

To get a square envelope (i.e. maximum volume right after "Key On", and no
output right after "Key Off"), the following values suffice: Writing the value
$1F to register $80 (maximum Attack Rate), and the value $FF to the register
$E0 (maximum Release Rate, and maximum Sustain Attentuation).
```
POKE $9FE0, $80: POKE $9FE1, $1F
POKE $9FE0, $E0: POKE $9FE1, $FF
```
Those were exactly the values used in [Episode 1](../Episode_1) of the tutorial.

To send the "Key On" event write the value $08 to address $08:
```
POKE $9FE0, $08: POKE $9FE1, $08
```

To send the "Key Off" event write the value $00 to address $08:
```
POKE $9FE0, $08: POKE $9FE1, $00
```

To get a sound that more closely resembles a string instrument, where the
volume of the note slowly decays, one can add a Decay Rate of $0A to the
settings. This corresponds to writing the value $0A to register $A0.
```
POKE $9FE0, $A0: POKE $9FE1, $0A
```

All this is shown in the BASIC source file [tutorial2.bas](tutorial2.bas)


