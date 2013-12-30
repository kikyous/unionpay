module UnionPay
  class << self
    def empty? str
      str !~ /[^[:space:]]/
    end
  end
end