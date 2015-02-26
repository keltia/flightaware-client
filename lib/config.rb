# @abstract lightweight configuration class
#
# @author Ollivier Robert <ollivier.robert@eurocontrol.int>
# @copyright 2015 by Ollivier Robert for ECTL

# Fields:
#
# --- Flightaware credentials
# - user
# - password
# - site
# - port
#
# --- Different destinations, default is 1st one
# - dests
#   - broker
#   - name
#   - type    queue|topic

# Standard modules
require 'yaml'

# Small class to avoid putting login/pwd info
class MyConfig
  attr_accessor :user, :password, :site, :port
  attr_accessor :dests, :default
  attr_accessor :feed_one

  def initialize(path)
    cfg = {}
    if File.exist?(path)
      File.open(path) do |fh|
        cfg = YAML.load(fh)
      end
    else
      raise "File not present: #{path}"
    end
    cfg.each do |k, v|
      self.send("#{k}=", v)
    end
    @default = @dests.keys[0]
    @feed_one = Proc.new{|buf| $stdout.puts(buf) }
  end

  # Helper to load config
  #
  def self.load(path = DEF_CONFIG)
    MyConfig::new(path)
  end

  # Displays list of possible destination
  #
  def dlist
    @dests.keys
  end

end

if $0 == __FILE__
  c = MyConfig.load('/Users/roberto/.flightaware/config.yml')
  puts c
end
