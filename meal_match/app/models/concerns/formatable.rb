# frozen_string_literal: true

## Formatting concern that provides a default `to_format` implementation
## for including classes. Models can override `to_format` to provide richer
## HTML/text output for UI rendering or text-only interfaces.
module Formatable
  extend ActiveSupport::Concern

  # Converts the object into textual markup given a specific format.
  #
  # @param format [Symbol] the format type, `:text` or `:html`
  # @return [String] the object converted into the expected format.
  def to_format(format = :html)
    case format.to_sym
    when :text
      to_s
    when :html
      # A simple default HTML representation; models may override for richer
      # output.
      "<span class=\"#{self.class.name.downcase}\">#{ERB::Util.h(to_s)}</span>"
    else
      raise ArgumentError, "unsupported format: "+format.to_s
    end
  end
end
