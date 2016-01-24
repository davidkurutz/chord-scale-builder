require 'pry'
require 'yaml'
INTERVALS = YAML.load_file('intervals.yml')
SCALES = YAML.load_file('scales.yml')
CHORDS = YAML.load_file('chords.yml')
NATS = %w(A B C D E F G)
ENHARMS = [['A', 'G##', 'Bbb'],
           ['A#', 'Bb', 'Cbb'],
           ['B', 'A##', 'Cb'],
           ['C', 'B#', 'Dbb'],
           ['C#', 'B##', 'Db'],
           ['D', 'C##', 'Ebb'],
           ['D#', 'Eb', 'Fbb'],
           ['E', 'D##', 'Fb'],
           ['F', 'E#', 'Gbb'],
           ['F#', 'Gb', 'E##'],
           ['G', 'F##', 'Abb'],
           ['G#', 'Ab', 'Bbbb']]

# takes in user selected tone
# returns index of enharmonic array that includes given tone
def eh_index(tne)
  ENHARMS.index(ENHARMS.detect { |arr| arr.include?(tne) })
end

# takes root tone, desired halfstep + natural intervals
# accounts for musical scale looping after G in natural notes
# uses enharmonic interval to isolate correct array of enharmonic notes
# returns the correct enharmonics based on root and interval requested
def fetch_tone(tne, h_steps, n_steps)
  target = if NATS.index(tne[0, 1]) + n_steps > 6
             NATS.index(tne[0, 1]) + n_steps - 7
           else
             NATS.index(tne[0, 1]) + n_steps
           end

  ENHARMS.fetch(eh_index(tne) + h_steps).detect { |n| n.include?(NATS[target]) }
end

# takes root note and desired interval,
# translates interval into half steps/diatonic steps from yml file
# accounts for musical scale looping after 'G#' in enharmonics
# passes note, halfstep interval, natural interval to fetch_tone
def determine_tone(tne, int)
  h_steps = INTERVALS[int][0]
  n_steps = INTERVALS[int][1]

  if eh_index(tne) + h_steps > 11
    fetch_tone(tne, h_steps - 12, n_steps)
  else
    fetch_tone(tne, h_steps, n_steps)
  end
end

# takes user selected tone and symbol representing scale intervals
# retrieves array of interval symbos from yml file
# passes root and each interval to determine_tone
# captures results in array, joins to string
def generate_scale(tne, scale_sym, source)
  scale = []
  source[scale_sym][2].each do |int|
    scale.push(determine_tone(tne, int))
  end
  scale.join(' ')
end

# prints name of chord/scale + notes
def print_scale(tne, scale_sym, source)
  puts <<-MSG

#{tne} #{source[scale_sym][1]} is:
#{generate_scale(tne, scale_sym, source)}
  MSG
end

def play_again?
  puts 'Would you like to build another chord or scale? Y/n'
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def valid_tone?(tne)
  ENHARMS.flatten.include?(tne)
end

def valid_choice?(choice)
  %w(1 2).include?(choice)
end

def valid_scale?(scalenum, source)
  source.values.map { |i| i[0] }.include?(scalenum)
end

def display_choose_tone
  system('clear')
  puts 'Welcome to the scale and chord builder.'
  puts ''
  puts 'Select root tone by name: (case sensitive)'
  ['  ', '# ', 'b '].each do |symbol|
    NATS.each { |n| print n + symbol }
    puts ''
  end
end

def display_choose_scale(source)
  if source == CHORDS
    puts 'Select chord type by number.'
  else
    puts 'Select scale type by number'
  end
  source.each { |_k, v| puts v[0].to_s + ') ' + v[1].to_s }
end

# translates number to scale symbol
def my_scale(scale_num, source)
  source.find { |_k, v| v[0] == scale_num }.first
end

# main loop
loop do
  display_choose_tone

  my_tone = nil
  loop do
    my_tone = gets.chomp
    valid_tone?(my_tone) ? break : puts('Invalid tone! Try again!')
  end

  puts 'Would you like to build a 1) scale, or 2) chord?'
  choice = nil
  loop do
    choice = gets.chomp
    valid_choice?(choice) ? break : puts('Please select 1 or 2.')
  end

  choice == '1' ? source = SCALES : source = CHORDS
  display_choose_scale(source)

  scale_num = nil
  loop do
    scale_num = gets.chomp
    valid_scale?(scale_num, source) ? break : puts('Invalid choice, Try again!')
  end

  print_scale(my_tone, my_scale(scale_num, source), source)
  break unless play_again?
end
