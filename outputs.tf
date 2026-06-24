output "dataset_id" {
  value = google_bigquery_dataset.my_dataset.dataset_id
}

output "table_id" {
  value = google_bigquery_table.my_table.table_id
}

output "view_id" {
  value = google_bigquery_table.my_view.table_id
}
