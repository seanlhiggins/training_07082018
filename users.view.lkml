view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
# Test
  dimension: age {
    group_label: "Age"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    group_label: "Age"
    type: tier
    sql: ${age} ;;
    tiers: [10,20,30,40,50]
    style: integer
  }

  dimension: is_under_30_years_old {
    group_label: "Age"
    type: yesno
    sql: ${age} < 30 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }


  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date, day_of_week,
      week,
      month, month_num,month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }



  dimension: days_since_signup {
    hidden: yes
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }
  parameter: test {
    type: unquoted

  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    action: {
      label: "Send Campaign Test"
      url: "https://example.com/posts"
      param: {
        name: "some_auth_code"
        value: "{{test._parameter_value}}"
      }
      form_param: {
        name: "title"
        required: yes
        default: "{{test._parameter_value}}"
      }
      form_param: {
        default: "{{created_date._value}}"
        name: "body"
        type: textarea
        required: yes
      }
      form_param: {
        name: "Type"
        type: select
        default: "Campaign"
        option: {
          name: "Creative"
          label: "Creative"
        }
        option: {
          name: "Campaign"
          label: "Campaign"
        }
        option: {
          name: "Group"
        }
      }
    }
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: percent_new_users {
    type: number
    sql: 1.0 * ${count_new_users} / NULLIF(${count},0) ;;
    value_format_name: percent_3
  }

  measure: count_new_users {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: days_since_signup
      value: "<7"
    }
  }

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
