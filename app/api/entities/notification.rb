module API
  module Entities
    class Notification < Grape::Entity
      expose :number_of_send_notifications
    end
  end
end
