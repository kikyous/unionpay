#encoding:utf-8
require 'open-uri'
require 'digest'
module UnionPay
  RESP_SUCCESS  = "00"   #返回成功
  QUERY_SUCCESS = "0"    #查询成功
  QUERY_FAIL    = "1"
  QUERY_WAIT    = "2"
  QUERY_INVALID = "3"
  class Service
    attr_accessor :args

    def self.front_pay(param)
      new.instance_eval do
        param['orderTime']              ||= Time.now.strftime('%Y%m%d%H%M%S')         #交易时间, YYYYmmhhddHHMMSS
        param['orderCurrency']          ||= UnionPay::CURRENCY_CNY                    #交易币种，CURRENCY_CNY=>人民币
        trans_type = param['transType']
        if [UnionPay::CONSUME, UnionPay::PRE_AUTH].include? trans_type
          @api_url = UnionPay.front_pay_url
          param.merge!(UnionPay::Pay_params_empty).merge!(UnionPay::Pay_params)
          @param_check = UnionPay::Pay_params_check
        else
          # 前台交易仅支持 消费 和 预授权
          raise("Bad trans_type for front_pay. Use back_pay instead")
        end
        service(param,UnionPay::FRONT_PAY)
        self
      end
    end

    def self.responce(param)
      new.instance_eval do
        cup_reserved = (param['cupReserved'] ||= '')
        cup_reserved = Rack::Utils.parse_nested_query cup_reserved.gsub(/^{/,'').gsub(/}$/,'')
        if !param['signature'] || !param['signMethod']
          raise('No signature Or signMethod set in notify data!')
        end

        param.delete 'signMethod'
        if param.delete('signature') != Service.sign(param)
          raise('Bad signature returned!')
        end
        param.merge! cup_reserved
        param.delete 'cupReserved'
        self
      end
    end


    def self.sign(args)
      sign_str = args.sort.map do |k,v|
        "#{k}=#{v}&" unless UnionPay::Sign_ignore_params.include? k
      end.join
      Digest::MD5.hexdigest(sign_str + Digest::MD5.hexdigest(UnionPay.security_key))
    end

    def form options={}
      attrs = options.map{|k,v| "#{k}='#{v}'"}.join(' ')
      html = [
        "<form #{attrs} action='#{@api_url}' method='post'>"
      ]
      args.each do |k,v|
        html << "<input type='hidden' name='#{k}' value='#{v}' />"
      end
      if block_given?
        html << yield
        html << "</form>"
      end
      html.join
    end

    private
    def service(param, service_type)
      if param['commodityUrl']
        param['commodityUrl'] = URI::encode(param['commodityUrl'])
      end

      arr_reserved = []
      UnionPay::Mer_params_reserved.each do |k|
        arr_reserved << "#{k}=#{param.delete k}" if param.has_key? k
      end

      if arr_reserved.any?
        param['merReserved'] = arr_reserved.join('&')
      else
        param['merReserved'] ||= ''
      end

      @param_check.each do |k|
        raise("KEY [#{k}] not set in params given") unless param.has_key? k
      end

      # signature
      param['signature']  = Service.sign(param)
      param['signMethod'] = UnionPay::Sign_method
      self.args = param
    end
  end
end
