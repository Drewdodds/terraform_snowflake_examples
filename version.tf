##################
## EDIT SECTION ##
##################
locals {
  user_email = "david@rudderstack.com"
  user_access_token = "2fVAsXEBpIiBKzGfupF7dQFD8vr"
  dataplane_url = "https://rudderstacxdwa.dataplane.rudderstack.com"
#   warehouse_account = "edit me"
#   warehouse_database = "enter_database"
#   warehouse_warehouse = "enter_warehouse"
#   warehouse_user = "enter_user"
#   warehouse_password = "enter_password!!!"
}
##################
##################
##################
terraform {
  required_providers {
    rudderstack = {
      source  = "rudderlabs/rudderstack"
      version = "~> 0.8.1"
    }
    http = {
      source  = "hashicorp/http"
    }
  }
  required_version = "> 1.1.0"
}
provider "rudderstack" {
  api_url      = "https://api.rudderstack.com/v2"
  access_token = local.user_access_token
}
resource "rudderstack_destination_snowflake" "wyze-warehouse" {
  name = "Snowflake"
  config {
#     account = local.warehouse_account
#     database = local.warehouse_database
#     warehouse = local.warehouse_warehouse
#     user = local.warehouse_user
#     password = local.warehouse_password
    account = "test account"
    database = "test db"
    warehouse = "test wh"
    user = "test user"
    password = "test pass"
    sync {
      frequency = "60"
    }
    use_rudder_storage = true
    role = "test role"
  }
  enabled = false
}
resource "rudderstack_source_javascript" "wyze-site" {
  name = "Marketing Website"
}
resource "rudderstack_source_webhook_shopify" "wyze-shopify" {
  name = "Shopify Store"
}
resource "rudderstack_source_ios" "wyze-ios-app" {
  name = "IOS App"
}
resource "rudderstack_source_android" "wyze-android-app" {
  name = "Android App"
}
resource "rudderstack_source_python" "wyze-server" {
  name = "Backend Subscription Service"
}
resource "rudderstack_source_node" "wyze-devices" {
  name = "IOT - Connected Device Events"
}
resource "rudderstack_source_http" "wyze-tracking-plan-source" {
  name = "delete-me-tp-source"
}
resource "rudderstack_connection" "example1" {
  source_id      = rudderstack_source_javascript.wyze-site.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}
resource "rudderstack_connection" "example2" {
  source_id      = rudderstack_source_ios.wyze-ios-app.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}
resource "rudderstack_connection" "example3" {
  source_id      = rudderstack_source_python.wyze-server.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}
resource "rudderstack_connection" "example4" {
  source_id      = rudderstack_source_node.wyze-devices.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}
resource "rudderstack_connection" "example5" {
  source_id      = rudderstack_source_android.wyze-android-app.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}
resource "rudderstack_connection" "example6" {
  source_id      = rudderstack_source_webhook_shopify.wyze-shopify.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

output "marketing_writekey" {
  value = rudderstack_source_javascript.wyze-site.write_key
}
output "ios_writekey" {
  value = rudderstack_source_ios.wyze-ios-app.write_key
}
output "server_writekey" {
  value = rudderstack_source_python.wyze-server.write_key
}
output "iot_devices_writekey" {
  value = rudderstack_source_node.wyze-devices.write_key
}
output "android_writekey" {
  value = rudderstack_source_android.wyze-android-app.write_key
}
output "shopify_writekey" {
  value = rudderstack_source_webhook_shopify.wyze-shopify.write_key
}
output "http_writekey" {
  value = rudderstack_source_http.wyze-tracking-plan-source.write_key
}
data "http" "superblocks_events_post_request" {
  url = "https://agent.superblocks.com/v2/execute/4d605cea-4a0d-4541-9030-d122b1689bc0?delay=true"
  method = "POST"
  request_headers = {
    "Content-Type" = "application/json"
    "Authorization" = "Bearer qb53R97oYzunAsilS5AmvMwkMigL8jDOnUfQJwyQEzGoM+WL"
  }
  request_body = jsonencode({
    web_writekey = rudderstack_source_javascript.wyze-site.write_key
    dataplane_url = local.dataplane_url
    server_writekey = rudderstack_source_python.wyze-server.write_key
    ios_app_writekey = rudderstack_source_ios.wyze-ios-app.write_key
    android_app_writekey = rudderstack_source_android.wyze-android-app.write_key
    iot_devices_writekey = rudderstack_source_node.wyze-devices.write_key
    shopify_store_writekey = rudderstack_source_webhook_shopify.wyze-shopify.write_key
    http_writekey = rudderstack_source_http.wyze-tracking-plan-source.write_key
  })
}