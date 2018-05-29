class BaseTask
  class << self
    def perform!
      new.perform!
    end
  end
end
