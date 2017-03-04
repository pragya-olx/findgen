class AssessmentsController < ApplicationController

  def index
    @assessments = Assessment.all
  end

  def create
      puts params.inspect
      render plain: params[:code].inspect
      existing_assessment =  Assessment.find_by_code(params[:code])
      if existing_assessment.present?
        redirect_to "/assessments/", :flash => {:notice => "assessment already exists with this code"}
        return
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
    @assessment = Assessment.find(params[:id])
    @assessment.update!(assessment_params)
    redirect_to '/assessments'
  end

  def assessment_params
    params.require(:assessment).permit(:code)
  end
end
