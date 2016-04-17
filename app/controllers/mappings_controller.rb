class MappingsController < ApplicationController
	def index
		@client_id = params[:client_id]
		@spocs = User.where(:client_id => @client_id, :role_type => "spoc").collect {|p| [p.name, p.id]}
		@mappings = SpocToApproverMapping.all
		@approvers = User.where(:client_id => params[:client_id], :role_type => "approver").collect {|p| [p.name, p.id]}
	end

	def create
		map = SpocToApproverMapping.find_by_spoc_id(params[:user][:id])
		if map.nil?
			map = SpocToApproverMapping.create(:spoc_id => params[:user][:id],
				:approver1_id => params[:approver1][:id],
				:approver2_id => params[:approver2][:id])
		else
			map.approver1_id = params[:approver1][:id]
			map.approver2_id = params[:approver2][:id]
			map.save
		end
		redirect_to "/mappings?client_id=#{params[:current_client_id].first.first}"
	end
end
