begin
  require 'vlad'
  # do not define vlad:start
  Vlad.load :app => :thin, :web => nil, :scm => :git
rescue LoadError
  # do nothing
end

Rake.application.instance_variable_get("@tasks").delete("vlad:start_app")
Rake.application.instance_variable_get("@tasks").delete("vlad:stop_app")

namespace :vlad do

  task :deploy => [:stop_app, :update, :start_app]

  task :update do
    files = ["database.yml", "smtp.yml"]
    commands = files.map{|file|
      "ln -s #{File.join(shared_path, file)} #{File.join(release_path, 'config', file)}"
    }
    run commands.join(' && ')
  end

  remote_task :start_app, :roles => :app do
    sudo "#{thin_command} -C #{thin_conf} restart"
  end

  remote_task :stop_app, :roles => :app do
    sudo "#{thin_command} -C #{thin_conf} stop"
  end
end
