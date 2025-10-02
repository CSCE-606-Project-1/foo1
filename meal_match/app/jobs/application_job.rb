## Base class for background jobs in the application.
class ApplicationJob < ActiveJob::Base
  # Base class for background jobs in the application. Configure global
  # retry/discard behaviors here.
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
