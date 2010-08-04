class ContactController < ApplicationController
  helper GroupedCollectionHelper

  def index
    @mail = ContactMail.new
    if params.include?(:slug)
      @mail.recipient = Committee.find_by_slug(params[:slug])
      @mail.recipient = ChapterPost.find_by_slug(params[:slug]) unless @mail.recipient
    end
    load_available_recipients if @mail.recipient.nil?
    prefill_if_logged_in(@mail)
  end

  def send_mail
    @mail = ContactMail.new(params[:contact_mail])
    load_available_recipients unless params[:hidden]
    info = { :ip => request.remote_ip }

    if @mail.valid?
      mailer = ContactMailer.contact(@mail, info)
      if mailer.deliver
        flash[:notice] = "Tack för ditt meddelande!"
        redirect_to contact_path
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
  def load_available_recipients
    @posts = ChapterPost.find(:all)
    @committees = Committee.find(:all)
  end

  # Automatically specify name and email if user is logged in
  def prefill_if_logged_in(data)
    return if Person.current.anonymous?
    data.name ||= Person.current.name
    data.email ||= Person.current.email
  end
end
