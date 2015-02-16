# @abstract lightweight configuration class
#
# @author Ollivier Robert <ollivier.robert@eurocontrol.int>
# @copyright 2015 by Ollivier Robert for ECTL

# Small class to avoid putting login/pwd info
class MyConfig
  attr_reader :user, :password, :site, :port

  def initialize(path)
    cfg = {}
    if File.exist?(path)
      File.open(path) do |fh|
        cfg = YAML.load(fh)
      end
    else
      raise "File not present: #{path}"
    end
    @user = cfg['user']
    @password = cfg['password']
    @site = cfg['site']
    @port = cfg['port']
  end

  def self.load(path = DEF_CONFIG)
    MyConfig::new(path)
  end
end