

class Jam_Func

  module Helpers # ============================

    WHITE = /\s+/

    def canon_name(str)
      return str.strip.gsub(WHITE, " ").upcase
    end

  end # === module ============================

  include Helpers

  def initialize *args
    @ons      = {}
    @on_errs  = {}

    # generate .includes table (array)
    @includes = args.flatten.uniq

    # include itself in .includes
    @includes.push(self)
  end

  def on(raw_name, func)
    name = canon_name(raw_name)

    if !@ons[name]
      @ons[name] = {}
    end

    list = @ons[name]
    list.push func

    self
  end

  def on_error raw_name, func
    @on_errs[canon_name(raw_name)] = func
    self
  end

  def events_for raw_name
    @ons[canon_name(raw_name)]
  end

  def run *args
    args
    .map { |v|

      v.kind_of?(String) ?
        self.events_for(v) :
        v

    }
    .flatten
    .each { |f| f() }

    self
  end

  def list(raw_name, create_if_needed = false)
    name = canon_name(raw_name);
    if !@ons[name] && create_if_needed
      @ons[name] = []
    end

    return @ons[name] || []
  end

  def entire_list_for(name)
    [
      list_with_includes('before ' + name),
      list_with_includes(name),
      list_with_includes('after '  + name)
    ]
    .flatten
  end

  def list_with_includes raw_name
    @includes.map { |t|
      (t == self) ?
        t.list(raw_name) :
        t.list_with_includes(raw_name)
    }
    .flatten
  end

  def on *args
    func = args.pop
    args.each { |name|
      list(name, true).push(func)
    }

    self
  end

  def run_error *args
    raise("Error handlers not found for: " + args[0]) if entire_list_for(args[0]).empty?
    run *args
  end

  def run *args

    funcs  = args.select { |u|
      u.kind_of?(String) || u.kind_of?(Proc)
    }

    str_funcs = funcs.select { |u|
      u.kind_of? String
    }

    parent_run = args.detect { |u|
      u.kind_of?(Jam_Func::Run)
    }

    non_data = [funcs, parent_run].flatten

    # === grab and merge data objects ===
    data = nil

    args.each { |u|
      if u.kind_of?(Hash)
        if !data
          data = u
        else
          data.merge!(u)
        end
      end
    }

    # ----------------------------------------------
    # if run is called without any string funcs:
    # Example:
    #    .run(parent_run, {}, func1, func2);
    #    .run(parent_run,     func1, func2);
    # ----------------------------------------------
    if !str_funcs || str_funcs.empty?
      t    = Jam_Func.new
      name = 'one-off'
      funcs.each { |f|
        t.on(name, f)
      }

      return t.run(*([parent_run, name, data].compact))
    end

    # === Process final results === --
    jam = Jam_Func::Run.new(self, parent_run, (data || {}), funcs).run()

    return jam.data[:val] unless jam.err

    # === Run error if found === --
    err_name = canon_name(jam.err_name)
    err      = jam.err
    err_func = @on_errs[err_name]
    return err_func.call(data || {}, err) if err_func

    raise("No error handler found for: #{err_name} : #{err}")
  end # === .run -----------------------

  class Jam # ========================================================

    attr_accessor :last
    attr_reader   :err_name, :err, :data, :last

    def initialize data
      self.last = nil
      @err_name = nil
      @err      = nil
      @data     = data || {}
      @val      = nil
      @last     = nil
    end

    def val new_val
      @val        = new_val
      @data[:val] = new_val
    end

    def _last val
      @last = val
    end

    def error name, val
      @err_name = name
      @err      = val
      throw :jam_error
    end

  end # ==============================================================

  # # ================================================================
  # # ================== Run (private) ===============================
  # # ================================================================

  class Run

    include Helpers

    attr_reader :err, :err_name

    def initialize(jam, parent_run, data, arr)

      @jam        = jam
      @parent_run = parent_run
      @data       = data
      @tasks      = nil

      @proc_list = arr.map { |n|
        n.kind_of?(String) ?
          canon_name(n) :
          n
      }

    end # === initialize

    def run
      raise("Already running.") if @tasks

      @tasks = []

      @proc_list.each { |var|
        if var.kind_of? String
          @tasks.push(@jam.entire_list_for(var));
        else
          @tasks.push var
        end
      }

      @tasks = @tasks.flatten

      jam = Jam_Func::Jam.new(@data)

      @tasks.detect { |func|
        is_fine = catch :jam_error do
          args = [jam.data, jam.last, jam].slice(0, func.arity)
          jam._last func.call *args
          true
        end

        !is_fine
      }

      jam
    end # === def run
  end # === class Run

end # === Jam_Func

