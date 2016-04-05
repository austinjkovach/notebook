# Controller for the Character model
class CharactersController < ContentController
  before_action :authenticate_user!

  private

  def content_params
    params.require(:character).permit(
      :universe_id, :user_id,
      :name, :age, :role, :gender, :age, :height, :weight, :haircolor,
      :facialhair, :eyecolor, :race, :skintone, :bodytype, :identmarks,
      :bestfriend, :religion, :politics, :prejudices, :occupation, :pets,
      :mannerisms, :birthday, :birthplace, :education, :background,
      :fave_color, :fave_food, :fave_possession, :fave_weapon, :fave_animal,
      :father, :mother, :spouse, :siblings, :archenemy, :notes, :private_notes)
  end
end
