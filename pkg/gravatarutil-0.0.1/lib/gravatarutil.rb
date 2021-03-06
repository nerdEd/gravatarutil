#!/usr/bin/env ruby 

# == Synopsis 
#   Command line utility for gravatar
#
# == Examples
#   gravatarutil Jack@hotmail.com
#   gravatarutil Jack@hotmail.com -f ~/Users/Jack/Desktop/gravatar_image.jpg
#
# == Usage 
#   gravatarutil [options]
#
#   For help use: gravatarutil -h
#
# == Options
#   -f, --file          Pass in a file to save the gravatar as
#   -h, --help          Displays help message
#   -v, --version       Display the version, then exit
#
# == Author
#   Ed Schmalzle
#
# == Copyright
#   Copyright (c) 2007 Ed Schmalzle. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php

require 'optparse' 
require 'rdoc/usage'
require 'ostruct'
require 'date'
require 'gravatar.rb'

class Gravatarutil
  VERSION = '0.0.1'  
  
  attr_reader :options

  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin
    
    # Set defaults
    @options = OpenStruct.new
    @file = 'gravatar.jpg'
    @email = ''
    @set_icon = false
  end

  # Parse options, check arguments, then process the command
  def run
    if parsed_options? && arguments_valid? 
      process_arguments            
      process_command
    else
      output_options
    end
  end
  
  protected
  
    def parsed_options?
      
      opts = OptionParser.new 
      
      opts.on( '-v', '--version' ) do 
        output_version
        exit 0
      end
      
      opts.on( '-h', '--help' ) do 
        output_help
      end
      
      opts.on( '-f', '--file file_name', String, "File name to save the gravatar as." ) do | f |
        @file = f
      end
      
      opts.on( '-i', '--icon' ) do | i |
        @set_icon = i
      end
      
      opts.parse!(@arguments) rescue return false
      
      process_options
      true      
    end

    # Performs post-parse processing on options
    def process_options
      
    end
    
    def output_options
      puts "Options:\n"
      
      @options.marshal_dump.each do |name, val|        
        puts "  #{name} = #{val}"
      end
    end

    def arguments_valid?
      if @arguments.length < 1 then
        puts "Required arguments have not been supplied."
        return false
      else
        return true
      end
    end
    
    def process_arguments
      @email = @arguments[0]
    end
    
    def output_help
      output_version
      RDoc::usage() 
    end
    
    def output_usage
      RDoc::usage('usage') 
    end
    
    def output_version
      puts "#{File.basename(__FILE__)} version #{VERSION}"
    end
    
    def process_command
      gravatar = Gravatar.new( @email )
      gravatar.save( @file )
      if( @set_icon ) then
        if( RUBY_PLATFORM.include? "darwin" ) then
          #system "osascript -e set the picture path of current user to alias quoted form of" + " #{@file}"
          puts "gravatarutil cannot yet do this, sorry."
        else
          puts "gravatarutil cannot set the user icon on non darwin operating systems."
        end
      end
    end

    def process_standard_input
      input = @stdin.read      
    end
end