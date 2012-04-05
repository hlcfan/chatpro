class Notification::Mention < Notification::Base
  belongs_to :message
end
