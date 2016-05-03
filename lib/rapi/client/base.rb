module Rapi
	class Base
		def self.attr(*args)
			args.each do |field|
				getter(field)
				setter(field)
			end
		end

		def self.getter(*args)
			args.each do |field|
				define_method(field) do
					instance_variable_get("@#{field}")
				end
			end
		end

		def self.setter(*args)
			args.each do |field|
				define_method("#{field}=") do |value|
					instance_variable_set("@#{field}", value)
					self
				end
			end
		end
	end
end
