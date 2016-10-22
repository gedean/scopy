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

		def valid? scope
			valid_month?(month(scope)) and valid_year?(year(scope))
		end

		def year scope
			scope[0..3].to_i			
		end

		def short_year scope
			scope[2..3]
		end

		def month scope
			scope[-2, 2].to_i
		end

		def date_to_scope date
			Scope.new(build_scope_string date.year, date.month)
		end		
		
		def scope_to_date scope
			Date.new(year(scope), month(scope))
		end

	private
		def valid_month? month_in_number
			month_in_number.between? 1, 12
		end

		def valid_year? year_in_number
			year_in_number.between? 1900, 3000
		end		
	end

	module IntanceMethods
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
	end

	def self.included receiver
		receiver.extend ClassMethods
		receiver.send :include, IntanceMethods
	end
end