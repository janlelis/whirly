# # #
# Get gemspec info

gemspec_file = Dir['*.gemspec'].first
gemspec = eval File.read(gemspec_file), binding, gemspec_file
info = "#{gemspec.name} | #{gemspec.version} | " \
       "#{gemspec.runtime_dependencies.size} dependencies | " \
       "#{gemspec.files.size} files"


# # #
# Gem build and install task

desc info
task :gem do
  puts info + "\n\n"
  print "  "; sh "gem build #{gemspec_file}"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
  puts; sh %{gem install --no-document pkg/#{gemspec.name}-#{gemspec.version}.gem}
end


# # #
# Start an IRB session with the gem loaded

desc "#{gemspec.name} | IRB"
task :irb do
  sh "irb -I ./lib -r #{gemspec.name.gsub '-','/'}"
end


# # #
# Run Specs

desc "#{gemspec.name} | Spec"
task :spec do
  sh "for file in spec/*.rb; do ruby $file; done"
end
task default: :spec


# # #
# Update spinners

desc "Update spinners"
task :update_spinners do
  sh "git submodule update --recursive --remote"
  cp "data/external/cli-spinners/spinners.json", "data/cli-spinners.json"
end


# # #
# Record ASCIICAST

desc "Record an asciicast via asciinema"
task :record_acsiicast do
  sh "cd && asciinema rec whirly-bundled-spinners-v0.2.0.json --title='Whirly v0.2.0 Bundled Spinners' --command='ruby #{File.dirname(__FILE__)}/examples/asciinema_bundled_spinners.rb'"
end

