class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.find_by_id(id)
    attr = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(*attr)
  end

  def self.find_by_fname(fname)
    attr = QuestionsDatabase.instance.execute(<<-SQL, fname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
    SQL
    User.new(*attr)
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


end
