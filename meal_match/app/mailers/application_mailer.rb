## Base mailer class for application mailers.
class ApplicationMailer < ActionMailer::Base
  # Base mailer from which application mailers inherit.
  #
  # @abstract Override default `from` and `layout` in subclasses where appropriate.
  default from: "from@example.com"
  layout "mailer"
end
