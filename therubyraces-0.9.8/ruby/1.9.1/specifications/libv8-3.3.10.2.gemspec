# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{libv8}
  s.version = "3.3.10.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Logan Lowell}, %q{Charles Lowell}]
  s.date = %q{2011-05-30}
  s.description = %q{Distributes the V8 JavaScript engine in binary and source forms in order to support fast builds of The Ruby Racer}
  s.email = [%q{fractaloop@thefrontside.net}, %q{cowboyd@thefrontside.net}]
  s.extensions = [%q{ext/libv8/extconf.rb}]
  s.files = [%q{ext/libv8/extconf.rb}]
  s.homepage = %q{http://github.com/fractaloop/libv8}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{libv8}
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Distribution of the V8 JavaScript engine}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
    else
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<bundler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<bundler>, [">= 0"])
  end
end
