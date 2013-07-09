# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{union}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Daniel J. Berger}]
  s.date = %q{2011-09-23}
  s.description = %q{    The union library provides an analog to a C/C++ union for Ruby.
    In this implementation a union is a kind of struct where multiple
    members may be defined, but only one member ever contains a non-nil
    value at any given time.
}
  s.email = %q{djberg96@gmail.com}
  s.extra_rdoc_files = [%q{README}, %q{CHANGES}, %q{MANIFEST}]
  s.files = [%q{README}, %q{CHANGES}, %q{MANIFEST}]
  s.homepage = %q{http://www.rubyforge.org/projects/shards}
  s.licenses = [%q{Artistic 2.0}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{A struct-like C union for Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
