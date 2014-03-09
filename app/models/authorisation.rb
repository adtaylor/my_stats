class Authorisation < ActiveRecord::Base
  belongs_to :user

  after_create :add_subscription

  def add_subscription
    self.send("#{self.provider.downcase}_add_subscription")
  end


  def client
    self.send("#{self.provider.downcase}_client")
  end

  #
  # Fitbit Shiz TODO: Move this out I think
  #

  def fitbit_client
    _client ||= Fitgem::Client.new(
      :consumer_key => ENV["FITBIT_CONSUMER_KEY"],
      :consumer_secret => ENV["FITBIT_CONSUMER_SECRET"],
      :token => self.token,
      :secret => self.secret,
      :user_id => self.uid
    )
  end

  def fitbit_add_subscription
    fb_client = client
    opts = { :subscription_id => self.user_id, :type => :all }
    fb_client.create_subscription(opts)
  end


end
