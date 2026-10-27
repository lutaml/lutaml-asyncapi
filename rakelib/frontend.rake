# frozen_string_literal: true

namespace :frontend do
  task :install do
    unless File.directory?("node_modules")
      Dir.chdir("frontend") do
        sh "npm install"
      end
    end
  end

  task build: :install do
    Dir.chdir("frontend") { sh "npm run build" }
  end
end
