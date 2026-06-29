require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }

  before { login_as(user) }

  describe 'GET /projects/:project_id/events' do
    it 'lists events for a project' do
      create(:event, project: project, author: user)
      get project_events_path(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /projects/:project_id/events' do
    it 'creates an event with valid params' do
      expect {
        post project_events_path(project), params: {
          event: {
            title: 'Meeting',
            description: 'Team sync',
            start_date: Date.tomorrow,
            end_date: Date.tomorrow + 1
          }
        }
      }.to change(Event, :count).by(1)
      expect(response).to redirect_to(project_event_path(project, Event.last))
    end
  end

  describe 'DELETE /projects/:project_id/events/:id' do
    it 'deletes the event' do
      event = create(:event, project: project, author: user)
      expect {
        delete project_event_path(project, event)
      }.to change(Event, :count).by(-1)
    end
  end
end
