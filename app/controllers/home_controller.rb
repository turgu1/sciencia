class HomeController < ApplicationController
  def index
  end

  def about
  end

  def compute_counts
    Person.counter_culture_fix_counts
    Author.counter_culture_fix_counts

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Counts update completed." }
      format.js { redirect_to root_path, notice: "Counts update completed." }
    end
  end
end
