terraform {
  required_providers {
    rudderstack = {
      source  = "rudderlabs/rudderstack"
      version = "~> 0.7.2"
    }
  }
  required_version = "> 1.1.0"
}

provider "rudderstack" {
  api_url      = "https://api.rudderstack.com/v2"
  #access_token = "enter workspace access token"
}

resource "rudderstack_source_javascript" "wyze-site" {
  name = "Marketing Website"
}

resource "rudderstack_source_ios" "wyze-app" {
  name = "IOS App"
}

resource "rudderstack_source_node" "wyze-server" {
  name = "Backend Subscription Service"
}

resource "rudderstack_source_node" "wyze-devices" {
  name = "IOT - Connected Device Events"
}

resource "rudderstack_destination_snowflake" "wyze-warehouse" {
  name = "Snowflake"

  config {
    account = "ina31471.us-east-1"
    database = "wahoo_demo"
    warehouse = "wahoo_poc"
    user = "wahoo"
    password = "Rudder24!!!"
    sync {
      frequency = "60"
    }
    use_rudder_storage = true
  }
}

resource "rudderstack_connection" "example1" {
  source_id      = rudderstack_source_javascript.wyze-site.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example2" {
  source_id      = rudderstack_source_ios.wyze-app.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example3" {
  source_id      = rudderstack_source_node.wyze-server.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example4" {
  source_id      = rudderstack_source_node.wyze-devices.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}






