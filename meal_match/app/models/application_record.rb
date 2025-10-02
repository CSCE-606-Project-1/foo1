# Base class for all models in the application. Pulls in project-wide
# concerns such as formatting helpers so they are available on all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include Formatable
end
