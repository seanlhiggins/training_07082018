connection: "events_ecommerce"

# include all the views
include: "*.view"

datagroup: training_07082018_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "24 hours"
}

datagroup: etl_datagroup_2 {
  max_cache_age: "1 hour"
  sql_trigger: SELECT CURRENT_DATE ;;
}

explore: globals {
  extension: required
  join: global_filter {}
}

persist_with: training_07082018_default_datagroup

explore: distribution_centers {}

explore: etl_jobs {}

explore: events {
  sql_always_where: [_user_attributes.['country'] = ${users.country} ;;
  persist_with: etl_datagroup_2
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: globals {

  }
}

# explore: foo {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  persist_with: etl_datagroup_2

 conditionally_filter: {
  filters: {
    field: users.country
    value: "USA"
  }
  unless: [created_date]
 }

  label: "Order Items Explore"
  description: "This is a description"
  fields: [ALL_FIELDS*, -order_items.profit]
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: user_orders_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_orders_facts.user_id} ;;
    relationship: one_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  access_filter: {
    field: city
    user_attribute: city
  }
  sql_always_where: {% condition global_filter.global_filter %} ${users.created_date} {% endcondition %} ;;
  extends: [globals]
  join: user_orders_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_orders_facts.user_id};;
    relationship: one_to_one
  }
}

explore: user_orders_facts {}
