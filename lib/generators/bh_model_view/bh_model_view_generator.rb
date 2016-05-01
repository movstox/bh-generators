class BhModelViewGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  # argument :me

  def create_view_show
    template 'show.html.erb', "app/views/#{plural_name}_bh/show.html.erb"
  end

  def create_view_edit
    body ="""
<h1>
  Edit #{class_name.capitalize}
</h1>
<%= render partial: 'form', locals: {#{plural_name.singularize}: @#{plural_name.singularize}} %>

<%= link_to 'Back', @#{plural_name.singularize} %>
"""

    create_file "app/views/#{plural_name}_bh/edit.html.erb", body
  end

  def create_view_new
    body ="""
<h1>
  New #{class_name.capitalize}
</h1>
<%= render partial: 'form', locals: {#{plural_name.singularize}: @#{plural_name.singularize}} %>

<%= link_to 'Back', @#{plural_name.singularize} %>
"""

    create_file "app/views/#{plural_name}_bh/new.html.erb", body
  end

  def header_columns
    [].tap do |cols|
      class_name.constantize.new.attributes.keys.each do |attr|
        cols << "          <th>#{attr.gsub(/_id$/,'').gsub('_',' ').capitalize}</th>" unless ignore_attr?(attr)
      end
    end.join("\n")
  end

  def create_view_index
    body = """
<%= panel title: 'All #{class_name.pluralize}', context: :info do %>
  <% if @all_records.any? %>
    <table class='table table-hover'>
      <thead>
        <tr>
#{header_columns}
          <th></th><!-- actions column -->
        </tr>
      </thead>
      <tbody>
        <%=render @all_records %>
      </tbody>
    </table>
  <% else %>
    <p>No #{plural_name} do exist so far</p>
  <% end %>
  <div class='panel-footer'>
    <%= link_to 'New #{plural_name.singularize.capitalize}', new_#{plural_name.singularize}_path, :class => 'btn btn-primary btn-lg', data: { disable_with: 'Please wait...' } %>
  </div>
<% end %>
"""

    create_file "app/views/#{plural_name}_bh/index.html.erb", body
  end

  def create_view_entity
    lines = []
    lines << "<tr>"
    class_name.constantize.new.attributes.keys.each do |attr|
      lines << """  <td><%= #{plural_name.singularize}.#{attr} %></td>""" unless ignore_attr?(attr)
end
    lines <<"""
  <td>
    <%= link_to 'Show', #{plural_name.singularize}, class: 'btn text-info' %>
    <%= link_to 'Edit', edit_#{plural_name.singularize}_path(#{plural_name.singularize}), class: 'btn text-warning' %>
    <%= link_to 'Destroy', #{plural_name.singularize}, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn text-danger' %>
  </td>
"""
    lines << "</tr>"
    create_file "app/views/#{plural_name}_bh/_#{plural_name.singularize}.html.erb", lines.join("\n")
  end

  def create_view_form
    lines = []
    lines << "<%= form_for #{plural_name.singularize}, layout: :basic do |f| %>"
    class_name.constantize.new.attributes.keys.each do |attr|
      lines << "  <%= f.text_field :#{attr} %>"
    end
    lines << "  <%= f.submit 'Save', data: { disable_with: 'Please wait...' } %>"
    lines << "<% end %>"
    create_file "app/views/#{plural_name}_bh/_form.html.erb", lines.join("\n")
  end
private
  def ignore_attr?(attr_name)
    %w(id created_at updated_at).include?(attr_name)
  end
end
