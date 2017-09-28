class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
<<<<<<< HEAD

=======
  include SessionsHelper
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b
end
