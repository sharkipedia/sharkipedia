class ImportValidatorJob < ApplicationJob
  queue_as :default

  def perform(import)
    import.do_validate
  end
end
