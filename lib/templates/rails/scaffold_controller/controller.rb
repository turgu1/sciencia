<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  # GET <%= route_url %>.js
  # GET <%= route_url %>.json
  def index
    respond_to do |format|
      format.html
      format.js
      format.json { render json: <%= controller_class_name %>Datatable.new(view_context) }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.js
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET <%= route_url %>/1/edit
  # GET <%= route_url %>/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.js
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, notice: "[#{@<%= singular_table_name %>.<%= attributes[0].name %>}] was successfully created." }
        format.js   { redirect_to @<%= singular_table_name %>, notice: "[#{@<%= singular_table_name %>.<%= attributes[0].name %>}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  # PATCH/PUT <%= route_url %>/1.js
  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        format.html { redirect_to @<%= singular_table_name %>, notice: "[#{@<%= singular_table_name %>.<%= attributes[0].name %>}]  was successfully updated." }
        format.js   { redirect_to @<%= singular_table_name %>, notice: "[#{@<%= singular_table_name %>.<%= attributes[0].name %>}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.js
    def destroy
      the_name = @<%= singular_table_name %>.<%= attributes[0].name %>
      @<%= orm_instance.destroy %>
      respond_to do |format|
        format.html { redirect_to <%= index_helper %>_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to <%= index_helper %>_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_<%= singular_table_name %>
        @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
        params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
        params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
      end
end
<% end -%>
