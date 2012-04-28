class Gateway < ActiveRecord::Base
  has_many :encoders,  :dependent => :destroy
  has_many :spots, :through => :encoders
  has_many :companies_gateways#, :dependent => :destroy
  has_and_belongs_to_many :companies
  has_many :spot_states, :dependent => :destroy

  WS_PORT = 80

  def generate_seq()
    seq = {}
    Gateway.find(:all).each do |g|
      seq[g.seq] = 1
    end
    for i in 1..127
      unless seq[i]
        self.seq = i
        return
      end
    end
  end

  def generate_encoder_seq(encoder)
    seq = {}
    self.encoders.each do |e|
      seq[e.seq] = 1
    end
    for i in 1..65535
      unless seq[i]
        encoder.seq = i
        return
      end
    end
  end

  def generate_spot_seq(spot)
    seq = {}
    self.spots.each do |s|
      seq[s.seq] = 1
    end
    for i in 1..65535
      unless seq[i]
        spot.seq = i
        return
      end
    end
  end
end
  