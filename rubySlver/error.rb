class Error
  # I run this at irb
  def error
    is_first_time = true
    begin
      raise RuntimeError.new 'first error!' if is_first_time
      raise ArgumentError.new 'second error!'
    rescue RuntimeError => e
      p e.message
      is_first_time = false
      retry
    rescue ArgumentError => e
      p e.message
      raise
    ensure
      p 'ensure run at last!'
    end
  end
end


# => "first error!"
# => "second error!"
# => "ensure run at last!"
# => ArgumentError: second error!
# => 	from (irb):5:in `error'
# => 	from (irb):17
# => 	from /usr/bin/irb:11:in `<main>'
