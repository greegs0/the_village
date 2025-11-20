class FamilyEventsController < ApplicationController
  def index
    @family = Family.find(params[:family_id])
    @family_events = @family.family_events
  end
end
