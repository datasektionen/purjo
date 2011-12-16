class CommentMailer < ActionMailer::Base
  default :from => "noreply@datasektionen.se"

  def notify(recipient, comment)
    @post = comment.post  
    @author = comment.person
    @comment = comment
    mail(
      :to => @recipient,
      :subject => "ny kommentar på #{@post.name}"
    )
  end
end
