module Describable
  extend ActiveSupport::Concern

  included do
    def name_with_description
      "#{name}#{description.blank? ? "" : " - "}#{description}"
    end
  end
end
