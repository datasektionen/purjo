class ContactController < ApplicationController
  def index
    @mail = ContactMail.new
    prefill_if_logged_in(@mail)
    @recipients = recipients
  end

  def single
    if params[:id]
      @post = ChapterPost.find(params[:id])
    else
      @post = ChapterPost.find_by(params[:post])
    end
    @mail = ContactMail.new
    prefill_if_logged_in(@mail)
    render :action => 'index'
  end

  def send_mail
    @mail = ContactMail.new(params[:contact_mail])
    @post = ChapterPost.find(@mail.to)
    @recipients = recipients
    info = { :ip => request.remote_ip }

    if @mail.valid?
      mailer = Contact.functionary(@post, @mail, info)
      if mailer.deliver
        flash[:notice] = "Tack för ditt meddelande!"
        redirect_to "/kontakt"
      else # mail delivery failed
        flash[:error] = "Meddelandet kunde inte skickas."
        render :action => 'index'
      end
    else # invalid mail
      flash.now[:error] = "Fel påträffades i formuläret, se nedan."
      render :action => 'index'
    end # valid mail?
  end

  protected

  # Returns an array of available recipients
  # to be used by the select() form helper
  def recipients
    posts = ChapterPost.find(:all)
    recipients = []
    posts.each { |p| recipients << [p.name, p.id] }
    return recipients
  end

  # Automatically specify name and email if user is logged in
  def prefill_if_logged_in(data)
    return if Person.current.anonymous?
    data.name ||= Person.current.name
    data.email ||= Person.current.email
  end
end
