class Address 
	
	# Model to temperarily hold venue address info
	# this may need to have a table built for it
	attr_accessor(:id, :address1, :address2, :zip)

	def initialize(event_id)
		@id = event_id
	end

end