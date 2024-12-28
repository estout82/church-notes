# frozen_string_literal: true

SitemapGenerator::Sitemap.default_host = "https://notespro.church"

SitemapGenerator::Sitemap.create do
  add "/articles/notion-database", changefreq: "weekly", priority: 0.8
  add "/articles/help-your-church-retain-sermons", changefreq: "weekly", priority: 0.8
  add "/articles/tips-to-increase-discipleship-with-your-churchs-website", changefreq: "weekly", priority: 0.8
end
