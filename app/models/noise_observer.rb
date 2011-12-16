class NoiseObserver < ActiveModel::Observer
  def after_create(noise)
    Rails.logger.info("SEND EMAIL TO POST AUTHOR AND COMMENTERS")
    post = noise.post
    recipients = post.commenters + [post.author] - [noise.person]

    recipients.each do |recipient|
      CommentMailer.notify(recipient, noise).deliver
    end
  end
end
