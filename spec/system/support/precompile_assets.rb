# Precompile assets before running tests to avoid timeouts.
# Do not precompile if webpack-dev-server is running (NOTE: MUST be launched with RAILS_ENV=test)
RSpec.configure do |config|
  # Skip assets precompilcation if we exclude system specs.
  next if config.filter.opposite.rules[:type] == "system" || config.exclude_pattern.match?(%r{spec/system})

  config.before(:suite) do
    if Shakapacker.dev_server.running?
      $stdout.puts "\n⚙️  Shakapacker dev server is running! Skip assets compilation.\n"
      next
    else
      $stdout.puts "\n🐢  Precompiling assets.\n"
      original_stdout = $stdout.clone
      # Use test-prof now 'cause it couldn't be monkey-patched (e.g., by Timecop or similar)
      start = Time.current
      begin
        # Silence Shakapacker output
        $stdout.reopen(File.new(File::NULL, "w"))
        # next 3 lines to compile shakapacker before running our test suite
        require "rake"
        Rails.application.load_tasks
        Rake::Task["shakapacker:compile"].execute
      ensure
        $stdout.reopen(original_stdout)
        $stdout.puts "Finished in #{(Time.current - start).round(2)} seconds"
      end
    end
  end
end
