class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :feedbacks

  before_save do
    # Retroactively update
    (self.changed & ["stackexchange_chat_id", "meta_stackexchange_chat_id", "stackoverflow_chat_id"]).each do
      # todo
    end
  end

  def active_for_authentication?
    super && is_approved?
  end

  def inactive_message
    if !is_approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def update_chat_ids
    return if stack_exchange_account_id.nil?

    self.stackexchange_chat_id = Net::HTTP.get_response(URI.parse("http://chat.stackexchange.com/accounts/#{stack_exchange_account_id}"))["location"].scan(/\/users\/(\d*)\//)[0][0]

    self.stackoverflow_chat_id = Net::HTTP.get_response(URI.parse("http://chat.stackoverflow.com/accounts/#{stack_exchange_account_id}"))["location"].scan(/\/users\/(\d*)\//)[0][0]

    self.meta_stackexchange_chat_id = Net::HTTP.get_response(URI.parse("http://chat.meta.stackexchange.com/accounts/#{stack_exchange_account_id}"))["location"].scan(/\/users\/(\d*)\//)[0][0]
  end
end
