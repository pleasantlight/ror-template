require 'spec_helper'

describe UsersController do
  
  include Devise::TestHelpers
  
  render_views
  
  before(:each) do
    user_role   = Factory(:role, :name => 'User')
    admin_role  = Factory(:role, :name => 'Admin')
    @user       = Factory(:user, :roles => [user_role])
    @other_user = Factory(:user, :roles => [user_role], :email => 'other_user@test.com')
    @admin      = Factory(:user, :roles => [user_role, admin_role], :email => 'admin@test.com')
  end
  
  describe 'With an un-authorized user' do
    before(:each) do    
      # Log the regular user in to check that access is blocked.
      request.env['warden'] = mock(Warden, :authenticate => @user,
                                           :authenticate? => @user)
    end
    
    describe 'GET *index*' do
      it 'should redirect to the home page' do
        get :index
        response.should redirect_to(root_path)
      end

      it 'should have a flash.now message' do
        get :index
        flash.now[:error].should =~ /not authorized/i
      end
    end
    
    describe 'GET *new*' do
      it 'should redirect to the home page' do
        get :new
        response.should redirect_to(root_path)
      end

      it 'should have a flash.now message' do
        get :new
        flash.now[:error].should =~ /not authorized/i
      end
    end
    
    describe 'GET *show*' do
      it 'should redirect to the home page if we access another user' do
        get :show, :id => @other_user
        response.should redirect_to(root_path)
      end

      it 'should have a flash.now message if we access another user' do
        get :show, :id => @other_user
        flash.now[:error].should =~ /not authorized/i
      end
      
      it 'should be successful if the user accesses themselves' do
        get :show, :id => @user
        response.should be_success
      end
    end
    
    describe 'GET *edit*' do
      it 'should redirect to the home page if we access another user' do
        get :edit, :id => @other_user
        response.should redirect_to(root_path)
      end

      it 'should have a flash.now message if we access another user' do
        get :edit, :id => @other_user
        flash.now[:error].should =~ /not authorized/i
      end
      
      it 'should be successful if the user accesses themselves' do
        get :show, :id => @user
        response.should be_success
      end
    end
  end
  
  
  describe 'With an authorized user' do
    before(:each) do    
      # Log the admin user in to check that access is allowed.
      request.env['warden'] = mock(Warden, :authenticate => @admin,
                                           :authenticate? => @admin)
    end
        
    describe 'GET *index*' do
      it 'should be successful' do
        get :index
        response.should be_success
      end
  
      it 'should have the correct title' do
        get :index
        response.should have_selector('title', :content => I18n.t('users.index.title'))
      end    

      it 'should render the *index* page' do
        get :index, :user => @attr
        response.should render_template('index')
      end
      
      describe 'pagination' do
        before(:each) do
          @users = []
          30.times do
            @users << Factory(:user, :email => Factory.next(:email))
          end
        end
        
        it "should have an element for each user" do
          get :index
          @users[0..2].each do |user|
            response.should have_selector("td", :content => user.email)
          end
        end
        
        it "should paginate users" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          response.should have_selector("a", :href => "/en/users?page=2",
                                             :content => "2")
          response.should have_selector("a", :href => "/en/users?page=2",
                                             :content => "Next")
        end
      end
    end

    describe 'GET *new*' do
      it 'should be successful' do
        get :new
        response.should be_success
      end
  
      it 'should have the correct title' do
        get :new
        response.should have_selector('title', :content => I18n.t('users.new.title'))
      end    

      it 'should render the *new* page' do
        get :new, :user => @attr
        response.should render_template('new')
      end
    end

    describe 'GET *show*' do
      
        it 'should be successful' do
        get :show, :id => @user
        response.should be_success
      end

      it 'should have the correct title' do
        get :show, :id => @user
        response.should have_selector('title', :content => I18n.t('users.show.title'))
      end   

      it 'should render the *show* page' do
        get :show, :id => @user
        response.should render_template('show')
      end
      
    end

    describe 'GET *edit*' do
      it 'should be successful' do
        get :edit, :id => @user
        response.should be_success
      end
  
      it 'should have the correct title' do
        get :edit , :id => @user
        response.should have_selector('title', :content => I18n.t('users.edit.title'))
      end   

      it 'should render the *edit* page' do
        get :edit, :id => @user
        response.should render_template('edit')
      end
    end
    
    describe 'POST *create*' do
      
      describe 'with invalid parameters' do
        before(:each) do
          @attr = { :email => '', :password => '', :password_confirmation => '' }
        end

        it 'should not create a user' do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it 'should render the *new* page' do
          post :create, :user => @attr
          response.should render_template('new')
        end
      end
      
      describe 'with valid parameters' do
        before(:each) do
          @attr = { :email => 'test@domain.com', :password => '123456', :password_confirmation => '123456' }
        end

        it 'should create a user' do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end

        it 'should redirect to the view-all-users page' do
          post :create, :user => @attr
          response.should redirect_to(users_path)
        end

        it 'should have a flash.now message' do
          post :create, :user => @attr
          msg = I18n.t('users.flash.user_created', :email => @attr[:email])
          flash.now[:notice].should == msg
        end
      end
    end
    
    describe 'POST *update*' do
      
      describe 'with invalid parameters' do
        before(:each) do
          @attr = { :email => '', :password => '', :password_confirmation => '' }
        end

        it 'should render the *edit* page' do
          post :update,  :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it 'should not update the user' do
          post :update,  :id => @user, :user => @attr
          @user.email.should_not equal @attr[:email]
        end
      end
      
      describe 'with valid parameters' do
        before(:each) do
          @attr = { :email => 'test@domain.com', :password => '123456', :password_confirmation => '123456' }
        end

        it 'should be successful' do
          post :update,  :id => @user, :user => @attr
          response.should be_success
        end

        it 'should have a flash.now message' do
          post :update,  :id => @user, :user => @attr
          msg = I18n.t('users.flash.user_updated', :email => @attr[:email])
          flash.now[:notice].should == msg
        end
      end
    end
    
    describe 'POST *destroy*' do  
       
      it 'should delete a user' do
        lambda do
          post :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it 'should redirect to the view-all-users page' do
        post :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      it 'should have a flash.now message' do
        post :destroy, :id => @user
        msg = I18n.t('users.flash.user_deleted', :email => @user.email)
        flash.now[:notice].should == msg
      end
       
      it 'should not allow admins to delete themselves' do
        lambda do
          post :destroy, :id => @admin
        end.should change(User, :count).by(0)
        flash.now[:error].should =~ /not authorized/i
      end
       
      it 'should have a flash.now message if an admin tries to delete themselves' do
        post :destroy, :id => @admin
        flash.now[:error].should =~ /not authorized/i
      end
      
    end
  
  
  end

end
