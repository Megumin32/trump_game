class Player
  attr_reader :name

  @@group = []

  def initialize(name)
    @name = name
  end

  def self.group
    @@group
  end

  def self.Generate_players(name)
    @@group << Player.new(name)
  end
end
