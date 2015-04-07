class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.find_by_id(id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(*attrs)
  end

  def self.find_by_fname(fname)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, fname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
    SQL
    User.new(*attrs)
  end

  #id, fname, lname
  def initialize(hash = {})
    @id = hash['id']
    @fname = hash['fname']
    @lname = hash['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    attrs = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        questions.*
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
    SQL

    attrs.length / authored_questions.length.to_f
  end

  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, fname,lname )
        INSERT INTO
          users(fname, lname)
        VALUES
          (?,?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id )
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end
  end
end

















#moar space
