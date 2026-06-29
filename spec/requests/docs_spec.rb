require 'rails_helper'

RSpec.describe 'Docs', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }

  before { login_as(user) }

  describe 'GET /projects/:project_id/docs' do
    it 'lists docs for a project' do
      create(:note, project: project, author: user)
      get project_docs_path(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /projects/:project_id/docs' do
    it 'creates a doc with valid params' do
      expect {
        post project_docs_path(project), params: {
          note: { title: 'Architecture', body: '## Overview' }
        }
      }.to change(Note, :count).by(1)
      expect(response).to redirect_to(project_doc_path(project, Note.last))
    end
  end

  describe 'GET /projects/:project_id/docs/:id' do
    it 'shows doc detail' do
      note = create(:note, project: project, author: user)
      get project_doc_path(project, note)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /projects/:project_id/docs/:id' do
    it 'updates the doc' do
      note = create(:note, project: project, author: user)
      patch project_doc_path(project, note), params: { note: { title: 'Updated Title' } }
      expect(note.reload.title).to eq('Updated Title')
    end
  end

  describe 'DELETE /projects/:project_id/docs/:id' do
    it 'deletes the doc' do
      note = create(:note, project: project, author: user)
      expect {
        delete project_doc_path(project, note)
      }.to change(Note, :count).by(-1)
    end

    it 'deletes child docs' do
      parent = create(:note, project: project, author: user)
      child = create(:note, project: project, author: user, parent: parent)
      expect {
        delete project_doc_path(project, parent)
      }.to change(Note, :count).by(-2)
    end
  end
end
