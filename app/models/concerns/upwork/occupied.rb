module Upwork
  module Occupied
    extend ActiveSupport::Concern

    class_methods do
      def free
        lost = where('busy = ? and (last_request_at < ? or last_request_at IS NULL)', true, DateTime.now - 2.minutes)
        lost.update_all(busy: false, last_request_at: nil)

        where(busy: false)
      end
    end

    def free!
      update(busy: false, last_request_at: nil)
    end

    def busy!
      update(busy: true)
    end
  end
end
