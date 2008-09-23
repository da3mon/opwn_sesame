class EntrySystemsController < ApplicationController
  def create
    if @es = EntrySystem.create(params[:entry_system])
      redirect_to(entry_systems_path)
    else
      flash[:error] = @es.errors.full_messages
    end
  end
end
