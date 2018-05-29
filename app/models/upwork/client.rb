class Upwork::Client < ApplicationRecord
  has_many :jobs

  after_update :upload_into_vtiger

  enum vtiger_state: [:not_uploaded, :uploading, :uploaded]

  def upload_into_vtiger
    VTiger::UploadClientsJob.perform_later(self.id)
  end
end
