require 'yaml'

class Scale < Collection
  def initialize(root)
    @source = YAML.load_file('config/scales.yml')
    super(root)
  end
end