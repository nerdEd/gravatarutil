# ripped off of the 'cheat' gem who evidently ripped this off of jamis buck's lovely net::sftp rakefile

require 'rubygems'
require 'rake'

PACKAGE_NAME    = "gravatarutil"
PACKAGE_VERSION = "0.0.1"

SOURCE_FILES = FileList.new do |fl|
  [ "bin", "lib", "test" ].each do |dir|
    fl.include "#{dir}/**/*"
  end
  fl.include "Rakefile"
end

PACKAGE_FILES = FileList.new do |fl|
  fl.include "README.txt"
  fl.include "Manifest.txt"
  fl.include "History.txt"
  fl.include SOURCE_FILES
end

Gem.manage_gems

desc "Default task"
task :default => [ :package ]

desc "Clean generated files"
task :clean do
  rm_rf "pkg"
end

package_name = "#{PACKAGE_NAME}-#{PACKAGE_VERSION}"
package_dir = "pkg"
package_dir_path = "#{package_dir}/#{package_name}"

gem_file = "#{package_name}.gem"

task :gem  => "#{package_dir}/#{gem_file}"

desc "Build all packages"
task :package => [ :gem ]

directory package_dir

file package_dir_path do
  mkdir_p package_dir_path rescue nil
  PACKAGE_FILES.each do |fn|
    f = File.join( package_dir_path, fn )
    if File.directory?( fn )
      mkdir_p f unless File.exist?( f )
    else
      dir = File.dirname( f )
      mkdir_p dir unless File.exist?( dir )
      rm_f f
      safe_ln fn, f
    end
  end
end

file "#{package_dir}/#{gem_file}" => SOURCE_FILES + [ package_dir ] do
  spec = Gem::Specification.new do |s|
  	s.name = PACKAGE_NAME
  	s.version = PACKAGE_VERSION
  	s.platform = Gem::Platform::RUBY
  	s.date = Time.now
  	s.summary = "Gravatarutil is a simple gravatar command line utility."
    s.description = "Gravatarutil is a simple gravatar command line utility."
  	s.require_paths = [ 'lib' ]
    s.bindir = 'bin'
    s.executables << 'gravatarutil'
  	s.files = %w[README.txt]
  	[ 'lib/**/*', 'test/*' ].each do |dir|
  	  s.files += Dir.glob( dir ).delete_if { |item| item =~ /^\./ }
  	end
  	s.author = "Ed Schmalzle"
  	s.email = 'Jonas714@gmail.com'
  	s.homepage = 'http://www.nerdEd.net'
  end
  Gem::Builder.new(spec).build
  mv gem_file, "#{package_dir}/#{gem_file}"
end

task :install => :package do
  `sudo gem install #{package_dir_path}.gem`
end

task :uninstall do
  `sudo gem uninstall #{PACKAGE_NAME} -v #{PACKAGE_VERSION}`
end
