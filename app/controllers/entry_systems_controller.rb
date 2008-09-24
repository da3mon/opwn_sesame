class EntrySystemsController < ApplicationController
  def new
    @entry_system = EntrySystem.new()
  end
  
  def create
    if @entry_system = EntrySystem.create(params[:entry_system])
      redirect_to(entry_systems_path)
    else
      flash[:error] = @entry_system.errors.full_messages
    end
  end
end
