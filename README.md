# chord-scale-builder
builds chords and scales based on root note and chord/scale type

ruby script and accompanying yml files.

user selects root tone and chord/scale type
program does the logic based on intervallic relationships defined in yml files, prints out the notes of requested chord/scle

intervals.yml defines all intervals in arrays = [half_steps, diatonic_steps]
chords.yml and scales.yml define chord/scale types as an array:
----[list_number, chord/scale_name, [intervals, in, the, chord, or, scale]

