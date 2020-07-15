def set_request_authorization!(user = nil)
  user                             ||= create(:client_user)
  token                            = user.tokens.create.token
  request.headers['Authorization'] = 'Bearer ' << token
end

def test_endpoint_authentication(action, opts = {})
  it_behaves_like 'an endpoint requiring authentication' do
    opts = opts.reverse_merge verb: 'get', params: {}
    subject { send(opts[:verb], action, params: opts[:params], as: :json) }
  end

  it_behaves_like 'an endpoint requiring admin authentication' do
    opts = opts.reverse_merge verb: 'get', params: {}
    subject { send(opts[:verb], action, params: opts[:params], as: :json) }
  end
end

def test_endpoint_forbidden_for_standard_user(action, opts = {})
  context 'as a standard user' do
    before(:each) do
      set_request_authorization!(create(:client_user))
    end

    opts = opts.reverse_merge verb: 'get', params: {}
    subject { send(opts[:verb], action, params: opts[:params], as: :json) }

    it 'responds with 403 Forbidden' do
      expect(subject).to have_http_status(:forbidden)
    end
  end
end

def parse_body(response)
  JSON.parse(response.body).with_indifferent_access
end

def parse_array_body(response)
  JSON.parse(response.body).collect(&:with_indifferent_access)
end

def validate_pagination(total_items, result_total, per_page, page)
  # total_items is the Model total
  # result_total is the number of items as request result
  number_of_pages = (total_items / per_page.to_f).ceil # round the number of page to up
  if page < number_of_pages
    expect(result_total).to eq per_page
  elsif page == number_of_pages
    rest = total_items % per_page
    if rest == 0
      expect(result_total).to eq per_page
    else
      expect(result_total).to eq rest
    end
  else
    expect(result_total).to eq 0
  end
end
