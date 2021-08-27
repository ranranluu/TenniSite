class Post < ApplicationRecord

  belongs_to :user

  has_many :likes, dependent: :destroy
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  has_many :liked_users, through: :likes, source: :user

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  attachment :image
  
  has_many :post_comments, dependent: :destroy
  
  
  validates :content, presence: true
  
  
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_tag = Tag.find_or_create_by(name: new)
      self.tags << new_tag
    end
  end

  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'likes'
      return find(Like.group(:post_id).order(Arel.sql('count(post_id) desc')).pluck(:post_id))
    end
  end

end
