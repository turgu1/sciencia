class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
      can :manage_hidden, :all
      cannot :destroy, User, id: user.id  # Insure that an admin user cannot delete himself!
    else
      if user.role?(:pilot) || user.role?(:dba)
        can :manage, :all
        can :manage_hidden, :all
        cannot :manage, User
      else
        can :read, :all
        if user.role? :user
          can :manage, [Document, Author, Event] do |document|
            document.is_author?(user)
          end
          can :create, [Issue, Comment]
          can [:update, :destroy], Comment do |comment|
            user.id == comment.user_id
          end
          can :create, Organisation
          can :manage, Person do |person|
            user.id == person.user_id
          end
        end
        if user.role? :mgr
          can :manage, [Organisation, Person]
        end
        cannot :manage_hidden, :all
      end
      can :update, User do |u| user.id == u.id end
    end
  end
end
