class BooksController < ApplicationController
  include Pagination
  before_action :set_book, only: [:update, :destroy, :photos_destroy]
  before_action :check_if_images, only: [:create, :update]

  # GET /course/:course_id/books
  def index
    @pagy, @books = pagy(Course.find(params[:course_id]).books.with_full_infos.order(created_at: :desc))

    @serializer_options[:include] = [:user, :course]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: BookSerializer.new(@books, @serializer_options).serialized_json
  end

  # GET /books/:id
  def show
	  @book = Book.with_full_infos.find(params[:id])

	  @serializer_options[:include] = [:user, :course]

	  render json: BookSerializer.new(@book, @serializer_options).serialized_json
  end

  # POST /courses/:course_id/books
  def create
	  @book = Book.new(book_params)
	  @book.user = auth_user
	  @book.course = Course.find(params[:course_id])

	  if @book.save
		  @serializer_options[:include] = [:user, :course]
		  @serializer_options[:meta][:messages] = ['Materiale messo in vendita con successo!']

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
		  @serializer_options[:meta][:messages] = ['Materiale in vendita aggiornato con successo!']

		  render json: BookSerializer.new(@book, @serializer_options).serialized_json
	  else
		  render json: ErrorSerializer.new(@book.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
	  end
  end

  # DELETE /books/1
  def destroy
	  unless @book.user.id == auth_user.id
		  return render json: ErrorSerializer.new('Non puoi togliere il materiale in vendita se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
	  end

	  @book.destroy

	  @serializer_options[:meta][:messages] = ['Materiale tolto dalla vendita con successo!']

	  render json: BookSerializer.new(@book, @serializer_options).serialized_json
  end

  def search
	  if params[:search].present?
		  @pagy, @books = pagy(Book.matching(params[:search]).with_full_infos.order(created_at: :desc))
	  else
		  @pagy, @books = pagy(Book.with_full_infos.order(created_at: :desc))
	  end

	  @serializer_options[:include] = [:user, :course]
	  @serializer_options.merge!(pagination_options(@pagy))

	  render json: BookSerializer.new(@books, @serializer_options).serialized_json
  end

  # DELETE /books/:id/photos
	def photos_destroy
		unless @book.user.id == auth_user.id
			return render json: ErrorSerializer.new('Non puoi eliminare foto se non sei il propietario', status_code(:forbidden)).serialized_json, status: :forbidden
		end

		@photos = ActiveStorage::Attachment.find(params[:photos])
		messages = []

		@photos.each do |photo|
			photo.purge
			messages.push("'#{photo.blob.filename}' eliminato con successo!")
		end

		@serializer_options[:meta][:messages] = messages

		render json: BookSerializer.new(@book, @serializer_options).serialized_json
	end

  # GET /users/:user_id/books
  def user_books
	  @pagy, @books = pagy(User.find(params[:user_id]).books.with_full_infos.order(created_at: :desc))

	  @serializer_options[:include] = [:user, :course]
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
      params.require(:book).permit(:title, :description, :price, :course_id, photos: [])
    end

		def check_if_images
			if params[:book][:photos].present?
				re = Regexp.new("image/\\S+\\b")
				params[:book][:photos].each do |file|
					unless re.match(file.content_type)
						return render json: ErrorSerializer.new('Puoi caricare solamente delle immagini', status_code(:bad_request)).serialized_json, status: :bad_request
					end
				end
			end
		end
end
