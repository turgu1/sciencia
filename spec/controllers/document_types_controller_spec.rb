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

describe DocumentTypesController do

  # This should return the minimal set of attributes required to create a valid
  # DocumentType. As you add validations to DocumentType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "caption": "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentTypesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all document_types as @document_types" do
      document_type = DocumentType.create! valid_attributes
      get :index, {}, valid_session
      assigns(:document_types).should eq([document_type])
    end
  end

  describe "GET show" do
    it "assigns the requested document_type as @document_type" do
      document_type = DocumentType.create! valid_attributes
      get :show, {id: document_type.to_param}, valid_session
      assigns(:document_type).should eq(document_type)
    end
  end

  describe "GET new" do
    it "assigns a new document_type as @document_type" do
      get :new, {}, valid_session
      assigns(:document_type).should be_a_new(DocumentType)
    end
  end

  describe "GET edit" do
    it "assigns the requested document_type as @document_type" do
      document_type = DocumentType.create! valid_attributes
      get :edit, {id: document_type.to_param}, valid_session
      assigns(:document_type).should eq(document_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DocumentType" do
        expect {
          post :create, {document_type: valid_attributes}, valid_session
        }.to change(DocumentType, :count).by(1)
      end

      it "assigns a newly created document_type as @document_type" do
        post :create, {document_type: valid_attributes}, valid_session
        assigns(:document_type).should be_a(DocumentType)
        assigns(:document_type).should be_persisted
      end

      it "redirects to the created document_type" do
        post :create, {document_type: valid_attributes}, valid_session
        response.should redirect_to(DocumentType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document_type as @document_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentType.any_instance.stub(:save).and_return(false)
        post :create, {document_type: { "caption": "invalid value" }}, valid_session
        assigns(:document_type).should be_a_new(DocumentType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentType.any_instance.stub(:save).and_return(false)
        post :create, {document_type: { "caption": "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested document_type" do
        document_type = DocumentType.create! valid_attributes
        # Assuming there are no other document_types in the database, this
        # specifies that the DocumentType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DocumentType.any_instance.should_receive(:update).with({ "caption": "MyString" })
        put :update, {id: document_type.to_param, document_type: { "caption": "MyString" }}, valid_session
      end

      it "assigns the requested document_type as @document_type" do
        document_type = DocumentType.create! valid_attributes
        put :update, {id: document_type.to_param, document_type: valid_attributes}, valid_session
        assigns(:document_type).should eq(document_type)
      end

      it "redirects to the document_type" do
        document_type = DocumentType.create! valid_attributes
        put :update, {id: document_type.to_param, document_type: valid_attributes}, valid_session
        response.should redirect_to(document_type)
      end
    end

    describe "with invalid params" do
      it "assigns the document_type as @document_type" do
        document_type = DocumentType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentType.any_instance.stub(:save).and_return(false)
        put :update, {id: document_type.to_param, document_type: { "caption": "invalid value" }}, valid_session
        assigns(:document_type).should eq(document_type)
      end

      it "re-renders the 'edit' template" do
        document_type = DocumentType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentType.any_instance.stub(:save).and_return(false)
        put :update, {id: document_type.to_param, document_type: { "caption": "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document_type" do
      document_type = DocumentType.create! valid_attributes
      expect {
        delete :destroy, {id: document_type.to_param}, valid_session
      }.to change(DocumentType, :count).by(-1)
    end

    it "redirects to the document_types list" do
      document_type = DocumentType.create! valid_attributes
      delete :destroy, {id: document_type.to_param}, valid_session
      response.should redirect_to(document_types_url)
    end
  end

end
