# frozen_string_literal: true

module SwitchPoint
  module Relation
    attr_writer :proc_to_give_switch_point_mode

    def exec_queries(*)
      with_switch_point_mode { super }
    end

    def calculate(*)
      with_switch_point_mode { super }
    end

    def delete_all(*)
      with_switch_point_mode { super }
    end

    def destroy(*)
      with_switch_point_mode { super }
    end

    def destroy_all(*)
      with_switch_point_mode { super }
    end

    def update(*)
      with_switch_point_mode { super }
    end

    def update_all(*)
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
        all.tap do |rel|
          rel.proc_to_give_switch_point_mode = klass.method(:with_readonly)
        end
      else
        raise UnconfiguredError.new("#{name} isn't configured to use switch_point")
      end
    end

    def using_writable
      if klass.switch_point_proxy
        all.tap do |rel|
          rel.proc_to_give_switch_point_mode = klass.method(:with_writable)
        end
      else
        raise UnconfiguredError.new("#{name} isn't configured to use switch_point")
      end
    end
  end
end
