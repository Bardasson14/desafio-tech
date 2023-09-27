module Filter
    extend ActiveSupport::Concern

    module ClassMethods
        def query_by_filters(selected_filters)
            query_results = self.where nil # returns all records as ActiveRecord Collection
            selected_filters.each do |k, v|
                query_results = query_results.public_send("filter_by_#{k}", v) if v.present?
            end
            query_results
        end
    end
end