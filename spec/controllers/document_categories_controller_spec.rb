require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DocumentCategoriesController do

  # This should return the minimal set of attributes required to create a valid
  # DocumentCategory. As you add validations to DocumentCategory, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "caption": "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentCategoriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all document_categories as @document_categories" do
      document_category = DocumentCategory.create! valid_attributes
      get :index, {}, valid_session
      assigns(:document_categories).should eq([document_category])
    end
  end

  describe "GET show" do
    it "assigns the requested document_category as @document_category" do
      document_category = DocumentCategory.create! valid_attributes
      get :show, {id: document_category.to_param}, valid_session
      assigns(:document_category).should eq(document_category)
    end
  end

  describe "GET new" do
    it "assigns a new document_category as @document_category" do
      get :new, {}, valid_session
      assigns(:document_category).should be_a_new(DocumentCategory)
    end
  end

  describe "GET edit" do
    it "assigns the requested document_category as @document_category" do
      document_category = DocumentCategory.create! valid_attributes
      get :edit, {id: document_category.to_param}, valid_session
      assigns(:document_category).should eq(document_category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DocumentCategory" do
        expect {
          post :create, {document_category: valid_attributes}, valid_session
        }.to change(DocumentCategory, :count).by(1)
      end

      it "assigns a newly created document_category as @document_category" do
        post :create, {document_category: valid_attributes}, valid_session
        assigns(:document_category).should be_a(DocumentCategory)
        assigns(:document_category).should be_persisted
      end

      it "redirects to the created document_category" do
        post :create, {document_category: valid_attributes}, valid_session
        response.should redirect_to(DocumentCategory.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document_category as @document_category" do
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentCategory.any_instance.stub(:save).and_return(false)
        post :create, {document_category: { "caption": "invalid value" }}, valid_session
        assigns(:document_category).should be_a_new(DocumentCategory)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentCategory.any_instance.stub(:save).and_return(false)
        post :create, {document_category: { "caption": "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested document_category" do
        document_category = DocumentCategory.create! valid_attributes
        # Assuming there are no other document_categories in the database, this
        # specifies that the DocumentCategory created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DocumentCategory.any_instance.should_receive(:update).with({ "caption": "MyString" })
        put :update, {id: document_category.to_param, document_category: { "caption": "MyString" }}, valid_session
      end

      it "assigns the requested document_category as @document_category" do
        document_category = DocumentCategory.create! valid_attributes
        put :update, {id: document_category.to_param, document_category: valid_attributes}, valid_session
        assigns(:document_category).should eq(document_category)
      end

      it "redirects to the document_category" do
        document_category = DocumentCategory.create! valid_attributes
        put :update, {id: document_category.to_param, document_category: valid_attributes}, valid_session
        response.should redirect_to(document_category)
      end
    end

    describe "with invalid params" do
      it "assigns the document_category as @document_category" do
        document_category = DocumentCategory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentCategory.any_instance.stub(:save).and_return(false)
        put :update, {id: document_category.to_param, document_category: { "caption": "invalid value" }}, valid_session
        assigns(:document_category).should eq(document_category)
      end

      it "re-renders the 'edit' template" do
        document_category = DocumentCategory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentCategory.any_instance.stub(:save).and_return(false)
        put :update, {id: document_category.to_param, document_category: { "caption": "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document_category" do
      document_category = DocumentCategory.create! valid_attributes
      expect {
        delete :destroy, {id: document_category.to_param}, valid_session
      }.to change(DocumentCategory, :count).by(-1)
    end

    it "redirects to the document_categories list" do
      document_category = DocumentCategory.create! valid_attributes
      delete :destroy, {id: document_category.to_param}, valid_session
      response.should redirect_to(document_categories_url)
    end
  end

end
