require 'date'

module ScopeMethods
	include Comparable
	
	module ClassMethods 

		def make_scope ayear, amonth
			scope_string = Scope.build_scope_string ayear, amonth
			Scope.new scope_string
		end

		def build_scope_string ayear, amonth
			amonth = amonth.to_i
			ayear  = ayear.to_i
			raise "Invalid Scope string #{ayear} #{amonth}" unless valid_month?(amonth) and valid_year?(ayear)
			amonth < 10 ? "#{ayear}0#{amonth.to_i}" : "#{ayear}#{amonth.to_i}"
		end

		def valid? scope_value
			scope_value = scope_value.to_s
			valid_month?(month(scope_value)) and valid_year?(year(scope_value))
		end

		def year scope_value
			scope_value.to_s[0..3].to_i			
		end

		def month scope_value
			scope_value.to_s[-2, 2].to_i
		end

		def date_to_scope date
			Scope.new(build_scope_string date.year, date.month)
		end		
		
		def scope_to_date scope
			Date.new(year(scope), month(scope))
		end

		def valid_month? month_in_number
			month_in_number.between? 1, 12
		end

		def valid_year? year_in_number
			year_in_number.between? 2000, 3000
		end		
	end

	module IntanceMethods
		MIN_ACCEPTED_YEAR = 2000

		def valid?
			Scope.valid? @value
		end

		def to_s
			@value
		end

		def year
			Scope.year @value
		end

		def month
			Scope.month @value
		end

		def month_to_s
			month < 10 ? "0#{month.to_i}" : "#{month.to_i}"
		end

		def prior
			date = Scope.scope_to_date(@value).prev_month
			Scope.date_to_scope date
		end

		def next
			date = Scope.scope_to_date(@value).next_month
			Scope.date_to_scope date
		end

		def to_i
			@value.to_i
		end

		def to_date
			Scope.scope_to_date @value
		end

		def <=>(other)
			to_date <=> other.to_date
		end
    
		def span(end_scope)
			(end_scope = Scope.new(end_scope)) unless end_scope.is_a?(Scope)

			raise "Current Scope (#{to_s}) bigger or equal to end scope (#{end_scope.to_s})" if (self >= end_scope)

			scope_span = []
			current_scope = Scope.new(to_s)

			while current_scope <= end_scope
				scope_span << current_scope
					current_scope = current_scope.next
			end
			scope_span
    end

    private

		def get_short_value
			raise "year (#{year}) shorten than #{MIN_ACCEPTED_YEAR}" if  year < MIN_ACCEPTED_YEAR
			"#{year - 2000}#{month_to_s}"
		end		
	end

	def self.included receiver
		receiver.extend ClassMethods
		receiver.send :include, IntanceMethods
	end
end