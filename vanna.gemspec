Gem::Specification.new do |s|
  s.name      = "vanna"
  s.version   = 0.1.0
  s.authors   = ["Michael Sofaer"]
  s.email     = "msofaer@pivotallabs.com"
  s.homepage  = "http://github.com/MikeSofaer/vanna"
  s.summary   = "Vanna is an example of using a Presenter pattern in Rails"
  s.description  = <<-EOS.strip
Vann is a way to implement your Rails apps using the Presenter pattern.  The implicit render
now relies on you returning a data dictionary from your controllers.  It also allows you to
explicitly override the params hash so you can construct dictionaries from other controller calls.
  EOS

  s.files      = Dir['lib/*']
  s.test_files = Dir['test/**/*.rb']

  s.has_rdoc = false

  s.add_dependency "json"
  s.add_dependency 'rails', '>=3.0.0'
  s.add_development_dependency 'rack-test', '>= 0.5.6'
  s.add_development_dependency 'wrong', ">=0.5.0"

end

