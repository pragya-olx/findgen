class AssessmentsController < ApplicationController

  def index
    @assessments = Assessment.all
  end

  def create
      @assessment = Assessment.create(assessment_params)
      render json: {}, status: 201 
  end

  def show
    if params[:id] != 'unknown'
      @assessment = Assessment.find(params[:id])
    else
      @assessment = Assessment.find_by_code(params[:code])
      if @assessment.nil?
        redirect_to '/assessments'
      end
    end
  end

  def update
    @assessment = Assessment.find(params[:id])
    @assessment.update!(assessment_params)
    redirect_to '/assessments'
  end

  def assessment_params
    params.require(:assessment).permit(:code)
  end
end
