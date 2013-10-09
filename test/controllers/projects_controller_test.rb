require 'test_helper'

describe ProjectsController do
  setup do
    session[:user_id] = users(:admin).id
  end

  describe "a GET to #index" do
    setup do
      get :index
    end

    it "renders a template" do
      assert_template :index
    end
  end

  describe "a GET to #new" do
    describe "as an admin" do
      setup do
        get :new
      end

      it "renders a template" do
        assert_template :new
      end
    end

    as_a_deployer do
      setup { get :new }
      it_is_unauthorized
    end
  end

  describe "a POST to #create" do
    describe "as an admin" do
      setup do
        post :create, params
      end

      describe "with valid parameters" do
        let(:params) { { :project => { :name => "Hello" } } }

        it "redirects to root url" do
          assert_redirected_to root_path
        end

        it "creates a new project" do
          Project.where(:name => "Hello").first.wont_be_nil
        end
      end

      describe "with invalid parameters" do
        let(:params) { { :project => { :name => "" } } }

        it "sets the flash error" do
          request.flash[:error].wont_be_nil
        end

        it "renders new template" do
          assert_template :new
        end
      end

      describe "with no parameters" do
        let(:params) {{}}

        it "redirects to root url" do
          assert_redirected_to root_path
        end
      end
    end

    as_a_deployer do
      setup { post :create }
      it_is_unauthorized
    end
  end

  describe "a DELETE to #destroy" do
    let(:project) { projects(:test) }

    describe "as an admin" do
      setup do
        delete :destroy, :id => project.id
      end

      it "redirects to root url" do
        assert_redirected_to admin_projects_path
      end

      it "removes the project" do
        lambda { project.reload }.must_raise ActiveRecord::RecordNotFound
      end

      it "sets the flash" do
        request.flash[:notice].wont_be_nil
      end
    end

    as_a_deployer do
      setup { delete :destroy, :id => project.id }
      it_is_unauthorized
    end
  end

  describe "a PUT to #update" do
    let(:project) { projects(:test) }

    describe "as an admin" do
      setup do
        post :update, params.merge(:id => project.id)
      end

      describe "with valid parameters" do
        let(:params) { { :project => { :name => "Hi-yo" } } }

        it "redirects to root url" do
          assert_redirected_to root_path
        end

        it "creates a new project" do
          Project.where(:name => "Hi-yo").first.wont_be_nil
        end
      end

      describe "with invalid parameters" do
        let(:params) { { :project => { :name => "" } } }

        it "sets the flash error" do
          request.flash[:error].wont_be_nil
        end

        it "renders edit template" do
          assert_template :edit
        end
      end

      describe "with no parameters" do
        let(:params) {{}}

        it "redirects to root url" do
          assert_redirected_to root_path
        end
      end
    end

    as_a_deployer do
      setup { post :update, :id => project.id }
      it_is_unauthorized
    end
  end

  describe "a GET to #edit" do
    let(:project) { projects(:test) }

    describe "as an admin" do
      setup do
        get :edit, :id => project.id
      end

      it "renders a template" do
        assert_template :edit
      end
    end

    as_a_deployer do
      setup { get :edit, :id => project.id }
      it_is_unauthorized
    end
  end

  describe "a GET to #show" do
    let(:project) { projects(:test) }

    as_a_deployer do
      setup do
        get :show, :id => project.id
      end

      it "renders a template" do
        assert_template :show
      end
    end

    as_a_viewer do
      setup { get :show, :id => project.id }
      it_is_unauthorized
    end
  end
end
