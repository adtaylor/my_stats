class Authorisation < ActiveRecord::Base
  belongs_to :user

  def client
    self.send("#{self.provider.downcase}_client")
  end

  def fitbit_client
    _client ||= Fitgem::Client.new(
      :consumer_key => ENV["FITBIT_CONSUMER_KEY"],
      :consumer_secret => ENV["FITBIT_CONSUMER_SECRET"],
      :token => self.token,
      :secret => self.secret,
      :user_id => self.uid
    )
    opts = { :subscriber_id => self.uid, :type => :all }
    _client.body_weight({:base_date => "2014-02-01",:end_date => "2014-02-28"})
  end

end
