class RestaurantPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.admin?
        scope.all # scope contains the argument from the policy_scope, i.e. Restaurant in this case
        # the above is the same as scope.all => Restaurant.all
      else
        scope.where(user: user)
      end
    end
  end

  # # Already defined in the ApplicationPolicy
  # def new?
  #   create?
  # end

  def create?
    true # Anyone can create
  end
  
  def show?
    true # Anyone can show
  end

  # # Already defined in the ApplicationPolicy
  # def edit?
  #   update?
  # end

  def update?
    user_is_owner? || user_is_admin?
  end

  def destroy?
    user_is_owner? || user_is_admin?
  end

  private

  def user_is_owner?
    # In Pundit:
    # current_user => user
    # @restaurant => record (whatever is on the right side of `authorize` in the controller goes into `record`)
    # current_user == @restaurant.user becomes
    user == record.user # record is the Restaurant instance that we are checking permissions for
  end

  def user_is_admin?
    user.admin?
  end
end
