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
    attrs = QuestionsDatabase.instance.execute(<<-SQL, id)
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



  #id, user_id, question_id
  def initialize(hash = {})
    @id = hash['id']
    @user_id = hash['user_id']
    @question_id = hash['question_id']
  end


end
