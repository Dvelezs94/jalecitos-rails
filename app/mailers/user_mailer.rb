class UserMailer  < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new ENV.fetch("EMAIL_API_TOKEN")
  end

  def confirmation_instructions(record, token, opts={})
    @token = token
    template_name = "user-confirmation"
    template_content = []
    message = {
      to: [{email: record.email}],
      subject: "Jalecitos Confirmation instructions",
      global_merge_vars: [
           { name: "CONFIRMURL", content: confirmation_url(record, confirmation_token: @token) },
           { name: "EMAIL", content: record.email },
           { name: "ALIAS", content: record.alias }
          ]
    }

    mandrill_client.messages.send_template template_name, template_content, message
  end
end
