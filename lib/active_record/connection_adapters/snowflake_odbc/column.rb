module ActiveRecord
  module ConnectionAdapters
    module SnowflakeOdbc
      class Column < ConnectionAdapters::Column # :nodoc:
        # Rails 8.1 inserted a required `cast_type` positional argument between
        # `name` and `default` in ActiveRecord::ConnectionAdapters::Column#initialize
        # (resolved lazily via #fetch_cast_type when nil). This adapter supports
        # activerecord >= 7.2, where that argument doesn't exist, so detect the
        # superclass signature instead of hard-coding one Rails version.
        SUPERCLASS_HAS_CAST_TYPE = ConnectionAdapters::Column.instance_method(:initialize)
                                                              .parameters.any? { |_, pname| pname == :cast_type }

        def initialize(name, default, sql_type_metadata = nil, null = true, default_function = nil, collation: nil,
                       comment: nil, **options)
          args = [name, _default(default), sql_type_metadata, null, default_function]
          args.insert(1, nil) if SUPERCLASS_HAS_CAST_TYPE
          super(*args, collation: collation, comment: comment, **options)
        end

        private

        def _default(default)
          return nil if default.nil? || default.empty?

          default
        end
      end
    end
  end
end
