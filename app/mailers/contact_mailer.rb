class ContactMailer < ActionMailer::Base
  def contact(mail, info)
    @mail = mail
    @info = info
    recipients = @mail.recipients.collect do |x|
      x = email_with_name(x.name, "#{x.slug}@d.kth.se")
    end
    mail(
      :from => email_with_name(@mail.name, @mail.email),
      :to => recipients,
      :subject => "Datasektionen: Meddelande via hemsidan"
    )
  end

  protected
  def email_with_name(name, email)
    "\"#{name}\" <#{email}>"
  end
end
