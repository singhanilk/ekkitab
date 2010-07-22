#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh

if [ ! -d $outputdir ] ; then
    mkdir -p $outputdir;
fi

TABLES=( "billdesk_api_debug" 
         "catalogsearch_query" 
         "ccav_api_debug"
         "customer_address_entity"
         "customer_address_entity_varchar"
         "customer_address_entity_int"
         "customer_address_entity_datetime"
         "customer_address_entity_text"
         "customer_address_entity_decimal"
         "customer_entity"
         "customer_entity_varchar"
         "customer_entity_text"
         "customer_entity_int"
         "customer_entity_decimal"
         "customer_entity_datetime"
         "directory_currency_rate"
         "log_customer"
         "log_quote"
         "log_url"
         "log_url_info"
         "log_visitor"
         "log_visitor_info"
         "paypal_api_debug"
         "poll"
         "poll_answer"
         "poll_store"
         "poll_vote"
         "report_event"
         "report_event_types"
         "review"
         "review_detail"
         "review_entity"
         "review_entity_summary"
         "review_status"
         "review_store"
         "sales_flat_order_item"
         "sales_flat_quote"
         "sales_flat_quote_address"
         "sales_flat_quote_address_item"
         "sales_flat_quote_item"
         "sales_flat_quote_item_option"
         "sales_flat_quote_payment"
         "sales_flat_quote_shipping_rate"
         "sales_order"
         "sales_order_datetime"
         "sales_order_decimal"
         "sales_order_entity"
         "sales_order_entity_datetime"
         "sales_order_entity_decimal"
         "sales_order_entity_int"
         "sales_order_entity_text"
         "sales_order_entity_varchar"
         "sales_order_int"
         "sales_order_tax"
         "sales_order_text"
         "sales_order_varchar"
         "wishlist"
         "wishlist_item" )

count=${#TABLES[@]}

for ((i=0; i < $count; i++)) ; do
   mysqldump -u $user -p$password -h $host ekkitab_books ${TABLES[$i]} > $outputdir/${TABLES[$i]}.sql
   if (( $? > 0 )) ; then
     echo "WARNING: table - ${TABLES[$i]} - could not be backed up. "
   fi
done
exit 1

