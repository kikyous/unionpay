require './unionpay/conf'
require './unionpay/service'
require './unionpay/version'
module UnionPay
  class << self
    attr_accessor :mer_id, :security_key, :mer_abbr

    def mer_id= v
      UnionPay::Conf::Pay_params['merId'] = v
    end

    def mer_abbr= v
      UnionPay::Conf::Pay_params['merAbbr'] = v
    end
  end
end