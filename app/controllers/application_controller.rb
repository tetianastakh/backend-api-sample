class ApplicationController < ActionController::API
  before_action :authenticate_user

  rescue_from Exception, with: :handle_exception

  def authenticate_user
    #authenticate_token || render_unauthorized
  end

  def authenticate_token
    token = current_token

    if token.present?
      @current_user = token.user
      set_current_user(@current_user)
    else
      @current_user = nil
    end
  end

  def current_token
    authorization_token = request.headers['Authorization']
    return nil unless authorization_token.present? && authorization_token.split[0] == 'Bearer'

    token = Token.find_by(token: request.headers['Authorization'].split[1])
  end

  def render_error_message(error_message, status = :unprocessable_entity)
    render json: {
      ok: false,
      status: Rack::Utils.status_code(status),
      error_message: error_message
    }, status: status
  end

  def render_errors(errors, status = :unprocessable_entity)
    render json: {
      ok: false,
      status: Rack::Utils.status_code(status),
      errors: errors
    }, status: status
  end

  def render_record_errors(record, status = :unprocessable_entity)
    render_errors(record.errors.to_hash(true), status)
  end

  def render_nested_record_errors(record, status = :unprocessable_entity)
    render_errors(extract_nested_record_errors(record), status)
  end

  def render_base_exception(bex)
    case bex
    when ::Exceptions::BadPermission
      status = :forbidden
    when ::Exceptions::RecordNotFound
      status = :not_found
    when ::Exceptions::ArgumentError
      status = :bad_request
    else
      status = :unprocessable_entity
    end

    return render_errors(bex.errors, status) if bex.errors.present?
    render_error_message(bex.message, status)
  end

  def handle_interactor_error(result)
    return render_record_errors(result.record) if result.record
    return handle_exception(result.exception) if result.exception
    return render_error_message(result.message)
  end

  def render_unauthorized
    render_error_message('You need to authenticate.', :unauthorized)
  end

  def current_user
    @current_user ||= authenticate_token
  end

  def handle_exception(e)
    case e
    when ::Exceptions::RecordNotFound,
      ActiveRecord::RecordNotFound
      render_error_message(e.message, :not_found)
    when ::Exceptions::ArgumentError,
      ActionController::BadRequest,
      ActionController::ParameterMissing,
      ActionController::UnpermittedParameters
      return render_error_message(e.message, :bad_request)
    when ::Exceptions::BadPermission
      return render_error_message(e.message, :forbidden)
    when ::Exceptions::UnableToUpdate,
      ::Exceptions::UnableToCreate
      return render_record_errors(e.record, :unprocessable_entity) if e.record
      return render_error_message(e.message, :unprocessable_entity)
    else
      Rails.logger.error("Exception encountered: #{e.class} - #{e}")
      Rails.logger.error("\t" + e.backtrace.join("\n\t"))
      render_error_message(e.message, :internal_server_error)
    end
  end

  private

  def extract_nested_record_errors(record)
    record.errors.to_hash(true).map do |key, value|
      association_reflection = record.class.reflect_on_association(key)
      if association_reflection # non-nil when key refers to association
        associated_errors = case association_reflection
        when ActiveRecord::Reflection::HasManyReflection
          subrecord_errors = record.method(key).call.map { |subrecord| extract_nested_record_errors(subrecord) }
          subrecord_errors.empty? ? value : subrecord_errors
        when ActiveRecord::Reflection::BelongsToReflection
          subrecord = record.method(key).call
          suberror = subrecord.nil? ? value : extract_nested_record_errors(subrecord)
          suberror.blank? ? value : suberror
        else
          raise NotImplementedError.new("Unsupported association type #{association_reflection.class.name}")
        end
        [key, associated_errors]
      else
        [key, value]
      end
    end.to_h
  end
end
