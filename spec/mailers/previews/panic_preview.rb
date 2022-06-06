# Preview all emails at http://localhost:3000/rails/mailers/panic
class PanicPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/panic/missing_key
  def missing_key
    Munificent::Admin::PanicMailer.missing_key
  end
end
