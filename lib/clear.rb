require 'yaml'

module Clear
  def clear_screen
    system('clear') || system('cls')
  end
end