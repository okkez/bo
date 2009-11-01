begin
  require 'vlad'
  # do not define vlad:start
  Vlad.load :app => :thin, :web => nil
rescue LoadError
  # do nothing
end
