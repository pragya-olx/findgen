class MappingsController < ApplicationController
	def index
		@mappings = SpocToApproverMapping.all
	end
end
