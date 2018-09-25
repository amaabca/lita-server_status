Gem::Specification.new do |spec|
  spec.name          = 'lita-server_status'
  spec.version       = '1.0.0'
  spec.authors       = [
                          'Michael van den Beuken',
                          'Ruben Estevez',
                          'Jordan Babe',
                          'Mathieu Gilbert',
                          'Ryan Jones',
                          'Darko Dosenovic',
                          'Jonathan Weyermann',
                          'Jesse Doyle',
                          'Zoie Carnegie'
                        ]
  spec.email         = [
                          'michael.beuken@gmail.com',
                          'ruben.a.estevez@gmail.com',
                          'jorbabe@gmail.com',
                          'mathieu.gilbert@ama.ab.ca',
                          'ryan.michael.jones@gmail.com',
                          'darko.dosenovic@ama.ab.ca',
                          'Jonathan.Weyermann@ama.ab.ca',
                          'Jesse.Doyle@ama.ab.ca',
                          'zoie.carnegie@gmail.com'
                        ]
  spec.description   = %q{Store and list out the statuses of applications}
  spec.summary       = %q{Store and list out the statuses of applications}
  spec.homepage      = 'https://github.com/amaabca/lita-server_status'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 3.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec-instafail'
  spec.add_development_dependency 'timecop'
end
