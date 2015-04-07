class QuestionLike
  attr_accessor :user_id, :question_id
  def self.find_by_id(id)
    attr = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    QuestionLike.new(*attr)
  end

  def self.likers_for_question_id(question_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?

    SQL
    attrs.map{ |attr| User.new(attr)}
  end

  def self.num_likes_for_question_id(question_id)
    some_variable= QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(users.id)
      FROM
        question_likes
      JOIN
        users ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
    SQL
    some_variable[0].values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL
    attrs.map{ |attr| Question.new(attr)}
  end


  def self.most_liked_questions(n)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_id) DESC
      LIMIT
        ?
    SQL
    attrs.map{ |attr| Question.new(attr) }
  end



  #id, user_id, question_id
  def initialize(hash = {})
    @id = hash['id']
    @user_id = hash['user_id']
    @question_id = hash['question_id']
  end


end
