class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:create]
  skip_before_filter :authenticate_user!, only: [:create]

  # GET /notifications
  # GET /notifications.json
  def index
    puts "=========================="
    puts "INDEX"
    @notifications = Notification.where({user: current_user})
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    puts "=========================="
    puts "SHOW"
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end


  def sleep_logger
    @@sleep_logger ||= Logger.new("#{Rails.root}/log/sleep.log")
    @@sleep_logger.formatter = proc  do |sev, ts, prog, msg|
      hash = { type: "sleep", date:  ts.strftime("%Y-%m-%dT%H:%M:%S"), data: msg }
      hash.to_json
    end
    @@sleep_logger
  end

  # POST /notifications
  # POST /notifications.json
  def create
    puts "=========================="
    puts "CREATE"
    JSON[params["updates"].read].each do |notification|
      user = User.find(notification["subscriptionId"])
      if user
        case notification["collectionType"]
          when "sleep"
            user.fitbit.client.sleep_on_date(notification["date"])["sleep"].each do |data|
              sleep_event = { user_id: notification["subscriptionId"], provider: params[:app_id], body: data  }
              sleep_logger.info sleep_event
            end
        end
      end
    end
    render text: "", status: 204
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    puts "=========================="
    puts "UPDATE"
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:provider, :body, :user_id)
    end
end
