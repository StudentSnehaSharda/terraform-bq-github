terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "MyFirstProject-tf-state"
    prefix = "bigquery"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Dataset
resource "google_bigquery_dataset" "my_dataset" {
  dataset_id  = "github_bq_dataset"
  description = "Created via GitHub Actions + Terraform"
  location    = "US"

  labels = {
    env     = "dev"
    managed = "terraform"
  }
}

# Table
resource "google_bigquery_table" "my_table" {
  dataset_id          = google_bigquery_dataset.my_dataset.dataset_id
  table_id            = "github_bq_table"
  deletion_protection = false

  schema = jsonencode([
    { name = "id",         type = "INTEGER",   mode = "REQUIRED" },
    { name = "name",       type = "STRING",    mode = "NULLABLE" },
    { name = "email",      type = "STRING",    mode = "NULLABLE" },
    { name = "created_at", type = "TIMESTAMP", mode = "REQUIRED" }
  ])
}

# View
resource "google_bigquery_table" "my_view" {
  dataset_id          = google_bigquery_dataset.my_dataset.dataset_id
  table_id            = "github_bq_view"
  deletion_protection = false

  view {
    query          = "SELECT * FROM `${var.project_id}.github_bq_dataset.github_bq_table`"
    use_legacy_sql = false
  }
}
