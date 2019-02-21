class ImportJob < ApplicationJob
  queue_as :default

  def perform(import)
    import.do_import
  end
end
