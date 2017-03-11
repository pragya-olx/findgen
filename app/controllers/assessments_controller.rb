class AssessmentsController < ApplicationController

  def index
    @assessments = Assessment.all
  end

  def create
      @assessment =  Assessment.find_by_code(params[:assessment][:code])
      if @assessment.present?
        render json: {}, status: 500 
        redirect_to '/assessments',  :flash => {:notice => "Assessment exists already"}
      end
      @assessment = Assessment.create(assessment_params)
      render json: {}, status: 201 
  end

  def show
    if params[:id] != 'unknown'
      @assessment = Assessment.find(params[:id])
    else
      @assessment = Assessment.find_by_code(params[:code])
    end
  end

  def destroy
    @assessment = Assessment.find(params[:id]) 
    @assessment.destroy
    redirect_to '/assessments',  :flash => {:notice => "Assessment deleted successfully"}
  end

  def update
    @assessment = Assessment.find_by_code(params[:code])
    @assessment2 = Assessment.find(params[:id]) 
    if @assessment.present?
      redirect_to '/assessments',  :flash => {:notice => "Assessment exists already"}
    else
      @assessment2.update!(assessment_params)
      redirect_to '/assessments'
    end
  end

  def assessment_params
    params.require(:assessment).permit(:code)
  end
end
