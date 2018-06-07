class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  belongs_to :person

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: Devise::email_regexp

  validates :password, length: { minimum: 8 }, unless: -> (u) { u.password.nil? }
  validates :password, presence: true, confirmation: true, if: -> (u) { u.id.nil? }

  devise :database_authenticatable, :registerable, :rememberable, :trackable

  before_save do |entry|
    entry.person = Person.where(email: entry.email).take
    if entry.person.nil?
      remove_role(entry, :user)
    else
      add_role(entry, :user)
    end
  end

  def self.all_roles
    %w[ admin pilot user dba mgr ]
  end

  def self.all_roles_syms
    [ :admin, :pilot, :user, :dba, :mgr ]
  end

  def role?(role)
    not self.roles.index(role.to_s).nil?
  end

  def name
    self.username
  end

  private

    def add_role(entry, the_role)
      entry.roles = entry.roles << the_role.to_s unless entry.role?(the_role)
      # required when an array is changed:
      entry.roles_will_change!
    end

    def remove_role(entry, the_role)
      entry.roles.delete(the_role.to_s)
      # required when an array is changed:
      entry.roles_will_change!
    end

end
