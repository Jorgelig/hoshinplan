class InvoicesController < ApplicationController

  hobo_model_controller

  auto_actions :show

  auto_actions_for :subscription, [:index]


  include RestController

  api :GET, '/invoices/:id', 'Get an invoice'
  def show
    hobo_show
  end

  api :GET, '/subscriptions/:subscription_id/invoices/:id', 'Get all invoices for a specific subscription'
  def index_for_subscription
    hobo_index_for :subscription
  end

end