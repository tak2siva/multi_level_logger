# MultiLevelLogger

A gem to write diffrent level of Ruby logs in separate files.

There are six log levels in Ruby (i.e) INFO, WARN, DEBUG, ERROR, FATAL, UNKNOWN. Purpose of this gem is to log them in different files.

https://rubygems.org/gems/multi_level_logger

## Installation

Add this line to your application's Gemfile:

    gem 'multi_level_logger'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install multi_level_logger

## Ruby Usage

    include MultiLevelLogger
    
    logger = MLogger.create(:all=>true)     # Will create log/info.log 
                                            #                /warn.log  
                                            #                /error.log
                                            #                /debug.log
                                            #                /fatal.log
                                            #                /unknown.log
                                            
    logger.info "This is info"              # logged in log/info.log
    logger.debug "This is debug"            # logged in log/debug.log
    
    ###  To enable specific log or set diffrent files ###
    
    logger = MLogger.create(
                :error=>"log/new_error.log",
                :info=>"log/info.log")       ## Only error and info are logged in given file
                            
    ### Rails default logger will be disabled by default
    ### To enable 
    
    logger = MLogger.create(:all=>true, :default_logger => true)
                            
## Ruby on Rails Usage

    ## config/environments/production.rb
    
    config.logger = MultiLevelLogger::MLogger.create(:all=>true)

## Contributing

1. Fork it ( http://github.com/tak2siva/multi_level_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
