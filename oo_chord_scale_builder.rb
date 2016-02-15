require 'yaml'

module Clear
  def clear_screen
    system('clear') || system('cls')
  end
end

class Collection
  include Clear
  INTERVALS = YAML.load_file('intervals.yml')
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

  def initialize(root)
    @root = root
    display_choose_quality
    printout
  end

  private

  def my_collection
    @source.find { |_k, v| v[0] == @quality_num }.first
  end

  def validate_quality
    loop do
      @quality_num = gets.chomp
      valid_scale? ? break : puts('Invalid choice, Try again!')
    end
  end

  def valid_scale?
    @source.values.map { |i| i[0] }.include?(@quality_num)
  end

  def generate
    scale = []
    @source[my_collection][2].each do |int|
      scale.push(determine_tone(int))
    end
    scale.join(' ')
  end

  def determine_tone(int)
    h_steps = INTERVALS[int][0]
    n_steps = INTERVALS[int][1]

    if eh_index + h_steps > 11
      fetch_tone(h_steps - 12, n_steps)
    else
      fetch_tone(h_steps, n_steps)
    end
  end

  def eh_index
    ENHARMS.index(ENHARMS.detect { |arr| arr.include?(@root) })
  end

  def fetch_tone(h_steps, n_steps)
    target = if NATS.index(@root[0, 1]) + n_steps > 6
               NATS.index(@root[0, 1]) + n_steps - 7
             else
               NATS.index(@root[0, 1]) + n_steps
             end

    ENHARMS.fetch(eh_index + h_steps).detect { |n| n.include?(NATS[target]) }
  end

  def display_list
    @source.each { |_k, v| puts v[0].to_s + ') ' + v[1].to_s }
  end

  def display_choose_quality
    clear_screen
    if self.instance_of?(Scale)
      puts 'Select scale type by number'
    else
      puts 'Select chord type by number'
    end
    display_list
    validate_quality
  end

  def printout
    clear_screen
    puts <<-MSG.gsub(/^\s*/, '')

    #{@root} #{@source[my_collection][1]} is:
    #{generate}
        MSG
  end
end

class Chord < Collection
  def initialize(root)
    @source = YAML.load_file('chords.yml')
    super(root)
  end
end

class Scale < Collection
  def initialize(root)
    @source = YAML.load_file('scales.yml')
    super(root)
  end
end

class CSBuilder
  include Clear
  def play
    display_hello
    loop do
      display_choose_root
      choose_root
      scale_or_chord
      break unless play_again?
      clear_screen
    end
    display_goodbye
  end

  private

  def display_hello
    clear_screen
    puts 'Welcome to the scale and chord builder.'
    puts ''
  end

  def display_goodbye
    clear_screen
    puts 'Thanks for using the Chord-Scale Builder'
  end

  def display_choose_root
    puts 'Select root tone by name: (case sensitive)'
    ['  ', '# ', 'b '].each do |symbol|
      Collection::NATS.each { |n| print n + symbol }
      puts ''
    end
  end

  def choose_root
    my_root = nil
    loop do
      my_root = gets.chomp
      valid_root?(my_root) ? break : puts('Invalid tone! Try again!')
    end
    @root = my_root
  end

  def valid_root?(tne)
    Collection::ENHARMS.flatten.include?(tne)
  end

  def scale_or_chord
    clear_screen
    puts 'Would you like to build a 1) scale, or 2) chord?'
    choice = nil
    loop do
      choice = gets.chomp
      %w(1 2).include?(choice) ? break : puts('Please select 1 or 2.')
    end

    choice == '1' ? Scale.new(@root) : Chord.new(@root)
  end

  def play_again?
    puts 'Would you like to build another chord or scale? Y/n'
    answer = gets.chomp
    answer.downcase.start_with?('y')
  end
end

builder = CSBuilder.new
builder.play
