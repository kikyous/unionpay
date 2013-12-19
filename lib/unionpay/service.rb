#encoding:utf-8
require 'open-uri'
require 'digest'
module UnionPay
  module Service
    RESP_SUCCESS  = "00"   #返回成功
    QUERY_SUCCESS = "0"    #查询成功
    QUERY_FAIL    = "1"
    QUERY_WAIT    = "2"
    QUERY_INVALID = "3"

    def self.front_pay(args)

      args['orderTime']              ||= Time.now.strftime('%Y%m%d%H%M%S')               #交易时间, YYYYmmhhddHHMMSS
      args['orderCurrency']          ||= UnionPay::Conf::CURRENCY_CNY                    #交易币种，CURRENCY_CNY=>人民币

      trans_type = args['transType']
      if [UnionPay::Conf::CONSUME, UnionPay::Conf::PRE_AUTH].include? trans_type
        @@api_url = UnionPay::Conf.front_pay_url
        args.merge!(UnionPay::Conf::Pay_params_empty).merge!(UnionPay::Conf::Pay_params)
        param_check = UnionPay::Conf::Pay_params_check
      else
        # 前台交易仅支持 消费 和 预授权
        raise("Bad trans_type for front_pay. Use back_pay instead")
      end
      if args['commodityUrl']
        args['commodityUrl'] = URI::encode(args['commodityUrl'])
      end

      has_reserved = false
      UnionPay::Conf::Mer_params_reserved.each do |k|
        if args.has_key? k
          value = args.delete k
          (arr_reserved ||= []) << "#{k}=#{value}"
          has_reserved = true
        end
      end

      if has_reserved
        args['merReserved'] = arr_reserved.join('&')
      else
        args['merReserved'] ||= ''
      end

      param_check.each do |k|
        raise("KEY [#{k}] not set in params given") unless args.has_key? k
      end

      # signature
      args['signature']    = self.sign(args)
      args['signMethod']   = UnionPay::Conf::Sign_method
      @@args = args
      self
    end

    def self.sign(args)
      sign_str = args.sort.map do |k,v|
        "#{k}=#{v}&" unless UnionPay::Conf::Sign_ignore_params.include? k
      end.join
      Digest::MD5.hexdigest(sign_str + Digest::MD5.hexdigest(UnionPay.security_key))
    end

    def self.form
      html = [
        "<form id='pay_form' name='pay_form' action='#{@@api_url}' method='post'>"
      ]
      @@args.each do |k,v|
        html << "<input type='hidden' name='#{k}' value='#{v}' />"
      end
      if block_given?
        html << yield
        html << "</form>"
      end
      html.join
    end
  end
end
