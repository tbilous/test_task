require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
  include_context 'users'

  let(:team) { create(:team, user_id: user.id) }
  let(:collaborator) { create(:user) }

  describe 'POST #create' do
    subject { post :create, params: { team_id: team.id, user_id: collaborator.id, format: :json } }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Collaborator, :count) }
      it { expect(subject).to have_http_status(401) }
    end

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Collaborator, :count).by(1) }
    end
  end

  describe 'PATCH update' do
    let(:collaborate) { create(:collaborator, user_id: collaborator.id, team_id: team.id) }

    let(:form_params) { {} }

    let(:params) do
      {
        id: collaborate.id,
        status: '',
        format: :json
      }.merge(form_params)
    end
    statuses = %w[approved rejected]

    subject do
      patch :update, params: params
      collaborate.reload
    end

    it_behaves_like 'when user is unauthorized' do
      before { subject }
      statuses.each do |status|
        describe "to status #{status}" do
          let(:form_params) { { status: status } }
          it { expect(collaborate.status).to_not eql status }
        end
      end
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      statuses.each do |status|
        describe "to status #{status}" do
          let(:form_params) { { status: status } }
          it { expect(collaborate.status).to eql status }
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:collaborate) { create(:collaborator, user_id: collaborator.id, team_id: team.id) }

    let(:params) do
      {
        id: collaborate.id,
        format: :json
      }
    end

    subject { delete :destroy, params: params }

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Collaborator, :count) }
      it { expect(subject).to have_http_status(204) }
    end

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Collaborator, :count) }
      it { expect(subject).to have_http_status(401) }
    end
  end

  describe 'GET #new' do
    let!(:users) { create_list(:user, 3) }

    subject { get :new, params: { team_id: team.id } }

    it_behaves_like 'when user is authorized' do
      before { subject }

      it 'assigns new collaborator to @collaborator' do
        expect(assigns(:users)).to match_array(users)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end

    it_behaves_like 'when user is unauthorized' do

      it 'redirect to sign in path' do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

end
