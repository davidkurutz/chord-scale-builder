require 'yaml'

class Chord < Collection
  def initialize(root)
    @source = YAML.load_file('config/chords.yml')
    super(root)
  end
end