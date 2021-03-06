require 'rspec'
require 'serverspec'
require 'docker'
require_relative '../../drone-tests/shared/jemonkeypatch.rb'

#Include Tests
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))
Dir[base_spec_dir.join('../../drone-tests/shared/**/*.rb')].sort.each { |f| require_relative f }

if not ENV['IMAGE'] then
  puts "You must provide an IMAGE env variable"
end

LISTEN_PORT=8080

set :backend, :docker
@image = Docker::Image.get(ENV['IMAGE'])
set :docker_image, @image.id
#set :docker_debug, true
set :docker_container_start_timeout, 60
set :docker_container_ready_regex, /READY/

set :docker_container_create_options, {
  'Image'      => @image.id,
  'User'       => '100000',
}
 
RSpec.configure do |c|
  describe "tests" do
    include_examples 'docker-ubuntu-16'
    include_examples 'docker-ubuntu-16-apache-2.4'
    include_examples 'php-5.6-tests'
    include_examples 'drupal7'
  end
end
