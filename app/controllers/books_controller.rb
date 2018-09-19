class BooksController < ApplicationController
  include Pagination
  before_action :set_book, only: [:update, :destroy]

  # GET /course/:course_id/books
  def index
    @pagy, @books = pagy(Course.find(params[:course_id]).books.includes(:user).order(created_at: :desc))

    @serializer_options[:include] = [:user]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: BookSerializer.new(@books, @serializer_options).serialized_json
  end

  # GET /books/:id
  def show
	  @book = Book.includes(:user, :course).find(params[:id])

	  @serializer_options[:include] = [:user]

	  render json: BookSerializer.new(@book, @serializer_options).serialized_json
  end

  # POST /course/:course_id/books
  def create
	  @book = Book.new(book_params)
	  @book.user = auth_user
	  @book.course = Course.find(params[:course_id])

	  if @book.save
		  @serializer_options[:include] = [:user]
		  @serializer_options[:meta][:message] = 'Materiale messo in vendita con successo!'

		  render json: BookSerializer.new(@book, @serializer_options).serialized_json, status: :created
	  else
		  render json: ErrorSerializer.new(@book.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
	  end
  end

  # PATCH/PUT /books/:id
  def update
	  unless @book.user.id == auth_user.id
		  return render json: ErrorSerializer.new('Non puoi aggiornare questo materiale se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
	  end

	  if @book.update(book_params)
		  @serializer_options[:meta][:message] = 'Materiale in vendita aggiornato con successo!'

		  render json: BookSerializer.new(@book, @serializer_options).serialized_json
	  else
		  render json: ErrorSerializer.new(@book.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
	  end
  end

  # DELETE /books/1
  def destroy
	  @user = auth_user
	  unless @book.user.id == @user.id
		  return render json: ErrorSerializer.new('Non togliere il materiale in vendita se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
	  end

	  @book.destroy

	  @serializer_options[:meta][:message] = 'Materiale tolto dalla vendita con successo!'

	  render json: BookSerializer.new(@book, @serializer_options).serialized_json
  end

  def search
	  if params[:search].present?
		  @pagy, @books = pagy(Book.matching(params[:search]).includes(:user, :course).order(created_at: :desc))
	  else
		  @pagy, @books = pagy(Book.includes(:user, :course).order(created_at: :desc))
	  end

	  @serializer_options[:include] = [:user]
	  @serializer_options.merge!(pagination_options(@pagy))

	  render json: BookSerializer.new(@books, @serializer_options).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def book_params
      params.require(:book).permit(:title, :description, :price, :course_id)
    end
end
