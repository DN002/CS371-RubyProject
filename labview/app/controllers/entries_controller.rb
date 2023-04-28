
require 'net/ping'
include Net

# James A., s1032252
# Chris A.

class EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]
  
  # Defines a new method and, therefore, a new controller action.
  # Similar to index, but sorted in descending (DESC) order
  # by creation time.
  # GET /entries/view_all
  def view_all
    # @entries = Entry.order('created_at DESC').all
    @entries = Entry.all

    # Entry contents change at random based on the value of rand.round (0 or 1):
    @entries.each do |entry|

      host = entry.hostname

      pe = Net::Ping::External.new(host)
      pe.timeout = 1 # Reduce ping timeout to reduce runtime (SP23)
      status = "up"

      if pe.ping?
        puts "External ping successful"
        status = "up"
      else
        puts "External ping unsuccessful"
        status = "down"
      end

      entry.status = status
      
      entry.save
    end
  end

  # GET /entries or /entries.json
  def index
    @entries = Entry.all
  end

  # GET /entries/1 or /entries/1.json
  def show
    @entry = Entry.find(params[:id])
    @hostname = @entry.hostname
    @status = @entry.status
  end
  

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries or /entries.json
  def create
    @entry = Entry.new(entry_params)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to entry_url(@entry), notice: "Entry modified." }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1 or /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to entry_url(@entry), notice: "Entry updated." }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1 or /entries/1.json
  def destroy
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, notice: "Entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:hostname, :status)
    end 
    
end
