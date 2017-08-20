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
        format: :json
      }
    end

    subject { delete :destroy, params: params }

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Task, :count) }
      it { expect(subject).to have_http_status(204) }
    end

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Task, :count) }
      it { expect(subject).to have_http_status(401) }
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

    it_behaves_like 'when user is authorized' do
      before { subject }

      it 'assigns new task to @task' do
        expect(assigns(:task)).to be_a_new(Task)
      end
    end

    # describe 'when user is authorized' do
    #   describe 'when user is teammaker' do
    #     before {get :index}
    #     before {sign_in(worker)}
    #     it 'renders the index template' do
    #       expect(response).to render_template :new
    #       expect(assigns(:task)).to be_a_new(Task)
    #     end
    #   end
    #
    #
    #   describe 'when user is worker' do
    #     before {get :index}
    #     before {sign_in(worker)}
    #     it 'redirect to sign in path' do
    #       expect(response).to redirect_to new_user_session_path
    #     end
    #   end
    #
    #   describe 'when user is coworker' do
    #     let(:coworker) {create(:user)}
    #     before {sign_in(coworker)}
    #     it 'redirect to sign in path' do
    #       expect(response).to redirect_to new_user_session_path
    #     end
    #   end
    # end
  end
end
