class { '::mysql::server':
  restart => true,
  override_options => {
    'mysqld' => {
      'bind_address' => '0.0.0.0'
    }
  }
}

mysql::db { 'tryDB':
  user => 'asampaio',
  password => 'as132476',
  host => '%',
  grant => ['ALL PRIVILEGES'],
  require => Service['mysqld'],
  sql => [ '/home/asampaio/mysql/script/schema.sql',
           '/home/asampaio/mysql/script/data.sql' ]
}