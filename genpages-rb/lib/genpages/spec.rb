module Genpages
    class AttributeSpec
        attr_reader :name, :value
        def initialize(name, value)
            @name = name
            @value = value
        end
    end

    class PropSpec
        attr_reader :type, :name
        def initialize(type, name)
            @type = type
            @name = name
        end
    end

    class PageSpec
        attr_reader :props
    end
end
