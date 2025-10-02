namespace :docs do
  desc "Generate YARD documentation into doc/yard"
  task :yard do
    # Suppress Ruby warnings (reduces noisy parser warnings from non-Ruby files)
    ENV["RUBYOPT"] = "-W0"
    require "yard"

    YARD::Rake::YardocTask.new do |t|
      t.options = [
        "--output-dir", "doc/yard",
        "--markup", "markdown",
        # Keep a minimal exclude list — files included below are explicit
        "--exclude", "config/**/*.yml",
        "--exclude", "config/master.key",
        "--exclude", "config/credentials/**/*",
        "--exclude", "app/views/**/*",
        "--exclude", "app/javascript/**/*",
        "--exclude", "app/assets/**/*",
  "--exclude", "public/**/*"
      ]
      # Explicitly include only the Ruby directories we care about to avoid
      # YARD attempting to parse templates, YAML, JS or other non-Ruby files.
      # Explicit manifest-style file selection — avoid scanning non-Ruby
      # files and templates which cause YARD parser warnings.
      t.files = []
      t.files += Dir["app/models/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["app/controllers/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["app/services/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["app/mailers/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["app/jobs/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["lib/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["config/initializers/**/*.rb"].select { |f| f.end_with?(".rb") }
      t.files += Dir["spec/**/*.rb"].select { |f| f.end_with?(".rb") }
    end

    Rake::Task["yard"].invoke
  end
end
