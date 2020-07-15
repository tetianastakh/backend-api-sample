class ApplicationMailer < ActionMailer::Base
  include SendGrid

  def sendgrid_send(options = {})
    mail = Mail.new
    mail.from = Email.new(email: options[:from], name: options[:name])
    mail.subject = options[:subject]
    personalization = Personalization.new
    if options[:to].instance_of? Array
      options[:to].each do |recipient|
        personalization.add_to(Email.new(email: recipient))
      end
    else
      personalization.add_to(Email.new(email: options[:to]))
    end
    personalization.add_cc(Email.new(email: options[:cc])) if options[:cc].present?
    personalization.add_bcc(Email.new(email: options[:bcc])) if options[:bcc].present?

    if options[:dynamic_data].present?
      personalization.add_dynamic_template_data(options[:dynamic_data])
    else
      # some action here
    end

    mail.add_personalization(personalization)

    if options[:body]
      body_type = options[:content_type] || 'text/plain'
      mail.add_content(
        Content.new(type: body_type, value: options[:body])
      )
    else
      mail.add_content(Content.new(type: 'text/html', value: '<br/>'))
      mail.template_id = options[:template_id]
    end

    # Setup the mailer
    mailer = SendGrid::API.new(api_key: ENV['SC_SENDGRID_API_KEY'])

    send_it(mailer, mail) if Rails.env.production?
  end

  private

  def send_it(mailer, mail)
    response = mailer.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  rescue Exception => e
    puts e.message
  end
end
