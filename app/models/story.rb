class Story < ActiveRecord::Base
  belongs_to :project
  has_many :tasks, :dependent => :destroy

  validates_uniqueness_of :realid

  def self.last_realid(project_id)
	story = Story.first(:conditions => "project_id = #{project_id} AND realid != ''", :order => "realid DESC")
	if story
		return story.realid
	else 
	project = Project.find(project_id)
	number = '001'
	text = Story.get_initials_of(project.name,2)
	end
  end

  def self.get_initials_of(string,limit = 0)
	if string.empty?
		return ""
	end
	initials = String.new
	words = string.split

	if words.size == 1
		if words[0].length > 2
			initials << words[0][0] << words[0][1]
		else
			initials << words[0][0]
		end	
	else
		words.each do |word|		
			initials << word[0]
		end
	end
	if limit > 0
		return initials.upcase[0..limit-1]
	else
		return initials.upcase
	end
  end

end
