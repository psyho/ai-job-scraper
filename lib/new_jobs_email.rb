require "tilt"
require "tilt/erb"
require "pony"

class NewJobsEmail
  def self.deliver(jobs_by_site)
    template = Tilt::ERBTemplate.new(File.expand_path("email.html.erb", __dir__))
    html = template.render(Object.new, jobs_by_site:)

    Pony.mail(
      to: ENV.fetch("RECIPIENT"),
      subject: "Nowe oferty pracy",
      html_body: html,
      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        enable_starttls_auto: true,
        user_name: ENV.fetch("SMTP_USERNAME"),
        password: ENV.fetch("SMTP_PASSWORD"),
        authentication: :plain, # :plain, :login, :cram_md5, no auth by default
        domain: "localhost.localdomain" # the HELO domain provided by the client to the server
      }
    )
  end
end
