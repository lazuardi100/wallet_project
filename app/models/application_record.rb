class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  after_create :create_wallet

  private

  def create_wallet
  end
end
