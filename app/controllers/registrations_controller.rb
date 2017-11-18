class RegistrationsController < Devise::RegistrationsController
  layout "devise"
  
  def create
    super
    HunterMailer.welcome(resource).deliver unless resource.invalid?
  end
end
