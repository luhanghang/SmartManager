class Utils
  def self.date(str)
    return '0' + str.to_s if str.to_i < 10
    return str.to_s
  end
end