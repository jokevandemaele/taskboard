class StatustagsController < ApplicationController
  before_filter :require_user
  before_filter :require_belong_to_project_or_admin
  before_filter :find_story
  before_filter :find_task
  before_filter :find_tag, :except => [:create]
  
  def show
    render @tag
  end
  
  def create
    @tag = @task.statustags.create(params[:statustag])
    if @tag.save
      render @tag, :status => :created
    else
      render :inline => '', :status => :precondition_failed
    end
  end

  def update
    @tag.task = Task.find(params[:statustag][:task_id])
    if @tag.save && @tag.update_attributes(params[:statustag])
      render :inline => '', :status => :ok
    else
      render :inline => '', :status => :precondition_failed
    end
  end

  def destroy
    @tag.destroy
    render :inline => "", :status => :ok
  end
  
  def find_tag
    @tag = @task.statustags.find(params[:id])
  end
end
