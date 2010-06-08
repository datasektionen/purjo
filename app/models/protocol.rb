class Protocol
  VALID_FILENAME = /^smprot_(\d{4,4}-\d{2,2}-\d{2,2})_(.+)\.(.+)$/
  attr_reader :type, :date, :name, :filename
  
  def initialize(filename)
    @filename = filename
    
    filename =~ VALID_FILENAME
    
    @date = $1
    @name = $2
    @type = $3
  end
  
  def self.all
    protocols = Dir.entries(APP_CONFIG['protocol_path'])
    protocols.delete_if {|p| !(p =~ VALID_FILENAME)}
    protocols.map! { |p| new(p) }
    protocols.reverse!
    protocols
  end
end
