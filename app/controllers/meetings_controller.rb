class MeetingsController < ApplicationController
  def index
    if params[:tag]
      @meetings = Tag.find_by(name: params[:tag]).meetings
    else
      @meetings = Meeting.all
    end
    render 'index.html.erb'
  end

  def show
    @meeting = Meeting.find_by(id: params[:id])
    render 'show.html.erb'
  end

  def new
    @meeting = Meeting.new(start_time: DateTime.now, end_time: 1.hour.from_now)
    render 'new.html.erb'
  end

  def create
    @meeting = Meeting.new(
    name: params[:name],
    address: params[:address],
    start_time: params[:start_time],
    end_time: params[:end_time],
    notes: params[:notes]
    )
    if @meeting.save
      params[:tag_ids].each do |tag_id|
        MeetingTag.create(meeting_id: @meeting.id, tag_id: tag_id)
      end
      flash[:success] = "Meeting added successfully!"
      redirect_to "/meetings"
    else
      flash[:error] = "Meeting could not be saved"
      render 'new'
    end
  end

  def edit
    @meeting = Meeting.find_by(id: params[:id])
    render 'edit.html.erb'
  end

  def update
    @meeting = Meeting.find_by(id: params[:id])
    if @meeting.update(
      name: params[:name],
      address: params[:address],
      start_time: params[:start_time],
      end_time: params[:end_time],
      notes: params[:notes]
    )
    @meeting.tags.destroy_all
    params[:tag_id].each do |tag_id|
      MeetingTag.create(meeting_id: @meeting.id, tag_id: tag_id)
    end
      flash[:success] = "Meeting updated successfully!"
      redirect_to "/meetings/#{@meeting.id}"
    else
      flash[:error] = "Meeting could not be updated"
      render 'edit'
    end
  end


end
