require "multi_level_logger/version"
include Logger::Severity

module MultiLevelLogger
	class MLogger
		def self.create(opts)
			Logger.class_eval do
				define_method "add" do |severity, message = nil, progname = nil, &block|
				severity ||= UNKNOWN
				progname ||= @progname
				if message.nil?
					if block_given?
						message = yield
					else
						message = progname
						progname = @progname
					end
				end

				@shift_age = opts[:shift_age] || 0
				@shift_size = opts[:shift_size] || 1048576

				unless File.directory?("log") 
					Dir.mkdir("log")
				end

				@logdev_warn ||=  Logger::LogDevice.new(opts[:warn] || "log/warn.log", :shift_age => @shift_age, :shift_size => @shift_size)        if (opts[:all] || opts[:warn])
				@logdev_info ||= Logger::LogDevice.new(opts[:info] || "log/info.log", :shift_age => @shift_age, :shift_size => @shift_size)	    if (opts[:all] || opts[:info])
				@logdev_debug ||= Logger::LogDevice.new(opts[:debug] || "log/debug.log", :shift_age => @shift_age, :shift_size => @shift_size)       if (opts[:all] || opts[:debug])
				@logdev_error ||= Logger::LogDevice.new(opts[:error] || "log/error.log", :shift_age => @shift_age, :shift_size => @shift_size)	    if (opts[:all] || opts[:error])
				@logdev_fatal ||= Logger::LogDevice.new(opts[:fatal] || "log/fatal.log", :shift_age => @shift_age, :shift_size => @shift_size)	    if (opts[:all] || opts[:fatal])
				@logdev_unknown ||= Logger::LogDevice.new(opts[:unknown] || "log/unknown.log", :shift_age => @shift_age, :shift_size => @shift_size) if (opts[:all] || opts[:unknow])

				if @logdev_warn && severity == WARN
					@logdev_warn.write(
						format_message(format_severity(WARN), Time.now, progname, message))
				end
				if @logdev_info && severity == INFO
					@logdev_info.write(
						format_message(format_severity(INFO), Time.now, progname, message))
				end
				if @logdev_debug && severity == DEBUG
					@logdev_debug.write(
						format_message(format_severity(DEBUG), Time.now, progname, message))
				end
				if @logdev_error && severity == ERROR
					@logdev_error.write(
						format_message(format_severity(ERROR), Time.now, progname, message))
				end
				if @logdev_fatal && severity == FATAL
					@logdev_fatal.write(
						format_message(format_severity(FATAL), Time.now, progname, message))
				end
				if @logdev_unknown && severity == UNKNOWN
					@logdev_unknown.write(
						format_message(format_severity(UNKNOWN), Time.now, progname, message))
				end

				if @logdev.nil? or severity < @level or !opts[:default_logger]
					return true
				end
				@logdev.write(
					format_message(format_severity(severity), Time.now, progname, message))
					true
				end
			end	

			Logger.new "log/development.log"
		end
	end
end
