class Address 

	attr_accessor(:id, :address1, :address2, :zip)

	def initialize(event_id)
		@id = event_id
	end

end