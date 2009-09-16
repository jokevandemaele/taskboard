class NametagsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # POST /nametags
  def create
    @project = Project.find(params[:project_id])
    @nametag = Nametag.new(params[:nametag])
    if @project.stories.include?(@nametag.task.story) && @nametag.save
      render :update do |page|
        @members = @nametag.task.story.project.members
        @member_team = @nametag.task.story.project.team_including(@member)        
        @tasks = Task.tasks_by_status(@nametag.task.story, @nametag.task.status)
        page.replace_html "#{@nametag.task.status}-#{@nametag.task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks  } 
        page.replace_html "menu_nametags", :partial => "taskboard/menu_nametags", :locals => { :team => @member_team }
      end
    else
      render :inline => "", :status => :bad_request
    end
  end

  # PUT /nametags/1
  def update
    @project = Project.find(params[:project_id])
    @nametag = Nametag.find(params[:nametag_id])
    @nametag.update_attributes(params[:nametag])
    if @project.stories.include?(@nametag.task.story) && @nametag.save
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end

  # DELETE /nametags/1?nametag=id
  def destroy
    @tag = Nametag.find(params[:nametag_id])
    @html_id = 'nametag-' + @tag.id.to_s
    @tag.destroy
    render :inline => "<script>Effect.Fade($('#{@html_id}'), {duration: 0.3});</script>", :status => :ok
  end
end
