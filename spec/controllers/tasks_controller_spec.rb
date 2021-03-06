require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  include_context 'users'
  let(:team) { create(:team, user_id: user.id) }
  let(:worker) { create(:user) }
  let(:collaborating) { create(:collaborator, user_id: worker.id) }

  describe 'POST #create' do
    let(:form_params) { {} }
    let(:params) do
      {
        team_id: team.id,
        task: attributes_for(:task, user_id: user.id).merge(form_params)
      }
    end

    subject { post :create, params: params }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Task, :count) }
      it { expect(subject).to redirect_to new_user_session_path }
    end

    it_behaves_like 'when user not is owner' do
      it { expect { subject }.to_not change(Task, :count) }
      it { expect(subject).to redirect_to authenticated_root_path }
    end

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Task, :count).by(1) }

      it_behaves_like 'invalid params concern', 'empty title', model: Task do
        let(:form_params) { { title: '' } }
      end
      it_behaves_like 'invalid params concern', 'empty body', model: Task do
        let(:form_params) { { body: '' } }
      end
    end
  end

  describe 'PATCH update' do
    let(:task) { create(:task, user_id: user.id, team_id: team.id) }

    let(:form_params) { {} }

    let(:params) do
      {
        id: task.id,
        task: { title: '123', body: '321' }.merge(form_params)
      }
    end

    subject do
      patch :update, params: params
      task.reload
    end

    it_behaves_like 'when user is unauthorized' do
      before { subject }
      it { expect(task.title).to_not eql params[:task][:title] }
    end

    it_behaves_like 'when user not is owner' do
      before { subject }
      it { expect(task.title).to_not eql params[:task][:title] }
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(task.title).to eql params[:task][:title] }
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { create(:task, user_id: user.id, team_id: team.id) }

    let(:params) do
      {
        id: task.id,
        format: :js
      }
    end

    subject { delete :destroy, params: params }

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Task, :count) }
      it { expect(subject).to have_http_status(200) }
    end

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Task, :count) }
      it { expect(subject).to have_http_status(401) }
    end

    it_behaves_like 'when user not is owner' do
      it { expect { subject }.to_not change(Task, :count) }
      it { expect(subject).to have_http_status(302) }
    end
  end

  describe 'GET #new' do
    subject { get :new, params: { team_id: team.id } }

    it_behaves_like 'when user is unauthorized' do
      before { subject }

      it 'redirect to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    it_behaves_like 'when user not is owner' do
      before { subject }

      it 'redirect to sign in path' do
        expect(response).to redirect_to authenticated_root_path
      end
    end

    it_behaves_like 'when user is authorized' do
      before { subject }

      it 'assigns new task to @task' do
        expect(assigns(:task)).to be_a_new(Task)
      end
    end
  end

  describe 'GET #edit' do
    let(:task) { create(:task, user_id: user.id, team_id: team.id) }
    subject { get :edit, params: { id: task.id } }

    it_behaves_like 'when user is unauthorized' do
      before { subject }

      it 'redirect to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    it_behaves_like 'when user not is owner' do
      before { subject }

      it 'redirect to sign in path' do
        expect(response).to redirect_to authenticated_root_path
      end
    end

    it_behaves_like 'when user is authorized' do
      before { subject }

      it 'assigns new task to @task' do
        expect(assigns(:task)).to eq(task)
      end
      it { expect(assigns(:team)).to eq(team) }
    end
  end

  describe 'GET #show' do
    let(:task) { create(:task, user_id: user.id, team_id: team.id) }
    subject { get :show, params: { id: task.id } }

    it_behaves_like 'when user is unauthorized' do
      before { subject }

      it 'redirect to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    it_behaves_like 'when user is authorized' do
      before { subject }

      it 'assigns new task to @task' do
        expect(assigns(:task)).to eq(task)
      end
    end
  end

  describe 'PUT #set_state' do
    let(:form_params) { {} }
    let(:task) { create(:task, user_id: non_owner.id, team_id: team.id) }
    let(:params) do
      { task_id: task.id, format: :js, state: 'open' }.merge(form_params)
    end
    subject { put :set_state, params: params }

    it_behaves_like 'when user is unauthorized' do
      it { expect(subject).to have_http_status(401) }
    end

    it_behaves_like 'when user not is owner' do
      describe 'in_progress' do
        let(:task) { create(:task, user_id: user.id, team_id: team.id, state: :assigned) }
        let(:form_params) { { state: 'in_progress' } }

        before do
          subject
          task.reload
        end
        it 'assigns new task to @task' do
          expect(task.state).to eq('in_progress')
        end
      end
      describe 'done' do
        let(:form_params) { { state: 'done' } }

        before do
          subject
          task.reload
        end
        it 'assigns new task to @task' do
          expect(task.state).to eq('done')
        end
      end
    end

    it_behaves_like 'when user is authorized' do
      describe 'assigned' do
        let(:form_params) { { state: 'assigned' } }

        before do
          subject
          task.reload
        end
        it 'assigns new task to @task' do
          expect(task.state).to eq('assigned')
        end
      end
      describe 'restart' do
        let(:form_params) { { state: 'restart' } }

        before do
          subject
          task.reload
        end
        it 'assigns new task to @task' do
          expect(task.state).to eq('assigned')
        end
      end
    end
  end
end
