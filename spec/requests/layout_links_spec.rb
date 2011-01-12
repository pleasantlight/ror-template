require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => I18n.t('pages.home.title'))
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => I18n.t('contacts.new.title'))
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => I18n.t('pages.about.title'))
  end

  it "should have a Login page at '/account/sign_in'" do
    get '/account/sign_in'
    response.should have_selector('title', :content => I18n.t('common.title_prefix'))
  end

  it "should have a link to the english locale'" do
    get '/'
    response.should have_selector('option', :value => "English (US)")
  end

  it "should have a link to the french locale'" do
    get '/'
    response.should have_selector('option', :value => "French (France)")
  end
  
  it "should have a link to the hebrew locale'" do
    get '/'
    response.should have_selector('option', :value => "Hebrew (Israel)")
  end

end