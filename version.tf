terraform {
  required_providers {
    rudderstack = {
      source  = "rudderlabs/rudderstack"
      version = "~> 0.7.2"
    }
  }
  required_version = "> 1.1.0"
}

########### START EDIT SECTION ###############

provider "rudderstack" {
  api_url      = "https://api.rudderstack.com/v2"
  access_token = "enter_access_token" ######### EDIT ME
}

resource "rudderstack_destination_snowflake" "wyze-warehouse" {
  name = "Snowflake"

## This section here just edits the snowflake destination config. Does not actually create the wh and ddb. You have to run a separate script for that. 
  config {
    account = "ina31471.us-east-1"
    database = "enter_database" ######### EDIT ME
    warehouse = "enter_warehouse" ######### EDIT ME
    user = "enter_user" ######### EDIT ME
    password = "enter_password!!!" ######### EDIT ME
    sync {
      frequency = "60"
    }
    use_rudder_storage = true
  }
}

######### END EDIT SECTION #############





resource "rudderstack_source_javascript" "wyze-site" {
  name = "Marketing Website"
}

resource "rudderstack_source_webhook_shopify" "wyze-shopify" {
  name = "Shopify Store"
}

resource "rudderstack_source_ios" "wyze-ios-app" {
  name = "IOS App"
}

resource "rudderstack_source_ios" "wyze-android-app" {
  name = "Android App"
}

resource "rudderstack_source_node" "wyze-server" {
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
  source_id      = rudderstack_source_node.wyze-server.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example4" {
  source_id      = rudderstack_source_node.wyze-devices.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example5" {
  source_id      = rudderstack_source_node.wyze-android-app.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example6" {
  source_id      = rudderstack_source_node.wyze-shopify.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}

resource "rudderstack_connection" "example7" {
  source_id      = rudderstack_source_node.wyze-tracking-plan-source.id
  destination_id = rudderstack_destination_snowflake.wyze-warehouse.id
}