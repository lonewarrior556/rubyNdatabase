class Reply
  attr_accessor :question_id, :reply_id, :user_id, :body
  attr_reader :id

  def self.find_by_id(id)
    attr = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(*attr)
  end


  def self.find_by_user_id(user_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    attrs.map{|attr| Reply.new(attr) }
  end

  def self.find_by_question_id(question_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    attrs.map{|attr| Reply.new(attr) }
  end

  # id question_id reply_id, user_id, body
  def initialize(hash = {})
    @id = hash['id']
    @question_id = hash['question_id']
    @reply_id = hash['reply_id']
    @user_id = hash['user_id']
    @body  = hash['body']
  end


  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    return [] if reply_id.nil?
    Reply.find_by_id(reply_id)
  end

  def child_replies
    attrs = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL
    attrs.map{|attr| Reply.new(attr) }
  end



end
