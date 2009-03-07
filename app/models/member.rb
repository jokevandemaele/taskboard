class Member < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :nametags

  def formatted_nametag
	@names = name.split()
  	return @names[0].upcase
  end
end
