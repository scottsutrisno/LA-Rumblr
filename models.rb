class User < ActiveRecord::Base
    has_one :profile
end

class Profile < ActiveRecord::Base
    belongs_to :user
end