require 'yaml'

class Collection
  include Clear
  INTERVALS = YAML.load_file('config/intervals.yml')
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