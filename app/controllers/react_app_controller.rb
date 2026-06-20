class ReactAppController < ApplicationController
  def index
    @current_user_json = if current_user
      {
        id: current_user.id,
        name: current_user.name,
        username: current_user.username,
        email: current_user.email,
        avatarUrl: current_user.avatar_url,
        companyId: current_user.company_id,
        owner: current_user.owner
      }.to_json
    else
      nil
    end

    @current_company_json = if current_company
      {
        id: current_company.id,
        name: current_company.name,
        imageUrl: current_company.image_url
      }.to_json
    else
      nil
    end

    render layout: 'react_app'
  end
end
