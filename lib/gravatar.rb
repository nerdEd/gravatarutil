require 'open-uri'
require 'MD5'

class Gravatar
  
  BASE_URL = 'http://www.gravatar.com/avatar/'
  
  attr_reader :url, :image, :email
  
  def initialize( user_email )
    @email = user_email.downcase
    @url = build_url
    @image = fetch_image
  end
  
  def save( file )
    image_file = File.new( file, 'w' )
    image_file << @image
  end
  
  private
  
  def build_url
    digested_email = Digest::MD5.hexdigest( @email )
    return BASE_URL + digested_email + '.jpg'
  end
  
  def fetch_image
    @image = open( @url ).read
  end
  
end