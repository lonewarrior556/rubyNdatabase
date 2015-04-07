class Question
  attr_accessor :title, :body, :user_id
  attr_reader :id

  def self.find_by_id(id)
    attr = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Question.new(*attr)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  # id , title , body , user_id
  def initialize(hash = {})
    @id = hash['id']
    @title = hash['title']
    @body = hash['body']
    @user_id = hash['user_id']
  end

  def self.find_by_author_id(author_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    attrs.map{|attr| Question.new(attr) }
  end

  def author
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end


end
