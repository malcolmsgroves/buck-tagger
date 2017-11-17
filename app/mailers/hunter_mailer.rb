class HunterMailer < ApplicationMailer

  default from: 'notifications@hunters.com'

  def welcome(user)
    @user = user
    # @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Thanks for signing up for Buck Tagger!')
  end
end
