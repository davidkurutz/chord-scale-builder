#!/usr/bin/env ruby

require_relative 'lib/clear.rb'
require_relative 'lib/collection.rb'

Dir["lib/*.rb"].each {|file| require_relative file }

builder = CSBuilder.new
builder.play
