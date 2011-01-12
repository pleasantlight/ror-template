# == Schema Information
# Schema version: 20101008034725
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  failed_attempts      :integer         default(0)
#  unlock_token         :string(255)
#  locked_at            :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

# Models an authenticatable and authorizable user.
class User < ActiveRecord::Base
  
  has_and_belongs_to_many :roles, :uniq => true
  
  # Sort users by email by default.
  default_scope :order => 'email ASC'
  
  # Include default devise modules. Others available are:
  # :token_authenticatable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, 
         :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :confirmed_at, :locked_at
  
  # Returns true if this user has the specified role, false otherwise.
  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
  # Skip confirmation emails when admins create users.
  def save_without_confirmation!
    self.skip_confirmation!
    save()
  end
  
  # Allow admin user management checkbox to set the locked_at time.
  def locked_at=(_locked)
    if _locked.to_i > 0
      self[:locked_at] = Time.now
    else
      self[:locked_at] = nil
    end
  end 
  
  # Make sure all users have at least the :user role.
  def role_ids_with_add_user_role=(_role_ids)
    _role_ids ||= []
    _role_ids << Role.by_name(:user).id
    self[:role_ids] = _role_ids
    self.role_ids_without_add_user_role = _role_ids
  end 
  alias_method_chain :role_ids=, :add_user_role  
   
   # Exclude password info from xml output.
   def to_xml(options={})
     options[:except] ||= [:encrypted_password, :password_salt]
     super(options)
   end
   
   # Exclude password info from json output.
   def to_json(options={})
     options[:except] ||= [:encrypted_password, :password_salt]
     super(options)
   end
  
end
