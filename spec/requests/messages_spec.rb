require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }

  before { login_as(user) }

  describe 'GET /projects/:project_id/messages' do
    it 'lists messages for a project' do
      create(:message, project: project, author: user)
      get project_messages_path(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /projects/:project_id/messages' do
    it 'creates a message with valid params' do
      expect {
        post project_messages_path(project), params: {
          message: { title: 'Test Message', body: 'Hello world' }
        }
      }.to change(Message, :count).by(1)
      expect(response).to redirect_to(project_message_path(project, Message.last))
    end
  end

  describe 'GET /projects/:project_id/messages/:id' do
    it 'shows message detail' do
      message = create(:message, project: project, author: user)
      get project_message_path(project, message)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /projects/:project_id/messages/:id' do
    it 'deletes the message' do
      message = create(:message, project: project, author: user)
      expect {
        delete project_message_path(project, message)
      }.to change(Message, :count).by(-1)
      expect(response).to redirect_to(project_messages_path(project))
    end
  end
end
