#
# Decides a price id given a plan
#
# TODO test
# REFACTOR move these ids into DB or ENV var
#

class Billing::PriceDecider
  def initialize(plan:)
    @plan = plan.to_sym
  end

  def run
    case @plan
    when :free
      ENV["NOTESPRO_FREE_PRICE"]
    when :base
      ENV["NOTESPRO_BASE_PRICE"]
    when :multisite
      ENV["NOTESPRO_MULTISITE_PRICE"]
    else
      raise UnknownPlanError.new "#{@plan} is not a plan" 
    end
  end

  class UnknownPlanError < StandardError; end
end
