class Nametag < ActiveRecord::Base
  belongs_to :task
  belongs_to :member
end
