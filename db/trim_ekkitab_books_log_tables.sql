use ekkitab_books;
-- Trim the log_url_info table.
delete from log_url_info where url_id in ( select url_id from log_url where datediff(now(), visit_time) > 15 );
-- Trim the log_url table
delete from log_url where datediff(now(), visit_time) > 15;
-- Trim the log_visitor_info table.
delete from log_visitor_info where visitor_id in ( select visitor_id from log_visitor where datediff(now(), last_visit_at) > 15 );
-- Trim the log_visitor table.
delete from log_visitor where datediff(now(), last_visit_at) > 15;
-- Trim the report_event  table.
delete from report_event where datediff(now(), logged_at) > 15;
