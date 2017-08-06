# frozen_string_literal: true

module SwitchPoint
  module Relation
    def exec_queries(*args, &block)
      with_switch_point_mode { super }
    end

    def calculate(*args, &block)
      with_switch_point_mode { super }
    end

    def delete_all(*args, &block)
      with_switch_point_mode { super }
    end

    def destroy(*args, &block)
      with_switch_point_mode { super }
    end

    def destroy_all(*args, &block)
      with_switch_point_mode { super }
    end

    def update(*args, &block)
      with_switch_point_mode { super }
    end

    def update_all(*args, &block)
      with_switch_point_mode { super }
    end

    def with_switch_point_mode
      if @proc_to_give_switch_point_mode
        @proc_to_give_switch_point_mode.call { yield }
      else
        yield
      end
    end
    private :with_switch_point_mode

    def using_readonly
      if klass.switch_point_proxy
        @proc_to_give_switch_point_mode = klass.method(:with_readonly)
        self
      else
        raise UnconfiguredError.new("#{name} isn't configured to use switch_point")
      end
    end

    def using_writable
      if klass.switch_point_proxy
        @proc_to_give_switch_point_mode = klass.method(:with_writable)
        self
      else
        raise UnconfiguredError.new("#{name} isn't configured to use switch_point")
      end
    end
  end
end
