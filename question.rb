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

  def self.most_liked(n)
    QuestionLike.most_liked_question(n)
  end




  # id , title , body , user_id
  def initialize(hash = {})
    @id = hash['id']
    @title = hash['title']
    @body = hash['body']
    @user_id = hash['user_id']
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
  def likers
    QuestionLike.likers_for_question_id(id)
  end
  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def save
    raise 'Posts need an author and title' if user_id.nil? || title.nil?
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id )
        INSERT INTO
          questions(title, body, user_id)
        VALUES
          (?,?,?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id, id)
        UPDATE
          questions
        SET
          title = ?, body = ?, user_id = ?
        WHERE
          id = ?
      SQL
    end
  end



end
