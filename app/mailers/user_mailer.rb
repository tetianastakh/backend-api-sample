class UserMailer < ApplicationMailer
  include MailerHelper

  def reset_password_request(user)
    substitutions = {
      '-resetLink-': user.reset_password_link
    }

    sendgrid_send(
      to: user.email,
      from: 'somecompany@gmail.com',
      name: 'Some Company',
      template_id: '54321',
      subject: 'Password reset',
      substitutions: substitutions
    )
  end

  def confirm_user(user)
    substitutions = {
      '-verifyLink-': user.confirm_email_link
    }

    sendgrid_send(
      to: user.email,
      from: 'somecompany@gmail.com',
      name: 'Some Company',
      template_id: '12345',
      subject: 'Confirm user',
      substitutions: substitutions
    )
  end

  private

  def custom_log(msg)
    @custom_logger ||= Logger.new("#{Rails.root}/log/user_mailer.log")
    @custom_logger.info(msg)
  rescue Exception => ex
    # Ignore now
  end
end
