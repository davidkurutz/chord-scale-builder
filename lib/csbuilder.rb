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