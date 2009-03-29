require 'digest/sha1'

class Member < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :roles
  has_many :nametags, :dependent => :destroy

  #Validations
  validates_uniqueness_of :username
  validates_length_of :username, :within => 3..40
  #validates_length_of :password, :within => 0..40
  validates_presence_of :name, :username
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"

  attr_accessor :password, :password_confirmation
  
  # password: this method encrypts the plain text password to store it in the database
  def password=(pass)
    @password=pass
    self.hashed_password = Member.encrypt(@password)
  end

  # authenticate: this method is used when a visitor tryies to login
  def self.authenticate(username, password)
    member = Member.first :conditions => "username = '#{username}'"
    return nil if member.nil?
    return member if Member.encrypt(password)==member.hashed_password
  end

  # formated_nametags: this method is used to return the correct name of a member to display in it's nametag
  def formatted_nametag
	  @names = name.split()
  	return @names[0].upcase
  end
  
  def add_picture(picture_file)
    image_types = ["image/jpeg", "image/pjpeg", "image/gif", "image/png", "image/x-png"]
    if (!picture_file.blank? || !(picture_file.size == 0))
      if image_types.include?picture_file.content_type.chomp
        if picture_file.size < 2097152
          picture_file.rewind
          pic = Magick::Image.from_blob(picture_file.read)[0]

          # 88x88 is the default picture size
          image = pic.scale(88, 88)
          
          File.open(RAILS_ROOT + "/public/images/members/" + self.id.to_s + ".png", "wb") do |f|
            f.write(image.to_blob)
          end
          return "ok"
        else
          return "Image file too big"
        end
      else
        return "Unsupported image format"
      end
    else
      return "Unable to upload the file you selected, please try again."
    end
  end
  def show_picture()
    file_name = "members/" + self.id.to_s + ".png"
    default_file_name = "default_av.png"
    if File.exists?(RAILS_ROOT + "/public/images/" + file_name)
      return file_name
    else
      return default_file_name
    end
  end
protected

  # Auxiliary Functions
  def self.encrypt(pass)
    Digest::SHA1.hexdigest(pass)
  end
end
