view: order_items_dimensions {
  extension: required
  dimension: sale_price {
    sql: ${TABLE}.sale_price ;;
  }
}

view: order_items_actual {
  extends: [order_items_dimensions]
  dimension: sale_price_extended {
    sql:  ;;
  }
}

view: global_filter {
  filter: global_filter {
    type: date_time
  }
}

view: order_items {
  sql_table_name:
  {% if created_date._in_query %}
  public.order_items
  {% else %}
  public.order_items_aggregated
  {% endif %}
  ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: test_case {
    order_by_field: id
    alpha_sort: no
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {

    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

# filter: sale_price_filter {
#   sql:  ;;
# }

  dimension: sale_price {
    description: "FILTER ONLY - Not aggregated"
    label: "Sale Price FOR FILTERING"
    # hidden: yes
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: profit {
    type: number
    value_format_name: usd
    sql: ${sale_price} -
      ${inventory_items.cost} ;;
  }


  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    view_label: "Measures"
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    view_label: "Measures"
    label: "Total Revenue (Ex Vat)"
    description: "Sum of Sale Price (Excluding VAT)"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
