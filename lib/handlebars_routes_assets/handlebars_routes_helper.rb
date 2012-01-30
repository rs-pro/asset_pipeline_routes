module HandlebarsRoutesAssets
  class RoutesHelper
    def initialize(routes, default_block = '{{\1}}')
      routes.each do |route|
        next if route.name.nil? # only handle named_routes
        
        self.class.instance_eval do
          define_method :"#{route.name}_path" do |mapping = default_block |
            build_url route, mapping
          end
          define_method :"#{route.name}_gsub_path" do |id_replacement|
            proc { |route, mapping| build_url route, mapping }.curry[route].call id_replacement
          end
        end
      end
    end

    def build_url route, mapping
      route.path.ast.to_s.gsub(/\(\.:\w+\)/,'').gsub(/:(\w+)/, mapping).to_s
    end
  end
end