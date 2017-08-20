require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  include_context 'users'

  describe 'POST #create' do
    let(:form_params) { {} }
    let(:params) do
      {
        team: attributes_for(:team).merge(form_params)
      }
    end

    subject { post :create, params: params }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Team, :count) }
      it { expect(subject).to redirect_to new_user_session_path }
    end

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Team, :count).by(1) }

      it_behaves_like 'invalid params concern', 'empty title', model: Team do
        let(:form_params) { { title: '' } }
      end
    end
  end

  describe 'PATCH update' do
    let(:team) { create(:team, user_id: user.id) }

    let(:form_params) { {} }

    let(:params) do
      {
        id: team.id,
        team: { title: '123' }.merge(form_params),
        format: :js
      }
    end

    subject do
      patch :update, params: params
      team.reload
    end

    it_behaves_like 'when user is unauthorized' do
      before { subject }
      it { expect(team.title).to_not eql params[:team][:title] }
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(team.title).to eql params[:team][:title] }

      it_behaves_like 'invalid params js', 'empty title', model: Team do
        let(:form_params) { { title: '' } }
        before { subject }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:team) { create(:team, user_id: user.id) }

    let(:params) do
      {
        id: team.id,
        format: :js
      }
    end

    subject { delete :destroy, params: params }

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Team, :count) }
      it { expect(subject).to have_http_status(200) }
    end

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Team, :count) }
      it { expect(subject).to have_http_status(401) }
    end
  end

  describe 'GET #new' do
    it_behaves_like 'when user is authorized' do
      before { get :new }

      it 'assigns new team to @team' do
        expect(assigns(:team)).to be_a_new(Team)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end

    it_behaves_like 'when user is unauthorized' do
      before { get :new }

      it 'redirect to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #index' do
    let(:teams) do
      create_list(:team, 2, user_id: user.id)
    end

    it_behaves_like 'when user is authorized' do
      before { get :index }

      it 'list all' do
        expect(assigns(:teams)).to match_array(teams)
      end
      it 'renders the index template' do
        expect(response).to render_template :index
      end
    end
    it_behaves_like 'when user is unauthorized' do
      before { get :index }

      it 'renders the index template' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    let!(:team) { create(:team, user_id: user.id) }
    let!(:users) { create_list(:user, 2) }
    let!(:collaborator1) { create(:collaborator, user_id: users[0].id, team_id: team.id, status: 'approved') }
    let!(:collaborator2) { create(:collaborator, user_id: users[1].id, team_id: team.id, status: 'approved') }
    let!(:task1) { create(:task, user_id: users[0].id, team_id: team.id) }
    let!(:task2) { create(:task, user_id: users[1].id, team_id: team.id) }

    subject { get :show, params: { id: team.id } }

    it_behaves_like 'when user is unauthorized' do
      it { expect(subject).to redirect_to new_user_session_path }
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(response).to render_template :show }
      it { expect(assigns(:team)).to eq(team) }
      it { expect(assigns(:tasks)).to include(task1, task2) }
    end
  end

  describe 'GET #edit' do
    let!(:team) { create(:team, user_id: user.id) }

    subject { get :edit, params: { id: team.id } }

    it_behaves_like 'when user is unauthorized' do
      it { expect(subject).to redirect_to new_user_session_path }
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(response).to render_template :edit }
      it { expect(assigns(:team)).to eq(team) }
    end
  end
end
