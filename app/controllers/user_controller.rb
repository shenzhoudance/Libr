require "douban_auth"
require "qq_auth"

class UserController < ApplicationController
  before_filter :current_user
	include Douban_Auth
  include QQAuth

	def login
		render :layout => false
	end

	def auth_douban
		url = auth_url.to_s
	  redirect_to url
  end

  def auth_qq
    url = qq_auth_url.to_s
    redirect_to url
  end

	def logout
		session[:name] = nil
		redirect_to '/'
  end

  def books
    query = params[:query]
    @user = User.find_by_id params[:id]
    case  query
      when 'borrowed'
        @books = @user.borrowed_and_not_returned_books
      when 'wanted'
        @books = nil
      else
        @books =  @user.books
    end
    @query = query
    render :books
  end

  def return_book
    instance = BookInstance.find_by_id params[:instance_id]
    if @current_user.borrowed_and_not_returned_books.include? instance
      @current_user.return_book instance
      @message = 'Return book success.'
    else
      @message = "Can't find your borrow record."
    end
    redirect_to :back,:notice => @message
  end

  def view
    @user = User.find_by_id params[:id]

    @total_borrowed_books = @user.borrowed_books
    @total_books = @user.book_instances
  end

end
