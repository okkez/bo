begin
  require 'vlad'
  # do not define vlad:start
  Vlad.load :app => :thin, :web => nil, :scm => :git
rescue LoadError
  # do nothing
end

namespace :vlad do
  task :update do
    files = ["database.yml", "smtp.yml"]
    commands = files.map{|file|
      "ln -s #{File.join(shared_path, file)} #{File.join(release_path, 'config', file)}"
    }
    run commands.join(' && ')
  end
end
