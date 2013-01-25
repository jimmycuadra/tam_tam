require "tam_tam/version"
require "tam_tam/logs"

module TamTam
  class << self
    def new(*args)
      TamTam::Logs.new(*args)
    end
  end
end
