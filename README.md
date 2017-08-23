# chord-scale-builder
Outside of programming, I have been a semi-professional musician for much of my life.  

In my early days of learning Ruby, I wrote this fun little 'Music Theory CLI utility', not to solve any problem I couldn't do in my head already, but to explore the problem space of interval/scale/chord construction.   


user selects root tone and chord/scale type
program does the logic based on intervallic relationships defined in yml files, prints out the notes of requested chord/scle

intervals.yml defines all intervals in arrays = [half_steps, diatonic_steps]

chords.yml and scales.yml define chord/scale types as an array:
----[list_number, chord/scale_name, [intervals, in, the, chord, or, scale]

