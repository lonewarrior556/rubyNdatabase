class QuestionFollow
  attr_accessor :question_id, :user_id

  def self.find_by_id(id)
    attr = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    QuestionFollow.new(*attr)
  end

  def self.followed_questions_for_user_id(user_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT DISTINCT
        following_qs.*
      FROM
        question_follows AS userid
      JOIN
        question_follows AS following_ids ON userid.user_id = following_ids.user_id
      JOIN
        questions AS following_qs ON following_qs.id = following_ids.question_id
      WHERE
        userid.user_id = ?
    SQL
      attrs.map{ |attr| Question.new(attr) }
    end

  def self.followers_for_question_id(question_id)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?

    SQL
      attrs.map{ |attr| User.new(attr) }
  end

  def self.most_followed_questions(n)
    attrs = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_id) DESC
      LIMIT
        ?
    SQL
    attrs.map{ |attr| Question.new(attr) }
  end

  # id, question_id, user_id
  def initialize(hash = {})
    @id= hash['id']
    @question_id = hash['question_id']
    @user_id = hash['user_id']
  end


end
