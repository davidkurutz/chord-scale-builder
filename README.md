# chord-scale-builder
Outside of programming, I have been a semi-professional musician for much of my life.  

In my early days of learning Ruby, I wrote this fun little 'Music Theory CLI utility', not to solve any problem I couldn't do in my head already, but to explore the problem space of interval/scale/chord construction. 

* what are the decisions that need to be made in constructing a specific scale or chord (intervallic template) based on a root tone?
* what decisions do we make regarding enharmonic tones?  ie:  
	* C Major chord = C E G, 
	* C# Major Chord = C# E# G#
	* Db Major Chord = Db Eb Gb
* I set out to write a CLI utility that could accurately choose not only the correct tone, but also decide what name that tone should have in the current scale/chord context:  F vs E# vs Gbb


## Usage
`./cs_app.rb`

* Follow prompts to selects root tone and chord/scale type
* Intervallic relationships of chord/scale types are defined defined in config/*.yml files. 
* Application performs necessary logic to print out list of tones that make up requested chord/scale

### Configuration
intervals.yml defines all intervals in arrays of  [half\_step\_count, diatonic\_step\_count].

All standard intervals are already defined.

chords.yml and scales.yml define chord/scale types as an array:

----[list\_number, chord/scale\_name, [intervals, in, the, chord, or, scale]]

Additional chords or scale types can be added using the established format in the config/*.yml files.

