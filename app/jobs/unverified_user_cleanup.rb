class UnverifiedUserCleanup < ApplicationJob
  queue_as :default

  def perform(*args)
    unless args[0].verified
      args[0].destroy
    end
  end
end
