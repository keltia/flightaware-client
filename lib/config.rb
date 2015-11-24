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
require 'toml'

# Small class to avoid putting login/pwd info
class MyConfig
  attr_accessor :users, :password, :site, :port
  attr_accessor :dests, :default, :def_user
  attr_accessor :feed_one, :def_dest

  def check_name(str)
    if str !~ %r{\.toml$}
      return File.join(ENV["HOME"], str, "config.toml")
    end
    str
  end

  def initialize(path)
    cfg = {}
    r_path = check_name(path)
    if File.exist?(r_path)
      cfg = TOML.load_file(r_path)
    else
      raise "File not present: #{r_path}"
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
