locals {
    local_dir = var.dir_path
}

# source api key from environmental variables
provider "heroku" {}

resource "heroku_app" "this-app" {
    name = "personal-website.david-pw.com"
    region = "us"
}

resource "heroku_slug" "this-slug" {
    app_id = heroku_app.this-app.id
    file_url = "todo"
}