view: user_orders_facts {
  derived_table: {
    distribution: "all"
    sortkeys: ["user_id"]
    datagroup_trigger: etl_datagroup_2
    sql: SELECT user_id,
      COUNT(id) as lifetime_orders,
      SUM(sale_price) as lifetime_revenue
      -- comment2
      FROM order_items
      GROUP BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: lifetime_orders {
    type: sum
    sql: ${TABLE}.lifetime_orders ;;
  }

  measure: lifetime_revenue {
    type: sum
    sql: ${TABLE}.lifetime_revenue ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue]
  }
}
