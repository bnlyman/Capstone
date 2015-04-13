class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  
  def show
  end

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = "Thank you for your question!  It will be reviewed by a moderator before being posted."
      redirect_to @question
    else
      flash[:danger] = "Error, please try again."
      render :new
    end
  end

  def edit
    if current_user != @question.user
      flash[:danger] = "You are not authorized to edit this question."
      redirect_to request.referrer
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = "Question updated successfully."
      redirect_to @question
    else
      flash[:danger] = "Question was not updated."
      render :edit
    end
  end

  def destroy
    if current_user = @question.user
      @question.destroy
      flash[:success] = "The question titled '#{@question.title}' has been destroyed"
      redirect_to request.referrer
    else
      flash[:danger] = "You are not authorized to delete this question."
      redirect_to @question
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :content, :category, :user_id, :posted)
    end

    def set_question
      @question = Question.find(params[:id])
    end
end