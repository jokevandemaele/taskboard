require 'digest/sha1'

class Member < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :teams
  has_many :nametags

  #Validations
  validates_uniqueness_of :username
  validates_length_of :username, :within => 3..40
  validates_length_of :password, :within => 1..40
  validates_presence_of :name, :username, :password
  #validates_confirmation_of :password

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
    logger.error("------------------------ FOUND: #{member.inspect} -----------------------")
    return nil if member.nil?
    return member if Member.encrypt(password)==member.hashed_password
  end

  # formated_nametags: this method is used to return the correct name of a member to display in it's nametag
  def formatted_nametag
	  @names = name.split()
  	return @names[0].upcase
  end

protected

  # Auxiliary Functions
  def self.encrypt(pass)
    Digest::SHA1.hexdigest(pass)
  end
end
