10 REM THIS PROGRAM IS PART 1 OF THE YM2151 TUTORIAL.

100 REM CHANNEL 0 SETUP (GENERATE A SIMPLE SINE WAVE).
100 POKE $9FE0, $20: POKE $9FE1, $C7
110 POKE $9FE0, $80: POKE $9FE1, $1F
120 POKE $9FE0, $E0: POKE $9FE1, $FF
130 POKE $9FE0, $08: POKE $9FE1, $08

200 REM CHANNEL 0 KEY CODE (A4)
210 POKE $9FE0, $28: POKE $9FE1, $4A

