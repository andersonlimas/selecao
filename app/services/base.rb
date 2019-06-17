module Services
  module Base
    def raise_msg(msg, error_class = ArgumentError)
      raise error_class.new(msg)
    end
  end
end
