class NametagsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # POST /nametags
  def create
    if request.xhr?
      @task = Task.find(params[:task])
      @member = Member.find(params[:member])
      @tag = Nametag.new
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.member = @member
      @tag.save

      render :update do |page|
        @tasks = Task.tasks_by_status(@task.story,@task.status)
        page.replace_html "#{@task.status}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks  } 
        
        @task.story.project.teams.each do |team|
          if(team.members.include?(@member))
            @member_team = team
          end
        end
        
        page.replace_html "menu_nametags", :partial => "taskboard/menu_nametags", :locals => { :team => @member_team }
      end
    end
  end

  # PUT /nametags/1
  def update
    if request.xhr?
      @task = Task.find(params[:task])
      @tag = Nametag.find(params[:tagid])
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.save
      render :update do |page|
        page.replace_html "dummy-for-actions", ""
      end
    end
  end

  # DELETE /nametags/1?nametag=id
  def destroy
    @tag = Nametag.find(params[:nametag])
    @html_id = 'nametag-' + @tag.id.to_s
    if @tag.destroy
      render :inline => "<script>Effect.Fade($('#{@html_id}'), {duration: 0.3});</script>", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end
  
  
  # # These functions are used by the taskboard. TODO: See how to avoid them to use the resources
  # def destroy_nametag
  #   @tag = Nametag.find(params[:nametag])
  #   id = @tag.task.id
  #   old_status = @tag.task.status
  #   story = @tag.task.story
  #   story_id = @tag.task.story_id
  #   @tag.destroy
  #   
  #   render :update do |page|
  #     @tasks = Task.tasks_by_status(story,old_status)
  #     page.replace_html "#{old_status}-#{story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks } 
  #   end
  # end
  
end
