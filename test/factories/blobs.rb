FactoryBot.define do
  factory :blob, class: "ActiveStorage::Blob" do
    factory :cloudinary_image_blob do
      key { "h3xgcjhw6j4p1jsgjres51mfwn8i" }
      filename { "filename.jpg" }
      content_type { "image/jpeg" }
      metadata { {identified: true, analyzed: true}.to_json }
      service_name { "cloudinary" }
      byte_size { 1387755 }
      checksum { "ecoNjsjmUJ0b9JkwvMJh6g==" }
    end
  end
end