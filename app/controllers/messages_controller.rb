class MessagesController < ApplicationController
  @@nouns = File.readlines("data/nouns.txt").each do |s|
    s.delete_suffix!("\n")
  end

  def show
    @message = Message.find_by_address(params[:id])
    if @message.nil?
      not_found
    end
  end

  def new
    @message = Message.new
    begin
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

  def create
    @message = Message.new(message_params)

    @message.address = get_address

    if @message.save
      redirect_to "/messages/" + @message.address
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @message = Message.find_by_address(params[:address])
    if @message
      redirect_to "/messages/" + @message.address
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def get_address
    exit = false
    until exit do
      address = ""
      3.times do |i|
        address += @@nouns[Random.rand(@@nouns.length)]
        unless i == 2
          address += "_"
        end
      end
      exit = Message.find_by(address: address) == nil
    end
    address
  end
end

