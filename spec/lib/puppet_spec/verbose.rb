# Support code for running stuff with warnings disabled or enabled
module Kernel
  def with_verbose_disabled
    verbose, $VERBOSE = $VERBOSE, nil
    begin
      yield
    ensure
      $VERBOSE = verbose
    end
  end

  def with_verbose_enabled
    verbose, $VERBOSE = $VERBOSE, true
    begin
      yield
    ensure
      $VERBOSE = verbose
    end
  end
end
