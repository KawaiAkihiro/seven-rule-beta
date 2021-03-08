class ApplicationController < ActionController::Base
    include MastersHelper
    include SessionsHelper
    include IndividualShiftsHelper
    include PerfectShiftsHelper
end
