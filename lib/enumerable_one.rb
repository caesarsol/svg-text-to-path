module Enumerable
  class TooManyElements < Exception
  end

  def one!
    raise TooManyElements.new("Too many elements! Expecting 1, found #{length}.") if length > 1
    first
  end
end
