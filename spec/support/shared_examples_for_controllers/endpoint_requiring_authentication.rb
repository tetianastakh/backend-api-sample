shared_examples_for 'an endpoint requiring authentication' do
  context 'when called without authentication' do
    before(:each) { request.headers['Authorization'] = nil }

    it 'responds with 401 Unauthorized' do
      expect(subject).to have_http_status(:unauthorized)
    end
  end

  context 'when called with an invalid auth token' do
    before(:each) { request.headers['Authorization'] = 'Bearer ' << SecureRandom.uuid }

    it 'responds with 401 Unauthorized' do
      expect(subject).to have_http_status(:unauthorized)
    end
  end
end

shared_examples_for 'an endpoint requiring admin authentication' do
  context 'when called without admin authentication' do
    before(:each) { request.headers['Authorization'] = nil }

    it 'responds with 401 Unauthorized' do
      expect(subject).to have_http_status(:unauthorized)
    end
  end
end
