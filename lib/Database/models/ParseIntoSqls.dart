class ParseIntoSqls {
  Map<String, String> parseIntoSqls = <String, String>{
  'version_infos': 'CREATE TABLE version_infos (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,saved_version TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'tokens': 'CREATE TABLE tokens (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,access_token TEXT,refresh_token TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'users': 'CREATE TABLE users (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,username TEXT,email TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'uploads': 'CREATE TABLE uploads (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,table_name TEXT,row_id INTEGER UNSIGNED,row_atid INTEGER UNSIGNED,row_uuid TEXT,updated_columns TEXT,curd_status INTEGER,upload_status INTEGER,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'download_modules': 'CREATE TABLE download_modules (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,module_name TEXT,download_status INTEGER,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'pn_pending_pool_nodes': 'CREATE TABLE pn_pending_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,recommend_raw_rule_atid INTEGER UNSIGNED,recommend_raw_rule_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'pn_memory_pool_nodes': 'CREATE TABLE pn_memory_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,using_raw_rule_atid INTEGER UNSIGNED,using_raw_rule_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'pn_complete_pool_nodes': 'CREATE TABLE pn_complete_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,used_raw_rule_atid INTEGER UNSIGNED,used_raw_rule_uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'pn_rule_pool_nodes': 'CREATE TABLE pn_rule_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,type INTEGER,name TEXT,position TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'fragments_about_pending_pool_nodes': 'CREATE TABLE fragments_about_pending_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,raw_fragment_atid INTEGER UNSIGNED,raw_fragment_id_uuid TEXT,pn_pending_pool_node_atid INTEGER UNSIGNED,pn_pending_pool_node_uuid TEXT,recommend_raw_rule_atid INTEGER UNSIGNED,recommend_raw_rule_uuid TEXT,title TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'fragments_about_memory_pool_nodes': 'CREATE TABLE fragments_about_memory_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,fragments_about_pending_pool_node_atid INTEGER UNSIGNED,fragments_about_pending_pool_node_uuid TEXT,using_raw_rule_atid INTEGER UNSIGNED,using_raw_rule_uuid TEXT,pn_memory_pool_node_atid INTEGER UNSIGNED,pn_memory_pool_node_uuid TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'fragments_about_complete_pool_nodes': 'CREATE TABLE fragments_about_complete_pool_nodes (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,fragments_about_pending_pool_node_atid INTEGER UNSIGNED,fragments_about_pending_pool_node_uuid TEXT,used_raw_rule_atid INTEGER UNSIGNED,used_raw_rule_uuid TEXT,pn_complete_pool_node_atid INTEGER UNSIGNED,pn_complete_pool_node_uuid TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)',
  'rules': 'CREATE TABLE rules (id INTEGER UNSIGNED PRIMARY_KEY AUTO_INCREMENT,atid INTEGER,uuid TEXT,raw_rule_atid INTEGER UNSIGNED,raw_rule_uuid TEXT,pn_rule_pool_node_atid INTEGER UNSIGNED,pn_rule_pool_node_uuid TEXT,created_at INTEGER UNSIGNED,updated_at INTEGER UNSIGNED)'
};
}
