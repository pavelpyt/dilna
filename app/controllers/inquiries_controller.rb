# Inbox nových poptávek — zakázky, které přišly z veřejného formuláře
# a nikdo se jim ještě nevěnoval.
class InquiriesController < ApplicationController
  def index
    @inquiries = current_account.jobs.with_status("inquiry").includes(:client, :property).newest_first
  end
end
