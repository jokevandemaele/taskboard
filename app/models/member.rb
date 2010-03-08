require 'digest/sha1'
# require 'RMagick'
class Member < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :teams
  has_many :organization_memberships, :dependent => :destroy 
  has_many :organizations, :through => :organization_memberships
  has_many :nametags, :dependent => :destroy
  belongs_to :last_project, :class_name => "Project"
  has_many :guest_team_memberships
  has_many :guest_projects, :through => :guest_team_memberships, :source => :project
  
  #Validations
  validates_uniqueness_of :username, :email
  validates_length_of :username, :within => 3..40
  #validates_length_of :password, :within => 0..40
  validates_presence_of :name, :username, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"

  attr_accessor :password, :password_confirmation, :clear_password, :added_by, :new_organization, :new_picture
  
  before_create :generate_password_if_missing
  after_create :assign_picture, :add_to_organization_and_send_email_notification

  # def assign_picture
  #   self.add_picture(self.new_picture) if self.new_picture
  # end

  def add_to_organization_and_send_email_notification
    self.add_to_organization(self.new_organization)
    # Send email notificating the lucky user
    MemberMailer.deliver_create(self)
  end

  def generate_password_if_missing
    salt = Time.now.to_s
    self.password = Digest::SHA1.hexdigest(salt + self.name + self.username + self.email)[0..7] if self.hashed_password.nil?
  end

  # add user to organization
  def add_to_organization(organization)
    if organization
      
      @membership = OrganizationMembership.new(
        :member_id => self.id,
        :organization_id => organization
      )
      
      @membership.save
    end
  end
  
  # # return all the organizations the user can admin
  # def organizations_administered
  #   return Organization.all if self.admin?
  #   self.organization_memberships.administered.collect {|membership| membership.organization }
  # end

  # #see if the user admins an organization
  # def admins?(organization)
  #   self.organizations_administered.include?(organization)
  # end

  #see if the user admins an organization
  # def admins_any_organization?
  #   !self.organizations_administered.empty?
  # end

  # def projects
  #   projects = []
  #   self.teams.each do |team| 
  #     team.projects.each {|project| projects << project if !projects.include?(project) }
  #   end
  #   projects += self.guest_projects
  #   return projects
  # end
  
  # password: this method encrypts the plain text password to store it in the database
  def password=(pass)
    self.hashed_password = Member.encrypt(pass)
    self.clear_password = pass
  end

  # authenticate: this method is used when a visitor tryies to login
  def self.authenticate(username, password)
    member = Member.first :conditions => ["username = ?", username]
    return nil if member.nil?
    return member if Member.encrypt(password)==member.hashed_password
  end

  # formated_nametags: this method is used to return the correct name of a member to display in it's nametag
  def formatted_nametag(team = nil)
    if(team)
      @team = Team.find(team)
      members = @team.members
    else
      members = Member.all()
    end
    
    names = name.split()
    name = names[0]
    members = members - [self]
    members.each do 
    |member|
    member_nametag = member.name.split()
      name = "#{names[0]} #{names[1][0,1]}" if member_nametag[0] == names[0] && names.length > 1
    end
    return name.upcase()[0..8]
  end
  
  def add_picture(picture_file)
    # if(picture_file)
    #   image_types = ["image/jpeg", "image/pjpeg", "image/gif", "image/png", "image/x-png"]
    #   if (!picture_file.blank? || !(picture_file.size == 0))
    #     if image_types.include?picture_file.content_type.chomp
    #       if picture_file.size < 2097152
    #         picture_file.rewind
    #         pic = Magick::Image.from_blob(picture_file.read)[0]
    # 
    #         # 88x88 is the default picture size
    #         image = pic.scale(88, 88)
    #       
    #         File.open(RAILS_ROOT + "/public/images/members/" + self.id.to_s + ".png", "wb") do |f|
    #           f.write(image.to_blob)
    #         end
    #         return "ok"
    #       else
    #         return "Image file too big"
    #       end
    #     else
    #       return "Unsupported image format"
    #     end
    #   else
    #     return "Unable to upload the file you selected, please try again."
    #   end
    # end
  end
  def show_picture()
    return 'default_file_name'
    # file_name = "members/" + self.id.to_s + ".png"
    # default_file_name = "default_av.png"
    # if File.exists?(RAILS_ROOT + "/public/images/" + file_name)
    #   return file_name
    # else
    #   return default_file_name
    # end
  end
  
  def administrators
    admins = []
    organizations.each {|organization| OrganizationMembership.all(:conditions => ["organization_id = ? AND admin = ?", organization, true]).collect { |memb| admins << memb.member if !admins.include?(memb.member) } } 
    return admins
  end

protected

  # # Auxiliary Functions
  # def self.encrypt(pass)
  #   Digest::SHA1.hexdigest(pass)
  # end
end
