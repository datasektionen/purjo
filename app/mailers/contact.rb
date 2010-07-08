class Contact < ActionMailer::Base
  def functionary(post, mail, info)
    @post = post
    @mail = mail
    @info = info
    mail(
      :from => email_with_name(@mail),
      :to => email_with_name(@post),
      :subject => "Meddelande via hemsidan"
    )
  end

  protected
  def email_with_name(data)
    "\"#{data.name}\" <#{data.email}>"
  end
end
