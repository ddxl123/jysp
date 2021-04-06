class ParseIntoSqls {
  Map<String, String> parseIntoSqls = {
    "version_infos": "CREATE TABLE version_infos (saved_version TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)",
    "tokens": "CREATE TABLE tokens (access_token TEXT,refresh_token TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)",
    "users": "CREATE TABLE users (user_id INTEGER UNSIGNED,username TEXT,password TEXT,email TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "uploads": "CREATE TABLE uploads (table_name TEXT,row_id INTEGER UNSIGNED,row_uuid TEXT,upload_is_ok INTEGER,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)",
    "download_queue_modules": "CREATE TABLE download_queue_modules (module_name TEXT,download_is_ok INTEGER,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)",
    "download_queue_rows": "CREATE TABLE download_queue_rows (table_name TEXT,row_id INTEGER UNSIGNED,download_is_ok INTEGER,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)",
    "pn_pending_pool_nodes":
        "CREATE TABLE pn_pending_pool_nodes (pn_pending_pool_node_id INTEGER UNSIGNED,pn_pending_pool_node_uuid TEXT,recommend_raw_rule_id INTEGER UNSIGNED,recommend_raw_rule_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "pn_memory_pool_nodes":
        "CREATE TABLE pn_memory_pool_nodes (pn_memory_pool_node_id INTEGER UNSIGNED,pn_memory_pool_node_uuid TEXT,using_raw_rule_id INTEGER UNSIGNED,using_raw_rule_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "pn_complete_pool_nodes":
        "CREATE TABLE pn_complete_pool_nodes (pn_complete_pool_node_id INTEGER UNSIGNED,pn_complete_pool_node_uuid TEXT,used_raw_rule_id INTEGER UNSIGNED,used_raw_rule_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "pn_rule_pool_nodes":
        "CREATE TABLE pn_rule_pool_nodes (pn_rule_pool_node_id INTEGER UNSIGNED,pn_rule_pool_node_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "fragments_about_pending_pool_nodes":
        "CREATE TABLE fragments_about_pending_pool_nodes (fragments_about_pending_pool_node_id INTEGER UNSIGNED,fragments_about_pending_pool_node_uuid TEXT,pn_pending_pool_node_id INTEGER UNSIGNED,pn_pending_pool_node_uuid TEXT,recommend_raw_rule_id INTEGER UNSIGNED,recommend_raw_rule_uuid TEXT,title INTEGER,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "fragments_about_memory_pool_nodes":
        "CREATE TABLE fragments_about_memory_pool_nodes (fragments_about_memory_pool_node_id INTEGER UNSIGNED,fragments_about_memory_pool_node_uuid TEXT,fragments_about_pending_pool_node_id INTEGER UNSIGNED,fragments_about_pending_pool_node_uuid TEXT,using_raw_rule_id INTEGER UNSIGNED,using_raw_rule_uuid TEXT,pn_memory_pool_node_id INTEGER UNSIGNED,pn_memory_pool_node_uuid TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "fragments_about_complete_pool_nodes":
        "CREATE TABLE fragments_about_complete_pool_nodes (fragments_about_complete_pool_node_id INTEGER UNSIGNED,fragments_about_complete_pool_node_uuid TEXT,fragments_about_pending_pool_node_id INTEGER UNSIGNED,fragments_about_pending_pool_node_uuid TEXT,used_raw_rule_id INTEGER UNSIGNED,used_raw_rule_uuid TEXT,pn_complete_pool_node_id INTEGER UNSIGNED,pn_complete_pool_node_uuid TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)",
    "rules":
        "CREATE TABLE rules (raw_rule_id INTEGER UNSIGNED,raw_rule_uuid TEXT,pn_rule_pool_node_id INTEGER UNSIGNED,pn_rule_pool_node_uuid TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED,curd_status INTEGER)"
  };
}
