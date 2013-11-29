#!/usr/bin/env ruby
# encoding: utf-8

class BashSetup
  def initialize
  end
  def setup
  end
end

class ZshSetup
  def initialize
  end
  def setup
  end
end

class VimSetup
  def initialize
  end
  def setup
  end
end

class SetupEnv
  attr_accessor :setup_target

  def initialize(setup_target)
    @setup_target = setup_target
  end

  def setup_env
    @setup_target.setup
  end
end
